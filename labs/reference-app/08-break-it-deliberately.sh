#!/usr/bin/env bash
# The reference-app lab - CH02, Break It Deliberately
#
# Label: Runnable - expected to fail
#
# Expected result, per the chapter:
#   ValueError: APP_PORT must be an integer
# --- command as printed, verbatim ---
APP_PORT=not-a-port python3 -m src.app
