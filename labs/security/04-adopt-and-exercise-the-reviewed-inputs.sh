#!/usr/bin/env bash
# The security lab - CH09, Step 3 - Adopt and Exercise the Reviewed Inputs
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Configuration is valid.
# --- command as printed, verbatim ---
git add security/gate-policy.md
git commit -m "security: define gate policy before scanning"
git checkout security-complete -- \
  .github/workflows/security.yml \
  rules/semgrep.yml
repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
default_branch="$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')"
test -n "$default_branch"
git check-ref-format "refs/heads/${default_branch}"
DEFAULT_BRANCH="$default_branch" python - <<'PY'
from os import environ
import json
from pathlib import Path

path = Path(".github/workflows/security.yml")
text = path.read_text()
old = "    branches: [main]"
if text.count(old) != 2:
    raise SystemExit("expected two main-branch event filters")
text = text.replace(old, f"    branches: [{json.dumps(environ['DEFAULT_BRANCH'])}]")
text = text.replace("  security-events: write\n", "")
path.write_text(text)
PY
git diff HEAD -- .github/workflows/security.yml rules/semgrep.yml
actionlint .github/workflows/security.yml
semgrep --validate --config rules/semgrep.yml
mkdir -p testdata/security/semgrep-probe
(
  cleanup_probe() {
    rm -f testdata/security/semgrep-probe/unsafe.py \
      testdata/security/semgrep-probe/safe.py
    rmdir testdata/security/semgrep-probe
  }
  trap cleanup_probe EXIT
  printf 'import yaml\nvalue = yaml.load(payload)\n' \
    >testdata/security/semgrep-probe/unsafe.py
  printf 'import yaml\nvalue = yaml.safe_load(payload)\n' \
    >testdata/security/semgrep-probe/safe.py
  if semgrep --error --config rules/semgrep.yml \
    testdata/security/semgrep-probe/unsafe.py; then
    echo 'expected unsafe YAML finding was missing'
    exit 1
  fi
  semgrep --error --config rules/semgrep.yml \
    testdata/security/semgrep-probe/safe.py
)
git add .github/workflows/security.yml rules/semgrep.yml
git commit -m "security: adopt reviewed gate inputs"
