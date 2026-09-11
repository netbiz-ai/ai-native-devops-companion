#!/usr/bin/env bash
# The security lab - CH09, Step 1 - Audit the Five Supplied Checks
#
# Label: Runnable
#
# Expected result, per the chapter:
#     sast:
#     dependencies:
#     secrets:
#     iac:
#     image:
#       name: SAST
#       name: Dependencies
#       name: Secrets
#       name: IaC
#       name: Image
# --- command as printed, verbatim ---
sed -n '1,240p' .github/workflows/security.yml
actionlint .github/workflows/security.yml
grep -E '^  (sast|dependencies|secrets|iac|image):$' \
  .github/workflows/security.yml
grep -E '^    name: (SAST|Dependencies|Secrets|IaC|Image)$' \
  .github/workflows/security.yml
