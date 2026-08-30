#!/usr/bin/env bash
# Chapter 3, Step 4 - probe the root, health, and missing routes over HTTP
#
# Label: Runnable
#
# Expected result, per the chapter:
#   {"environment": "development", "service": "reference-app", "status": "ok"}
#   {"environment": "development", "service": "reference-app", "status": "ok"}
#   {"status": "healthy"}
#   404
#
# --- command as printed, verbatim ---
curl --fail-with-body http://127.0.0.1:8080/ && printf '\n'
curl --fail-with-body 'http://127.0.0.1:8080/?probe=1' && printf '\n'
curl --fail-with-body http://127.0.0.1:8080/health && printf '\n'
curl --silent --output /dev/null --write-out '%{http_code}\n' \
  http://127.0.0.1:8080/missing
