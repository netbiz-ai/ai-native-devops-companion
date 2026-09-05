#!/usr/bin/env bash
# The security lab, Troubleshooting "image scan cannot find the image" - confirm the commit-tagged image exists
#
# Label: Runnable
# --- command as printed, verbatim ---
docker image inspect "reference-app:${GITHUB_SHA}"
