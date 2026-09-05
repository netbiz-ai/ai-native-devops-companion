#!/usr/bin/env bash
# Remove the capstone's temporary resources and record what was removed.
#
# labs/capstone/04-run-cleanup.sh calls this and it did not exist, which left the
# chapter's one Destructive command - the one that clears the cluster, registry
# and cloud resources the capstone stood up - with nothing to run. It also left
# CAP-07-cleanup with no way to become supported, because the cleanup evidence
# it checks is what this script writes.
#
# It removes only what the labs create, by name, and only in the current
# kubectl context. It does not delete a cluster, a cloud account's resources, or
# anything it cannot identify as this book's: a cleanup script that guesses is
# more dangerous than no cleanup script.
#
# Terraform and cloud resources are Chapter 7's, and are removed by
# labs/infrastructure/07-destroy-lab.sh against the reader's own approved sandbox. This
# script records whether that was done rather than doing it, because it has no
# way to know which account is approved.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

evidence="${CAPSTONE_CLEANUP_EVIDENCE:-evidence/capstone/summary/cleanup.txt}"
context="$(kubectl config current-context 2>/dev/null || echo "none")"

# The teardown has to say which acceptance run it tore down. Without that, the
# file it writes is indistinguishable from the one an earlier run left behind,
# and the verifier cannot tell a current teardown from a retained one.
run_id="${CAPSTONE_RUN_ID:-$(sed -n 's/^run_id:[[:space:]]*//p' \
  docs/capstone/evidence-manifest.yaml 2>/dev/null | head -1)}"
if [ -z "$run_id" ]; then
  printf 'STOP: no acceptance run declared. Export CAPSTONE_RUN_ID before cleanup.\n' >&2
  exit 1
fi

# The lab namespaces, and nothing else. reference-dev is Chapter 8's,
# staging and production Chapter 9's, incident Chapter 12's, observability
# Chapter 10's, lab-source the disposable Git server, capstone-iac the
# capstone's Terraform-managed namespace - normally already destroyed by
# `terraform -chdir=infrastructure/terraform/capstone destroy`, listed here
# as a backstop so a skipped destroy still gets recorded and removed.
namespaces=(
  reference-dev
  reference-staging
  reference-production
  reference-incident
  observability
  lab-source
  capstone-iac
)
# The Argo CD Applications this book's chapters create, and only those.
applications=(
  reference-staging
  reference-production
)
images=(
  ai-native-devops/reference-service:baseline
  ai-native-devops/reference-service:broken
  ai-native-devops/reference-service:chapter04
  ai-native-devops/reference-service:chapter05
)

if [ "${CAPSTONE_CLEANUP_CONFIRMED:-}" != "$context" ]; then
  cat >&2 <<MSG
STOP: cleanup is not confirmed for this context.

This would delete these namespaces from the cluster at:

  ${context}

  ${namespaces[*]}

and remove the lab images listed in this script. Re-run with the context
named explicitly, so that confirming is a decision about one cluster rather
than a habit:

  CAPSTONE_CLEANUP_CONFIRMED=${context} scripts/capstone-cleanup.sh
MSG
  exit 1
fi

mkdir -p "$(dirname "$evidence")"
: >"$evidence"

record() { printf '%s\n' "$1" | tee -a "$evidence"; }

record "capstone cleanup"
record "run_id: ${run_id}"
record "context: ${context}"
record "run_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
record ""
record "namespaces"
for namespace in "${namespaces[@]}"; do
  if kubectl get namespace "$namespace" >/dev/null 2>&1; then
    kubectl delete namespace "$namespace" --wait=true >/dev/null 2>&1 \
      && record "  deleted   ${namespace}" \
      || record "  FAILED    ${namespace}"
  else
    record "  absent    ${namespace}"
  fi
done

record ""
record "argo cd applications and project"
if kubectl get crd applications.argoproj.io >/dev/null 2>&1; then
  # By name, like the namespaces. Deleting every Application the namespace
  # happens to list makes the blast radius depend on who else shares the
  # cluster, which is not something this script can know and not something the
  # reader agreed to when they confirmed a context. Anything else present is
  # recorded as left alone, so the narrowing is visible in the evidence rather
  # than only in this comment.
  for name in "${applications[@]}"; do
    if kubectl -n argocd get "application/${name}" >/dev/null 2>&1; then
      kubectl -n argocd delete "application/${name}" --cascade=false >/dev/null 2>&1 \
        && record "  deleted   application.argoproj.io/${name}" \
        || record "  FAILED    application.argoproj.io/${name}"
    else
      record "  absent    application.argoproj.io/${name}"
    fi
  done
  for found in $(kubectl -n argocd get applications -o name 2>/dev/null); do
    case " ${applications[*]} " in
      *" ${found#application.argoproj.io/} "*) ;;
      *) record "  left      ${found} (not this book's)" ;;
    esac
  done
  if kubectl -n argocd get appproject ai-native-devops >/dev/null 2>&1; then
    kubectl -n argocd delete appproject ai-native-devops >/dev/null 2>&1 \
      && record "  deleted   appproject/ai-native-devops" \
      || record "  FAILED    appproject/ai-native-devops"
  else
    record "  absent    appproject/ai-native-devops"
  fi
else
  record "  absent    argo cd is not installed in this cluster"
fi

record ""
record "local images"
if command -v docker >/dev/null 2>&1; then
  for image in "${images[@]}"; do
    if docker image inspect "$image" >/dev/null 2>&1; then
      docker image rm "$image" >/dev/null 2>&1 \
        && record "  removed   ${image}" || record "  FAILED    ${image}"
    else
      record "  absent    ${image}"
    fi
  done
else
  record "  skipped   docker is not installed"
fi

record ""
record "not handled here"
record "  cloud infrastructure: labs/infrastructure/07-destroy-lab.sh, against your own"
record "    approved sandbox. This script cannot know which account that is."
record "  registry tags you pushed: remove them in your registry."
record "  the cluster itself: delete it the way you created it."

record ""
if grep -q 'FAILED' "$evidence"; then
  record "cleanup=incomplete - see the FAILED lines above"
  exit 1
fi
record "cleanup=complete"
