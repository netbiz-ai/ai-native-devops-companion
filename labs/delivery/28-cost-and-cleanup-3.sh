#!/usr/bin/env bash
# The delivery lab - CH04, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
gh api '/user/packages?package_type=container' --jq '.[].name'
gh api --method DELETE '/user/packages/container/PACKAGE_NAME'
gh repo delete OWNER/REPOSITORY --yes
