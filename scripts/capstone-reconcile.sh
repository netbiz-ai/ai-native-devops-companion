#!/usr/bin/env bash
# Produce the capstone's CAP-03 evidence: infrastructure state, the approved
# declaration, and the live object compared for one acceptance run.
#
# CAP-03 needs a drift result, and a drift result needs applied state. The
# local route applies infrastructure/terraform/capstone - one namespace and
# one ConfigMap on the lab cluster, local state, no cloud account - then
# detects an induced out-of-band change, reconciles it, and proves the second
# plan is clean. The cloud-sandbox route reads the same drift result from
# The infrastructure lab's sandbox workspace instead, for a reader whose approved account
# still holds that state.
#
# Route selection:
#   CAPSTONE_IAC_ROUTE=local-kind      (default) apply, drift, reconcile locally
#   CAPSTONE_IAC_ROUTE=cloud-sandbox   read drift from infrastructure/terraform/environments/dev
#
# The evidence file records which route produced it.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

route="${CAPSTONE_IAC_ROUTE:-local-kind}"
evidence="${CAPSTONE_RECONCILE_EVIDENCE:-evidence/capstone/runtime/reconciliation.txt}"
run_id="${CAPSTONE_RUN_ID:-capstone-acceptance-001}"

mkdir -p "$(dirname "$evidence")"
: >"$evidence"

record() { printf '%s\n' "$1" | tee -a "$evidence"; }

# terraform plan -detailed-exitcode: 0 no changes, 1 error, 2 changes present.
#
# The plan is given the same variables as the apply. A plan run without them
# compares live state against the declaration's defaults, so a run identifier
# that is not the default reads as drift on the very first baseline - a false
# failure that says nothing about the infrastructure.
plan_exitcode() {
  local dir="$1"
  shift
  set +e
  terraform -chdir="$dir" plan -detailed-exitcode -input=false "$@" >/dev/null 2>&1
  local code=$?
  set -e
  printf '%s' "$code"
}

record "criterion=CAP-03 observed_at=$(date -u +%Y-%m-%dT%H:%M:%SZ) route=${route}"
record "run_id=${run_id}"

case "$route" in
  local-kind)
    dir="infrastructure/terraform/capstone"
    context="$(kubectl config current-context)"
    record "iac_config=${dir} backend=local kube_context=${context}"

    terraform -chdir="$dir" init -input=false >/dev/null

    # Read the contract this cluster already carries, before the apply
    # overwrites it. Comparing the three copies only after applying is close to
    # circular - the apply is what sets them - so the question worth asking is
    # asked first: is this cluster still holding another acceptance run's
    # platform? Starting run N on run N-1's infrastructure is how two runs'
    # observations end up in one evidence set.
    preexisting_run_id="$(kubectl -n capstone-iac get configmap platform-contract \
      -o jsonpath='{.data.run_id}' 2>/dev/null || printf '')"
    if [ -n "$preexisting_run_id" ] && [ "$preexisting_run_id" != "$run_id" ]; then
      record "preexisting_run_id=${preexisting_run_id} declared_run_id=${run_id}"
      record "agreement=CAP-03 fails: this cluster still holds run ${preexisting_run_id}. Tear it down before accepting run ${run_id}."
      exit 1
    fi
    record "preexisting_contract=${preexisting_run_id:-none}"

    terraform -chdir="$dir" apply -auto-approve -input=false -var "run_id=${run_id}" >/dev/null
    record "applied=namespace/capstone-iac configmap/platform-contract"

    baseline="$(plan_exitcode "$dir" -var "run_id=${run_id}")"
    [ "$baseline" = "0" ] || { record "baseline_plan=dirty detailed_exitcode=${baseline}"; exit 1; }
    record "baseline_plan=clean detailed_exitcode=0"

    # The controlled failure: change the live object without changing the
    # declaration, the way real drift arrives.
    kubectl -n capstone-iac label configmap platform-contract drift-source=out-of-band --overwrite >/dev/null
    drifted="$(plan_exitcode "$dir" -var "run_id=${run_id}")"
    [ "$drifted" = "2" ] || { record "drift_detected=no detailed_exitcode=${drifted}"; exit 1; }
    record "induced_drift=configmap/platform-contract labelled out of band"
    record "drift_detected=yes detailed_exitcode=2"

    terraform -chdir="$dir" apply -auto-approve -input=false -var "run_id=${run_id}" >/dev/null
    reconciled="$(plan_exitcode "$dir" -var "run_id=${run_id}")"
    [ "$reconciled" = "0" ] || { record "post_reconcile_plan=dirty detailed_exitcode=${reconciled}"; exit 1; }
    record "reconciled=terraform apply removed the out-of-band change"
    record "post_reconcile_plan=clean detailed_exitcode=0"

    live_uid="$(kubectl -n capstone-iac get configmap platform-contract -o jsonpath='{.metadata.uid}')"
    record "live_object=configmap/platform-contract uid=${live_uid}"

    # What CAP-03 actually claims is that one run's declaration, the state that
    # recorded it, and the object now running all name the same run. That is
    # three values read from three places. Asserting the agreement instead of
    # reading them back is how a mismatch survives its own acceptance check, so
    # the comparison is made here and the criterion fails on disagreement.
    state_run_id="$(terraform -chdir="$dir" output -raw run_id 2>/dev/null || printf 'unreadable')"
    live_run_id="$(kubectl -n capstone-iac get configmap platform-contract \
      -o jsonpath='{.data.run_id}' 2>/dev/null || printf 'unreadable')"
    record "declared_run_id=${run_id} state_run_id=${state_run_id} live_run_id=${live_run_id}"
    if [ "$state_run_id" != "$run_id" ] || [ "$live_run_id" != "$run_id" ]; then
      record "run_id_agreement=no - the run asked for is not the run recorded"
      record "agreement=CAP-03 fails: declaration, state, and live object name different runs"
      exit 1
    fi
    record "run_id_agreement=yes compared=declaration,state,live_object"
    agreement="state, declaration, and live object agree for run ${run_id} on route ${route}"
    ;;
  cloud-sandbox)
    dir="infrastructure/terraform/environments/dev"
    record "iac_config=${dir} backend=local account=approved-sandbox-alias"

    if [ ! -e "$dir/terraform.tfstate" ] && [ ! -e "$dir/.terraform" ]; then
      record "drift_source=missing - apply the infrastructure lab's sandbox track first"
      exit 1
    fi
    drift="$(plan_exitcode "$dir")"
    case "$drift" in
      0) record "drift_detected=no detailed_exitcode=0" ;;
      2) record "drift_detected=yes detailed_exitcode=2 - reconcile before acceptance" ;;
      *) record "drift_check=error detailed_exitcode=${drift}"; exit 1 ;;
    esac
    record "live_object=cloud resources in the approved sandbox, inventoried by terraform state list"
    # This route has no per-run object to read the identifier back from, so the
    # run binding it can honestly claim is the drift result, not agreement
    # between three copies of a run identifier.
    record "run_id_agreement=not-applicable route=cloud-sandbox"
    agreement="drift state observed for run ${run_id} on route ${route}; run-id agreement is not established on this route"
    ;;
  *)
    printf 'Usage: CAPSTONE_IAC_ROUTE={local-kind|cloud-sandbox} %s\n' "$0" >&2
    exit 2
    ;;
esac

record "declared_source_revision=$(git rev-parse --short HEAD)"

if kubectl get crd applications.argoproj.io >/dev/null 2>&1; then
  apps="$(kubectl -n argocd get applications -o jsonpath='{range .items[*]}{.metadata.name}={.status.sync.revision} {end}' 2>/dev/null || true)"
  if [ -n "$apps" ]; then
    record "gitops_revision=${apps% }"
  else
    record "gitops_revision=no applications registered in this cluster"
  fi
else
  record "gitops_revision=argo cd is not installed in this cluster"
fi

record "agreement=${agreement}"
