#!/usr/bin/env bash
# Chapter 3, Troubleshooting - check whether something is listening on port 8080
#
# Label: Runnable
#
# Expected result, per the chapter:
#   This is a diagnostic: it prints the socket connect code and always exits 0.
#   0 means a listener accepted the connection; a nonzero code (such as 111)
#   means nothing is listening. Read the printed number, not the exit status.
# --- command as printed, verbatim ---
python3 -c 'import socket; s=socket.socket(); print(s.connect_ex(("127.0.0.1", 8080)))'
