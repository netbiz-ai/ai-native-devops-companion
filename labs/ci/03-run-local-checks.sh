#!/usr/bin/env bash
# Chapter 5, Build It Step 1 - install pinned dev tools and run lint, tests, and Bandit
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Ruff reports no lint errors.
#   All unittest cases pass.
#   Bandit reports no finding at Medium or higher severity and confidence.
# --- command as printed, verbatim ---
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements-dev.txt
ruff check src tests
python -m unittest discover -v
bandit -q -r src -ll -ii
