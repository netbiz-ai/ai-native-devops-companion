#!/usr/bin/env bash
# Chapter 16, Cost and Cleanup - remove the capstone's temporary resources
#
# Label: Runnable (unlabeled in the chapter)
# Destructive: deletes the capstone's temporary cluster, cloud, and registry resources and revokes temporary credentials
# --- command as printed, verbatim ---
bash scripts/capstone-cleanup.sh
