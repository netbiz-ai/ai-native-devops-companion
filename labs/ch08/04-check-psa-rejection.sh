#!/usr/bin/env bash
# Chapter 8, Build It Step 3 - prove Restricted admission rejects a noncompliant server-dry-run Pod
#
# Label: Runnable
#
# --- command as printed, verbatim ---
set +e
psa_output=$(kubectl run ch08-psa-negative \
  --namespace reference-dev \
  --image=example.invalid/never-pulled:check \
  --restart=Never \
  --dry-run=server \
  --output=name 2>&1)
psa_status=$?
set -e

if [ "$psa_status" -eq 0 ]; then
  echo "STOP: the noncompliant Pod passed admission" >&2
  exit 1
fi
if ! printf '%s\n' "$psa_output" | grep -Eqi 'PodSecurity|restricted|violat'; then
  echo "STOP: admission failed for an unrelated or unclear reason" >&2
  exit 1
fi
echo "Restricted Pod Security rejection confirmed."
