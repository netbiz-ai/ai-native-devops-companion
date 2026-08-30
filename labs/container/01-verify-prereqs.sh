#!/usr/bin/env bash
# Chapter 4, Prerequisites - confirm the Chapter 3 state and start the service
#
# Label: Runnable
#
# --- command as printed, verbatim ---
test -f src/app.py
test -f tests/test_app.py
APP_ENV=development APP_PORT=8080 python3 -m src.app
