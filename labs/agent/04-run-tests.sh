#!/usr/bin/env bash
# The agent lab, Test and Validate - run unit tests and list the agent identity's effective permissions
#
# Label: Runnable (unlabeled in the chapter)
#
# --- command as printed, verbatim ---
cd agents/k8s-diagnostics
. .venv/bin/activate
python -m pytest -q
kubectl auth can-i --list \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n reference-staging
