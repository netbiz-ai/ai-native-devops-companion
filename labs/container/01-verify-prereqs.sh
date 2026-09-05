#!/usr/bin/env bash
# The container lab, Prerequisites - confirm the reference-app lab state and start the service
#
# Label: Runnable
#
# --- command as printed, verbatim ---
test -f src/app.py
test -f tests/test_app.py
APP_ENV=development APP_PORT=8080 python3 -m src.app
