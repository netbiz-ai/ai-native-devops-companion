#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--confirm-design-only" ]]; then
  printf 'Refusing: this repository does not inject a live fault automatically.\n' >&2
  printf 'Usage: %s --confirm-design-only\n' "$0" >&2
  exit 2
fi

printf 'fault_injection=not_executed reason=design-only\n'
printf 'Use a reviewed Git change and the supported disposable environment.\n'
