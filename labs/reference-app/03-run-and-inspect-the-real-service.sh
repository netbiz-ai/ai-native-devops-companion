#!/usr/bin/env bash
# The reference-app lab - CH02, Step 4 - Run and Inspect the Real Service
#
# Label: Runnable
#
# Expected result, per the chapter:
#   service=reference-app environment=development listening=http://127.0.0.1:8080
# --- command as printed, verbatim ---
APP_ENV=development APP_PORT=8080 python3 -m src.app
