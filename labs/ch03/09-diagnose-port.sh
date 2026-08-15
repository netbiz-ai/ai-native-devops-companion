#!/usr/bin/env bash
# Chapter 3, Troubleshooting - check whether something is listening on port 8080
#
# Label: Runnable
#
# --- command as printed, verbatim ---
python3 -c 'import socket; s=socket.socket(); print(s.connect_ex(("127.0.0.1", 8080)))'
