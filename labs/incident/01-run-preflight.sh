#!/usr/bin/env bash
# The incident lab, Prerequisites - start the chapter state and run the lab preflight checks
#
# Label: Runnable
#
# Expected result, per the chapter:
#   PASS: context targets the disposable lab cluster
#   PASS: namespace reference-incident is reachable
#   PASS: reference application is healthy
#   PASS: observability queries return baseline data
#   PASS: incident scripts affect only reference-incident
# --- command as printed, verbatim ---
make incident-start
test -x labs/incident/preflight.sh
labs/incident/preflight.sh
