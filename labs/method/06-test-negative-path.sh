#!/usr/bin/env bash
# Chapter 1, Break It Deliberately - negative test against a missing artifact
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The wrapper prints `FAIL: missing artifact returned success` and returns status 1.
#   The script prints a failure message but still exits with status 0.
#   (After the correction to `exit 1`, the negative test should produce only the
#   script's failure message, and the wrapper should return status 0.)
# --- command as printed, verbatim ---
if bash samples/release-gate.sh artifacts/missing.tar; then
    echo "FAIL: missing artifact returned success"
    exit 1
fi
