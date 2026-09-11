#!/usr/bin/env bash
# The reference-app lab - CH02, Symptom: The Service Starts but a Route Fails
#
# Label: Runnable
# --- command as printed, verbatim ---
python3 -c 'from urllib.request import urlopen; print(urlopen("http://127.0.0.1:8080/ready", timeout=2).read().decode())'
git diff -- src/ tests/
