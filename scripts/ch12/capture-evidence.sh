#!/usr/bin/env bash
set -euo pipefail

source_file="${1:-}"
destination="${2:-}"

if [[ -z "$source_file" || -z "$destination" ]]; then
  echo "usage: $0 SOURCE_FILE DESTINATION_FILE" >&2
  exit 2
fi

if [[ ! -f "$source_file" ]]; then
  echo "source evidence does not exist: $source_file" >&2
  exit 1
fi

if grep -Eqi '(authorization:|password=|token=|BEGIN .*PRIVATE KEY)' "$source_file"; then
  echo "refusing to copy evidence that may contain secrets" >&2
  exit 1
fi

install -D -m 0644 "$source_file" "$destination"
echo "copied redacted evidence to $destination"
