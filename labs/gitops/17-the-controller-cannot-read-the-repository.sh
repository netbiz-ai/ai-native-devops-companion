#!/usr/bin/env bash
# The gitops lab - CH07, Symptom: The Controller Cannot Read the Repository
#
# Label: Runnable
# --- command as printed, verbatim ---
grep -n 'repoURL:' deployment/gitops/argocd/*.yaml
grep -A3 -n 'sourceRepos:' deployment/gitops/argocd/project.yaml
argocd repo list
