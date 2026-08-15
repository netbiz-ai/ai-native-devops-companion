#!/usr/bin/env bash
# Chapter 16, Step 3 - Define one verification entry point - top-level verifier script listing
#
# Label: Partial
# The reader must implement and test the helper scripts this dispatches to
# (scripts/verify-release-identity.sh, verify-delivery-gates.sh, verify-runtime-state.sh,
# verify-service-targets.sh, verify-security-controls.sh, verify-agent-boundaries.sh,
# verify-cost-guardrail.sh, verify-cleanup.sh, verify-final-manifest.sh) before it will run.
# --- command as printed, verbatim ---
#!/usr/bin/env bash
set -euo pipefail

mode="${1:-all}"

case "$mode" in
  identity) ./scripts/verify-release-identity.sh ;;
  delivery) ./scripts/verify-delivery-gates.sh ;;
  runtime) ./scripts/verify-runtime-state.sh ;;
  reliability) ./scripts/verify-service-targets.sh ;;
  security) ./scripts/verify-security-controls.sh ;;
  agent) ./scripts/verify-agent-boundaries.sh ;;
  cost) ./scripts/verify-cost-guardrail.sh ;;
  cleanup) ./scripts/verify-cleanup.sh ;;
  final) ./scripts/verify-final-manifest.sh ;;
  all)
    "$0" identity
    "$0" delivery
    "$0" runtime
    "$0" reliability
    "$0" security
    "$0" agent
    "$0" cost
    ;;
  *)
    printf 'Usage: %s {identity|delivery|runtime|reliability|security|agent|cost|cleanup|all|final}\n' "$0" >&2
    exit 2
    ;;
esac
