#!/usr/bin/env bash
# Put reference-app back on the experiment definition's baseline resources.
#
# labs/capacity/02-run-experiments.sh and 06-cleanup-namespace.sh both call this and
# it did not exist. run-experiment.sh restores the baseline itself at the end of
# a run, so this is for the cases where that did not happen: a run interrupted
# part way, or a namespace being handed to the next chapter.
#
# Restoring reads the declared baseline out of the definition rather than
# remembering what was there. A restore that trusts memory cannot be reviewed.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

# shellcheck source=labs/capacity/args.sh
. "${repo_root}/labs/capacity/args.sh"
ch13_parse_args "$@"

namespace="${CH13_NAMESPACE:-reference-incident}"
definition="${CH13_DEFINITION:-optimization/baseline.yaml}"

command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found" >&2; exit 1; }
test -s "$definition" || { echo "missing experiment definition: $definition" >&2; exit 1; }

field() {  # field SECTION KEY - the flat two-level YAML the definition uses
  awk -v section="$1" -v key="$2" '
    $0 ~ "^"section":" {inside=1; next}
    /^[a-z_]+:/ {inside=0}
    inside && $1 == key":" {gsub(/[",]/,"",$2); print $2; exit}
  ' "$definition"
}

kubectl -n "$namespace" get deployment reference-app >/dev/null 2>&1 || {
  echo "reference-app is not deployed in ${namespace}; nothing to restore" >&2
  exit 1
}

before="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')"

kubectl -n "$namespace" set resources deployment/reference-app \
  --containers=app \
  --requests="cpu=$(field baseline cpu_request),memory=$(field baseline memory_request)" \
  --limits="cpu=$(field baseline cpu_limit),memory=$(field baseline memory_limit)" >/dev/null
kubectl -n "$namespace" rollout status deployment/reference-app --timeout=180s >/dev/null

after="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')"
ready="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.status.readyReplicas}/{.status.replicas}')"

printf 'restore=complete namespace=%s cpu_request %s -> %s source=%s\n' \
  "$namespace" "${before:-unset}" "$after" "$definition"
printf 'ready_replicas=%s\n' "$ready"
