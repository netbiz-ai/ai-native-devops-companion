#!/usr/bin/env bash
# The reference-app lab - CH02, Step 4 - Run and Inspect the Real Service
#
# Label: Runnable
#
# Expected result, per the chapter:
#   200 {"environment": "development", "service": "reference-app", "status": "ok"}
#   200 {"status": "healthy"}
#   200 {"status": "ready"}
#   404 {"error": "not_found", "path": "/missing"}
# --- command as printed, verbatim ---
python3 - <<'PY'
from urllib.error import HTTPError
from urllib.request import urlopen

base = "http://127.0.0.1:8080"
for path in ("/", "/health", "/ready", "/missing"):
    try:
        with urlopen(base + path, timeout=2) as response:
            print(response.status, response.read().decode("utf-8"))
    except HTTPError as exc:
        print(exc.code, exc.read().decode("utf-8"))
PY
