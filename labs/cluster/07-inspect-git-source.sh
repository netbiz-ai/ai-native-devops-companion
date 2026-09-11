#!/usr/bin/env bash
# Interlude, Step 4 - look at the three places that will carry your Git source
#
# Label: Runnable
#
# Expected result, per the interlude:
#   Your origin, then one repoURL line from each application, then the
#   sourceRepos list and its single entry. Three places, one URL. This
#   block changes nothing.
# --- command as printed, verbatim ---
git remote get-url origin
grep -n 'repoURL:' \
  deployment/gitops/argocd/staging-application.yaml \
  deployment/gitops/argocd/production-application.yaml
grep -A1 -n 'sourceRepos:' deployment/gitops/argocd/project.yaml
