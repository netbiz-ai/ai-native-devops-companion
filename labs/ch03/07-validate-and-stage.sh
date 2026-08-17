#!/usr/bin/env bash
# Chapter 3, Test and Validate - rerun tests, compile, and stage the intended files
#
# Label: Runnable
#
# Before this step, write evidence/ch03-validation.txt as the chapter's Test and
# Validate section describes (date, commands, results, controlled failure, one
# limitation); this block stages it and fails if the suite or compilation fails.
# --- command as printed, verbatim ---
set -e
python3 -m unittest discover -v
python3 -m compileall -q src tests
rm -f evidence/.gitkeep
git add .gitignore README.md src tests docs evidence/ch03-validation.txt
git diff --cached --check
