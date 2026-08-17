#!/usr/bin/env bash
# Chapter 1, Build It / Step 1 - the samples/release-gate.sh script body (with its deliberate defect)
#
# Label: Runnable
#
# This file is the script body, not a command: write everything below the
# marker to ai-native-workspace/samples/release-gate.sh (as Step 1 does) and
# run it from there. Executing this file in place only prints the gate's
# failure message and creates nothing.
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
