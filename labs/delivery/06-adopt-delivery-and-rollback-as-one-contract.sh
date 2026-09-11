#!/usr/bin/env bash
# The delivery lab - CH04, Step 3 - Adopt Delivery and Rollback as One Contract
#
# Label: Runnable
# --- command as printed, verbatim ---
git show delivery-complete:.github/workflows/delivery.yml | sed -n '1,180p'
git show delivery-complete:.github/workflows/rollback.yml | sed -n '1,180p'
