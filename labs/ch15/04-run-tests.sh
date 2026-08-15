#!/usr/bin/env bash
# Chapter 15, Test and Validate - run unit tests and list the agent identity's effective permissions
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
