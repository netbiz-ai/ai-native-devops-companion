#!/usr/bin/env bash
# Chapter 3, Step 1 - create the repository structure and initialize Git
#
# Label: Runnable
#
# --- command as printed, verbatim ---
mkdir -p reference-app/src reference-app/tests reference-app/docs reference-app/evidence
cd reference-app
git init
touch src/__init__.py tests/__init__.py evidence/.gitkeep README.md
