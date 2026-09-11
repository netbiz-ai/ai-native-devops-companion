#!/usr/bin/env bash
# The delivery lab - CH04, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
rm -f ch04-bootstrap-evidence.json
git branch --list 'lab/delivery*'
git status --short
