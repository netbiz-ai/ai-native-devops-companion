#!/usr/bin/env bash
set -euo pipefail

result="${1:-}"
case "$result" in
  pass) printf 'release_gate=pass\n' ;;
  fail) printf 'release_gate=fail\n' >&2; exit 1 ;;
  *) printf 'usage: %s {pass|fail}\n' "$0" >&2; exit 2 ;;
esac
