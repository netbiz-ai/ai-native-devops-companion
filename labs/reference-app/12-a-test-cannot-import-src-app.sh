#!/usr/bin/env bash
# The reference-app lab - CH02, Symptom: A Test Cannot Import `src.app`
#
# Label: Runnable
# --- command as printed, verbatim ---
pwd
python3 -c 'from src.app import Settings; print(Settings.from_environment())'
