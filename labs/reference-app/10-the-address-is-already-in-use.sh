#!/usr/bin/env bash
# The reference-app lab - CH02, Symptom: The Address Is Already in Use
#
# Label: Runnable
# --- command as printed, verbatim ---
python3 -c 'import socket; s=socket.socket(); print(s.connect_ex(("127.0.0.1", 8080)))'
