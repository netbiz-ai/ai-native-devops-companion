#!/usr/bin/env bash
# The gitops lab - CH07, Symptom: The Application Remains OutOfSync
#
# Label: Runnable
# --- command as printed, verbatim ---
argocd app get reference-staging --refresh
argocd app diff reference-staging
kubectl -n argocd describe application reference-staging
