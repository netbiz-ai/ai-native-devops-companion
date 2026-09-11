#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal two
# --- command as printed, verbatim ---
saw_pending=false
deadline=$((SECONDS + 720))
while (( SECONDS < deadline )); do
  state="$(alert_state)"
  printf 'alert_state=%s\n' "$state"
  [[ "$state" == pending ]] && saw_pending=true
  [[ "$state" == firing ]] && break
  sleep 15
done
$saw_pending
test "$state" = firing
deadline=$((SECONDS + 90))
until kubectl -n observability logs deployment/ch10-alert-sink --since=20m | \
  rg -q '"status": "firing"|"status":"firing"'; do
  (( SECONDS < deadline )) || exit 1
  sleep 5
done
