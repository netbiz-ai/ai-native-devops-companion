#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal two
# --- command as printed, verbatim ---
queries=(
  'job:http_requests:rate5m{environment="staging"}'
  'job:http_errors:ratio5m{environment="staging"}'
  'job:http_request_duration_seconds:p95_5m{environment="staging"}'
)
for query in "${queries[@]}"; do
  curl --fail --silent --get "$PROMETHEUS_URL/api/v1/query" \
    --data-urlencode "query=$query" | \
    jq -e '.status == "success" and (.data.result | length > 0)'
done

kubectl -n observability get deployment/otel-collector -o json | jq -e '
  .spec.template.spec.automountServiceAccountToken == false
  and (.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem == true)
  and (.spec.template.spec.containers[0].securityContext.capabilities.drop | index("ALL"))'
