#!/usr/bin/env bash
# Chapter 5, Prerequisites - confirm the Chapter 4 repository state and passing tests
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The required files exist.
#   All reference application tests pass.
#   The worktree contains only expected changes.
# --- command as printed, verbatim ---
test -f src/app.py
test -f tests/test_app.py
test -f Dockerfile
test -f .dockerignore
python3 -m unittest discover -v
git status --short
