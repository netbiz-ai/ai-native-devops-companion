#!/usr/bin/env bash
# Push this working tree into the in-cluster lab Git server, so Argo CD has a
# source it can reach. Run it from the root of your clone, after applying
# git-server.yaml. Re-run it whenever you want Argo CD to see new commits;
# the pod's storage is an emptyDir, so a restarted pod needs seeding again.
#
#   deployment/gitops/lab-source/seed.sh
#   deployment/gitops/lab-source/seed.sh --ref my-branch --port 19418
#
# It pushes the commit you have checked out, not your uncommitted edits.
set -euo pipefail

namespace="${LAB_SOURCE_NAMESPACE:-lab-source}"
service="${LAB_SOURCE_SERVICE:-lab-git}"
branch="${LAB_SOURCE_BRANCH:-main}"
ref="HEAD"
port="${LAB_SOURCE_PORT:-19418}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ref) ref="$2"; shift 2 ;;
    --branch) branch="$2"; shift 2 ;;
    --port) port="$2"; shift 2 ;;
    --namespace) namespace="$2"; shift 2 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
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

kubectl -n "$namespace" port-forward "svc/$service" "$port:9418" >/dev/null 2>&1 &
forward=$!
# shellcheck disable=SC2064
trap "kill $forward 2>/dev/null || true" EXIT

for _ in $(seq 1 30); do
  if git ls-remote "git://127.0.0.1:$port/repo.git" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

commit="$(git rev-parse --verify "$ref")"
git push --force "git://127.0.0.1:$port/repo.git" "$commit:refs/heads/$branch"

cat <<EOF

Seeded $commit onto $branch.

Argo CD reads this source at:

  repoURL: git://$service.$namespace.svc.cluster.local/repo.git
  targetRevision: $branch

Set those two fields in deployment/gitops/argocd/staging-application.yaml and
deployment/gitops/argocd/production-application.yaml before applying them.
EOF
