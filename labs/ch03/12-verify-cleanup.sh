#!/usr/bin/env bash
# Chapter 3, Cost and Cleanup - verify no listener remains and the Git tree is clean
#
# Label: Runnable (unlabeled in the chapter)
#
# --- command as printed, verbatim ---
python3 -c 'import socket; s=socket.socket(); print(s.connect_ex(("127.0.0.1", 8080)))'
git status --short
