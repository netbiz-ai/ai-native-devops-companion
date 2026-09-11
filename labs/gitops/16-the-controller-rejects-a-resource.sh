#!/usr/bin/env bash
# The gitops lab - CH07, Symptom: The Controller Rejects a Resource
#
# Label: Runnable
# --- command as printed, verbatim ---
argocd proj get ai-native-devops
argocd app get reference-staging
kubectl -n argocd describe application reference-staging
