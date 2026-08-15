#!/usr/bin/env bash
# Chapter 3, Test and Validate - rerun tests, compile, and stage the intended files
#
# Label: Runnable
#
# --- command as printed, verbatim ---
python3 -m unittest discover -v
python3 -m compileall -q src tests
rm evidence/.gitkeep
git add .gitignore README.md src tests docs evidence/ch03-validation.txt
git diff --cached --check
