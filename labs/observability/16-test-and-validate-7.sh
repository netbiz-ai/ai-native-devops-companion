#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal two
# --- command as printed, verbatim ---
deadline=$((SECONDS + 420))
while (( SECONDS < deadline )); do
  state="$(alert_state)"
  printf 'recovery_state=%s\n' "$state"
  [[ "$state" == inactive ]] && break
  sleep 15
done
test "$state" = inactive
curl --fail --silent http://127.0.0.1:8080/ >/dev/null
kubectl -n reference-staging rollout status deployment/reference-app --timeout=90s
deadline=$((SECONDS + 90))
until kubectl -n observability logs deployment/ch10-alert-sink --since=30m | \
  rg -q '"status": "resolved"|"status":"resolved"'; do
  (( SECONDS < deadline )) || exit 1
  sleep 5
done
