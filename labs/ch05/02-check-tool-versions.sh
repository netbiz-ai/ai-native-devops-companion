#!/usr/bin/env bash
# Chapter 5, Prerequisites - verify the required tool versions are installed
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Every command exits successfully.
#   Python reports version 3.12.x.
#   Docker reports a reachable client and server.
# --- command as printed, verbatim ---
git --version
python3 --version
python3 -m venv --help >/dev/null
docker version
curl --version
rg --version
actionlint -version
