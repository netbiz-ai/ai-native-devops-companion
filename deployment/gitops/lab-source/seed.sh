#!/usr/bin/env bash
# Publish this working tree's checked-out commit to the in-cluster lab Git
# source, so Argo CD has a repository it can reach. Run it from the root of
# your clone, after applying git-server.yaml. Re-run it for every commit you
# want reconciled; the pod's storage is an emptyDir, so a restarted pod needs
# seeding again.
#
#   deployment/gitops/lab-source/seed.sh
#   deployment/gitops/lab-source/seed.sh --ref my-branch --branch main
#
# It publishes the commit you have checked out, not your uncommitted edits.
set -euo pipefail

namespace="${LAB_SOURCE_NAMESPACE:-lab-source}"
service="${LAB_SOURCE_SERVICE:-lab-git}"
branch="${LAB_SOURCE_BRANCH:-main}"
ref="HEAD"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ref) ref="$2"; shift 2 ;;
    --branch) branch="$2"; shift 2 ;;
    --namespace) namespace="$2"; shift 2 ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) printf 'unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done

command -v kubectl >/dev/null || { echo 'kubectl not found' >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 ||
  { echo 'run this from inside your clone of the companion' >&2; exit 1; }

if ! kubectl -n "$namespace" get deploy "$service" >/dev/null 2>&1; then
  printf 'no %s deployment in namespace %s; apply %s first\n' \
    "$service" "$namespace" 'deployment/gitops/lab-source/git-server.yaml' >&2
  exit 1
fi
kubectl -n "$namespace" rollout status "deploy/$service" --timeout=120s >/dev/null

commit="$(git rev-parse --verify "$ref^{commit}")"

# Build the bare repository locally, then copy it in through the API server.
# The daemon serves reads only, so this is the write path, and it needs no
# credential of its own beyond the cluster access you already have.
staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT
git init --quiet --bare "$staging/repo.git"
git push --quiet "$staging/repo.git" "$commit:refs/heads/$branch"
git --git-dir="$staging/repo.git" symbolic-ref HEAD "refs/heads/$branch"
git --git-dir="$staging/repo.git" repack -adq

# A pod being deleted still reports Running, and a copy into one is lost
# without an error. Take the first Running pod that is not terminating.
kubectl -n "$namespace" wait --for=condition=Ready pod \
  -l "app.kubernetes.io/name=$service" --timeout=120s >/dev/null
pod="$(kubectl -n "$namespace" get pod -l "app.kubernetes.io/name=$service" \
  -o jsonpath='{range .items[*]}{.metadata.name} {.status.phase} {.metadata.deletionTimestamp}{"\n"}{end}' |
  awk '$2 == "Running" && $3 == "" { print $1; exit }')"
[[ -n "$pod" ]] || { echo "no running $service pod in $namespace" >&2; exit 1; }

kubectl -n "$namespace" exec "$pod" -- rm -rf /srv/git/repo.git
kubectl -n "$namespace" cp "$staging/repo.git" "$pod:/srv/git/repo.git" >/dev/null

cat <<EOF

Published $commit as $branch.

Argo CD reads this source at:

  repoURL: git://$service.$namespace.svc.cluster.local/repo.git
  targetRevision: $branch

Set those two fields in deployment/gitops/argocd/staging-application.yaml and
deployment/gitops/argocd/production-application.yaml before applying them.
EOF
