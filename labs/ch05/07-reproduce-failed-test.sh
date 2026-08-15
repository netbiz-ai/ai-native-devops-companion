#!/usr/bin/env bash
# Chapter 5, Break It Deliberately Failure 1 - inspect the diff and reproduce the failing test locally
#
# Label: Runnable
# --- command as printed, verbatim ---
git diff origin/main -- tests/test_app.py
python3 -m unittest tests.test_app.RouteTests.test_health_returns_200 -v
