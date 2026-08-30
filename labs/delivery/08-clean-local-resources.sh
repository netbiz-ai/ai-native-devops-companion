#!/usr/bin/env bash
# Chapter 6, Cost and Cleanup - remove the named local staging container and review remaining images and worktree state
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The named staging container is absent.
#   Required release and rollback digests remain available.
#   The failed draft is absent only if deletion was intended.
#   Only expected chapter files remain in the worktree.
# --- command as printed, verbatim ---
docker rm -f reference-service-staging 2>/dev/null || true
docker image ls ghcr.io --digests
git status --short
