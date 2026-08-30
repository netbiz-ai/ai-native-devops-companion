#!/usr/bin/env bash
# Chapter 3, Step 1 - write the project .gitignore
#
# Label: Configuration
#
# Expected result, per the chapter:
#   reference-app/
#   ├── .git/
#   ├── .gitignore
#   ├── README.md
#   ├── docs/
#   ├── evidence/
#   │   └── .gitkeep
#   ├── src/
#   │   └── __init__.py
#   └── tests/
#       └── __init__.py
#
# --- command as printed, verbatim ---
printf '%s\n' \
  '__pycache__/' \
  '*.py[cod]' \
  '.pytest_cache/' \
  '.venv/' > .gitignore
