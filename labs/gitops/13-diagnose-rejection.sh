#!/usr/bin/env bash
# Chapter 9, Troubleshooting - diagnose a controller-rejected resource or destination
#
# Label: Runnable
# --- command as printed, verbatim ---
argocd proj get reference-app
argocd app get reference-app-staging
kubectl -n argocd describe application reference-app-staging
