#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal three
# --- command as printed, verbatim ---
end_time=$((SECONDS + 660))
while (( SECONDS < end_time )); do
  curl --fail --silent -H 'X-CH10-Delay-Ms: 750' \
    http://127.0.0.1:8080/ >/dev/null
  sleep 4
done
