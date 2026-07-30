#!/usr/bin/env bash
set -euo pipefail

required=(
  incidents/templates/facts-incident-record.md
  incidents/templates/post-incident-review.md
  observability/runbooks/high-latency.md
  deployment/gitops/overlays/staging/kustomization.yaml
)

for path in "${required[@]}"; do
  test -s "$path" || { printf 'missing=%s\n' "$path" >&2; exit 1; }
done

printf 'incident_preflight=pass mode=design-only\n'
