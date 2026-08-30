#!/usr/bin/env bash
# Chapter 10, Step 2 - Instrument and deploy one route - run unit tests and check the diff for whitespace errors
#
# Label: Runnable
# --- command as printed, verbatim ---
python -m unittest discover -s tests -v
git diff --check
