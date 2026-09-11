#!/usr/bin/env bash
set -euo pipefail

echo "This repository does not mutate a live environment automatically."
echo "Restore proposal:"
echo "  1. Identify the last known-good immutable image digest."
echo "  2. Review the GitOps diff that restores that digest."
echo "  3. Obtain approval through the protected production environment."
echo "  4. Merge the reviewed change and verify health, readiness, and SLOs."
