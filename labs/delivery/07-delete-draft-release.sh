#!/usr/bin/env bash
# Chapter 6, Cost and Cleanup - delete the failed training draft release after confirming it is a draft with the expected tag
#
# Label: Runnable
# Destructive: deletes a draft GitHub release in the training repository via gh
# --- command as printed, verbatim ---
gh auth status
repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
version="v0.0.0-training"
release_json="$(gh api "repos/$repo/releases/tags/$version")"
test "$(jq -r .tag_name <<<"$release_json")" = "$version"
test "$(jq -r .draft <<<"$release_json")" = "true"
jq '{tag_name, draft, html_url}' <<<"$release_json"
gh release delete "$version" --repo "$repo" --yes
