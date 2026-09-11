#!/usr/bin/env bash
# incident lab, Step 1 - Establish the healthy baseline - create the incident record and capture baseline evidence
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Traffic generation completed.
#   Baseline service checks passed.
#   Evidence written to evidence/ch12/baseline.txt.
# --- command as printed, verbatim ---
mkdir -p docs/incidents evidence/ch12
cp incidents/templates/facts-incident-record.md \
  docs/incidents/ch12-controlled-failure.md
labs/incident/generate-traffic.sh --duration 60
labs/incident/capture-evidence.sh \
  --phase baseline \
  --output evidence/ch12/baseline.txt
