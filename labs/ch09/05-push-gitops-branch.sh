#!/usr/bin/env bash
# Chapter 9, Build It, Step 3 - publish the GitOps declarations on a review branch
#
# Label: Runnable
# --- command as printed, verbatim ---
git switch -c gitops/reference-app
git add deployment/kubernetes
git diff --cached --check
git commit -m "Add bounded GitOps environments"
git push -u origin gitops/reference-app
