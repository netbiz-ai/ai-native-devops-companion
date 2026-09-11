#!/usr/bin/env bash
# Capture a bounded, sanitized evidence packet for one incident phase.
#
# Chapter 12 calls this as `--phase recovery --output evidence/ch12/recovery.txt`,
# which the previous version did not accept: it copied a file from a source to
# a destination. Both forms now work, and the flag form is the documented one.
#
# The sanitization check the old script performed is kept and applied to what
# this one collects, because evidence gathered during an incident is exactly
# when a token ends up in a log line nobody reread.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

phase=""
output=""
namespace="${CH12_NAMESPACE:-reference-incident}"

# Legacy positional form: SOURCE DESTINATION.
if [[ $# -eq 2 && "$1" != --* ]]; then
  source_file="$1"; destination="$2"
  test -f "$source_file" || { echo "source evidence does not exist: $source_file" >&2; exit 1; }
  if grep -Eqi '(authorization:|password=|token=|BEGIN .*PRIVATE KEY)' "$source_file"; then
    echo "refusing to copy evidence that may contain secrets" >&2; exit 1
  fi
  install -D -m 0644 "$source_file" "$destination"
  echo "copied redacted evidence to $destination"
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) phase="${2:?--phase needs a value}"; shift 2 ;;
    --output) output="${2:?--output needs a value}"; shift 2 ;;
    --namespace) namespace="${2:?--namespace needs a value}"; shift 2 ;;
    *) echo "usage: $0 --phase NAME --output FILE [--namespace NS]" >&2; exit 2 ;;
  esac
done

[[ -n "$phase" && -n "$output" ]] || {
  echo "usage: $0 --phase NAME --output FILE [--namespace NS]" >&2; exit 2
}

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

{
  printf '# incident evidence\n'
  printf 'phase=%s\n' "$phase"
  printf 'captured_at=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'namespace=%s\n' "$namespace"
  printf 'operator=%s\n' "${USER:-unknown}"
  printf '\n## deployment\n'
  kubectl -n "$namespace" get deployment reference-app \
    -o jsonpath='replicas={.spec.replicas} ready={.status.readyReplicas} image={.spec.template.spec.containers[0].image}' 2>/dev/null || true
  printf '\ninjected_latency_ms=%s\n' "$(kubectl -n "$namespace" get deployment reference-app \
    -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH12_INJECTED_LATENCY_MS")].value}' 2>/dev/null || echo unknown)"
  printf '\n## pods\n'
  kubectl -n "$namespace" get pods -o wide 2>/dev/null || true
  printf '\n## recent events\n'
  kubectl -n "$namespace" get events --sort-by=.lastTimestamp 2>/dev/null | tail -15 || true
} > "$tmp"

# Same rule the old script enforced, now applied to collected output rather
# than only to a file someone hands over.
if grep -Eqi '(authorization:|password=|token=|BEGIN .*PRIVATE KEY)' "$tmp"; then
  echo "refusing to write evidence that may contain secrets" >&2
  exit 1
fi

install -D -m 0644 "$tmp" "$output"
printf 'evidence_captured phase=%s output=%s lines=%s\n' \
  "$phase" "$output" "$(wc -l < "$output")"
