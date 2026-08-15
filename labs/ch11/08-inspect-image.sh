#!/usr/bin/env bash
# Chapter 11, Troubleshooting "image scan cannot find the image" - confirm the commit-tagged image exists
#
# Label: Runnable
# --- command as printed, verbatim ---
docker image inspect "reference-app:${GITHUB_SHA}"
