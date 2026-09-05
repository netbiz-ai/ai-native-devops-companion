#!/usr/bin/env bash
# reference-app lab, Step 4 - start the service with an explicit environment and port
#
# Label: Runnable
#
# Expected result, per the chapter:
#   service=reference-app environment=development listening=http://127.0.0.1:8080
#
# Against this repository's shipped reference-app the printed `-m src.app` form
# fails (`No module named 'telemetry'` - the app carries the observability lab refactor);
# run `APP_ENV=development APP_PORT=8080 python3 src/app.py` instead. The printed
# form works against the app as this chapter has you write it. This blocks; run it
# in its own terminal and probe with 06 from another.
# --- command as printed, verbatim ---
APP_ENV=development APP_PORT=8080 python3 -m src.app
