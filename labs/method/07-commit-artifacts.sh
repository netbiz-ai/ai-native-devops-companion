#!/usr/bin/env bash
# Chapter 1, Commit the artifacts - commit the workspace and tag the verified state
#
# Label: Runnable
# --- command as printed, verbatim ---
git add README.md context drafts evidence decisions samples artifacts
git commit -m "Verify AI-assisted release gate review"
git tag ch01-verified
