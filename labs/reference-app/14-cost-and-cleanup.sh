#!/usr/bin/env bash
# The reference-app lab - CH02, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
CHECK_PORT="${CHECK_PORT:-8080}" python3 -c 'import os, socket, sys; p=int(os.environ["CHECK_PORT"]); s=socket.socket(); c=s.connect_ex(("127.0.0.1", p)); print(c); sys.exit(1 if c == 0 else 0)'
