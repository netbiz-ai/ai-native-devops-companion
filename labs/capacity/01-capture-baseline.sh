#!/usr/bin/env bash
# capacity lab, Step 1 - Establish the accepted baseline - start the lab, run preflight, capture baseline evidence
#
# Label: Runnable
# Destructive: make capacity-start deploys the capacity lab state into the disposable cluster
#
# Expected result, per the chapter:
#   PASS: context targets the disposable lab cluster
#   PASS: reference application is healthy
#   PASS: GitOps state matches the accepted revision
#   PASS: approved telemetry queries return data
#   PASS: restore path is available
#   PASS: baseline evidence written to evidence/ch13/baseline.json
# --- command as printed, verbatim ---
make capacity-start
test -x labs/capacity/preflight.sh
labs/capacity/preflight.sh
labs/capacity/capture-baseline.sh \
  --namespace reference-optimization \
  --output evidence/ch13/baseline.json
