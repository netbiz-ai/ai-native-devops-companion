#!/usr/bin/env bash
# The reference-app lab, Cost and Cleanup - verify no listener remains and only intended files appear
#
# Label: Runnable (unlabeled in the chapter)
#
# Stop the servers from 05/10 (Ctrl-C in their terminals) before running this.
#
# Expected result, per the chapter:
#   The probe prints a nonzero code and the block exits nonzero if a listener remains.
#   `git status --short` should show only intended files.
# --- command as printed, verbatim ---
set -e
python3 -c 'import socket, sys; s=socket.socket(); c=s.connect_ex(("127.0.0.1", 8080)); print(c); sys.exit(1 if c == 0 else 0)'
git status --short
