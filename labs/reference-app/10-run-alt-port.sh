#!/usr/bin/env bash
# The reference-app lab, Troubleshooting - restart the service on the unoccupied port 8081
#
# Label: Runnable (unlabeled in the chapter)
#
# Against the shipped reference-app, run `APP_PORT=8081 python3 src/app.py`
# instead (see 05's header). This blocks; run it in its own terminal.
# --- command as printed, verbatim ---
APP_PORT=8081 python3 -m src.app
