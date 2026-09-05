#!/usr/bin/env bash
# reference-app lab, Step 1 - create the repository structure and initialize Git
#
# Label: Runnable
#
# Run this OUTSIDE the companion clone (see the ch03 README's "Two ways to
# enter this chapter"): inside the clone it creates a second git repository
# nested in a tree that already ships the finished reference-app. Skip it if
# you are working against the shipped app.
#
# --- command as printed, verbatim ---
mkdir -p reference-app/src reference-app/tests reference-app/docs reference-app/evidence
cd reference-app
git init
touch src/__init__.py tests/__init__.py evidence/.gitkeep README.md
