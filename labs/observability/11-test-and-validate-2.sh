#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal two
# --- command as printed, verbatim ---
capture_trace_id() {
  curl --silent --dump-header - http://127.0.0.1:8080/ \
    --output /dev/null | tr -d '\r' | \
    awk 'tolower($1) == "x-trace-id:" {print $2}'
}
trace_id_one="$(capture_trace_id)"
trace_id_two="$(capture_trace_id)"
[[ "$trace_id_one" =~ ^[0-9a-f]{32}$ ]]
[[ "$trace_id_two" =~ ^[0-9a-f]{32}$ ]]
test "$trace_id_one" != "$trace_id_two"
for request_number in $(seq 1 20); do
  curl --fail --silent http://127.0.0.1:8080/ >/dev/null
done
./labs/observability/validate.sh
printf 'trace_id_one=%s\ntrace_id_two=%s\n' "$trace_id_one" "$trace_id_two"
