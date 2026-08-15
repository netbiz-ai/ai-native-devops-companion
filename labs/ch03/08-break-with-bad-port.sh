#!/usr/bin/env bash
# Chapter 3, Break It Deliberately - start with a non-numeric port to force a safe failure
#
# Label: Runnable
#
# Expected result, per the chapter:
#   ValueError: APP_PORT must be an integer
#
# --- command as printed, verbatim ---
APP_PORT=not-a-port python3 -m src.app
