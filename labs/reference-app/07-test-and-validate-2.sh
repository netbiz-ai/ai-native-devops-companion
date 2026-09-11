#!/usr/bin/env bash
# The reference-app lab - CH02, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
python3 -c 'from urllib.request import urlopen; print(urlopen("http://127.0.0.1:8080/", timeout=2).read().decode())'
