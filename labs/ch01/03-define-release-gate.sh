#!/usr/bin/env bash
# Chapter 1, Build It / Step 1 - the samples/release-gate.sh script body (with its deliberate defect)
#
# Label: Runnable
# --- command as printed, verbatim ---
#!/usr/bin/env bash
set -u

artifact_path="${1:-}"

if [[ -f "$artifact_path" ]]; then
    echo "Release check passed: artifact exists"
    exit 0
fi

echo "Release check failed: artifact is missing"
exit 0
