#!/usr/bin/env bash
# The container lab, Break It Deliberately - diff the broken and working Dockerfiles to verify the cause
#
# Label: Runnable
#
# --- command as printed, verbatim ---
diff -u Dockerfile.broken Dockerfile
