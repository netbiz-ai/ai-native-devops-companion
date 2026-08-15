#!/usr/bin/env bash
# Chapter 11, Step 1 - fail on unresolved pin placeholders, then lint the workflow
#
# Label: Runnable
# --- command as printed, verbatim ---
if grep -Eq '<[A-Z_]+>' .github/workflows/security.yml; then
  echo "Unresolved workflow pin placeholder" >&2
  exit 1
fi
actionlint .github/workflows/security.yml
