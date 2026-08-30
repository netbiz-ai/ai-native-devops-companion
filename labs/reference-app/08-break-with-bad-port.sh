#!/usr/bin/env bash
# Chapter 3, Break It Deliberately - start with a non-numeric port to force a safe failure
#
# Label: Runnable
#
# Expected result, per the chapter:
#   ValueError: APP_PORT must be an integer
#
# Against the shipped reference-app, run `APP_PORT=not-a-port python3 src/app.py`
# instead (see 05's header). As printed, this exits nonzero with a different
# error entirely (`No module named 'telemetry'`) - confirm you see the
# ValueError, not just a failure.
# --- command as printed, verbatim ---
APP_PORT=not-a-port python3 -m src.app
