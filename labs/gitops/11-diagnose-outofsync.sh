#!/usr/bin/env bash
# The gitops lab, Troubleshooting - diagnose an application that remains OutOfSync
#
# Label: Runnable
# --- command as printed, verbatim ---
argocd app get reference-app-production --refresh
argocd app diff reference-app-production
git log -1 --oneline
