#!/usr/bin/env bash
# The delivery lab - CH04, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
git switch main
git pull --ff-only
git switch -c lab/delivery-refusal
