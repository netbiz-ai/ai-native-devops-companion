#!/usr/bin/env bash
# The delivery lab - CH04, Step 2 - Confirm the Reviewed CI Gate
#
# Label: Runnable
# --- command as printed, verbatim ---
git show delivery-complete:.github/workflows/ci.yml | sed -n '1,240p'
git checkout delivery-complete -- .github/workflows/ci.yml
actionlint .github/workflows/ci.yml
git diff --staged -- .github/workflows/ci.yml
