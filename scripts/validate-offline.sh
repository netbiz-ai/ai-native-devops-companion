#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# A reader who has followed the setup has .venv in the repository root, but a
# shell that has not activated it runs this script against the system
# interpreter, and both checks below then fail for a setup that is already
# complete. Activate it here so the checks report on the environment the
# repository provides rather than on the shell that happened to invoke them.
# An environment that is already active is left alone: whoever activated it
# chose it, and a validator is no place to overrule that.
if [ -z "${VIRTUAL_ENV:-}" ] && [ -f .venv/bin/activate ]; then
  # The activation script is not written to run under `set -u`.
  set +u
  # shellcheck source=/dev/null
  . .venv/bin/activate
  set -u
  printf 'virtualenv=%s\n' "$VIRTUAL_ENV"
fi

# The Python floor is 3.11: operations-agent imports datetime.UTC, which 3.10
# does not have, and docs/supported-versions.md records 3.11-3.13 as the
# supported range. Say that plainly before anything runs: the alternative is
# an ImportError traceback out of a test loader, which reads as a broken
# repository rather than an old interpreter.
if ! python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)'; then
  printf 'FAIL: Python 3.11 or newer is required; python3 here is %s.\n' \
    "$(python3 -c 'import platform; print(platform.python_version())')" >&2
  printf '      The supported range is 3.11-3.13, per docs/supported-versions.md.\n' >&2
  printf '      Point python3 at a newer interpreter, e.g. a virtual environment:\n' >&2
  printf '      python3.12 -m venv .venv && . .venv/bin/activate\n' >&2
  exit 1
fi

while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts labs deployment -type f -name '*.sh' -print | sort)

python3 -m compileall -q \
  reference-app/src \
  operations-assistant/src \
  operations-agent/src \
  scripts/validate_repo.py

# From Chapter 10 the reference application has runtime dependencies, so its
# tests cannot run against a bare interpreter. Say that plainly and name the
# fix: the alternative is a ModuleNotFoundError inside a test loader, which
# reads as a broken test suite rather than a missing install.
if ! python3 -c 'import opentelemetry' >/dev/null 2>&1; then
  printf 'FAIL: reference-app dependencies are not installed.\n' >&2
  printf '      python3 -m venv .venv && . .venv/bin/activate\n' >&2
  printf '      pip install -r reference-app/requirements.lock\n' >&2
  exit 1
fi

python3 -m unittest discover -s reference-app/tests -p 'test_*.py'
python3 -m unittest discover -s operations-assistant/tests -p 'test_*.py'
python3 -m unittest discover -s operations-agent/tests -p 'test_*.py'

# The capstone verifier decides whether this repository's central claim holds,
# so the thing worth testing offline is that it still refuses the evidence it
# should. It runs against a throwaway fixture and needs no cluster.
bash scripts/test-capstone-run-binding.sh

python3 scripts/validate_repo.py

printf 'offline_validation=pass\n'
printf 'live_cloud_cluster_delivery_cleanup=not_evaluated\n'
