from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).parents[1]

REQUIRED = [
    "reference-app/src/app.py",
    "reference-app/Dockerfile",
    ".github/workflows/ci.yml",
    ".github/workflows/security.yml",
    "infrastructure/terraform/modules/network/main.tf",
    "deployment/kubernetes/base/kustomization.yaml",
    "deployment/gitops/argocd/project.yaml",
    "observability/alerts/reference-app.yaml",
    "operations-assistant/src/assistant.py",
    "operations-agent/src/agent.py",
    "docs/capstone/evidence-manifest.yaml",
    "docs/chapter-map.md",
    "scripts/start-chapter.sh",
    "templates/verification-checklist.md",
    "docs/decisions/adr-template.md",
    "docs/optimization/experiment-template.md",
    "queries/endpoint-ready.jsonpath",
]
JSON_FILES = [
    "observability/dashboard.json",
    "devops-prompt-library/evals/cases/missing-file.json",
    "devops-prompt-library/evals/cases/destructive-injection.json",
    "operations-assistant/evals/cases.json",
    "operations-agent/evals/cases.json",
    "operations-agent/policy/approval.schema.json",
    "patches/sync-policy.json",
]
SECRET_PATTERNS = {
    "AWS access key": re.compile("AKIA" + r"[0-9A-Z]{16}"),
    "private key": re.compile("BEGIN " + r"(?:RSA |EC |OPENSSH )?PRIVATE KEY"),
    "GitHub token": re.compile("gh" + r"[pousr]_[A-Za-z0-9_]{30,}"),
}


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> int:
    for rel in REQUIRED:
        path = ROOT / rel
        if not path.is_file() or path.stat().st_size == 0:
            fail(f"required file missing or empty: {rel}")

    for rel in JSON_FILES:
        try:
            json.loads((ROOT / rel).read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            fail(f"invalid JSON {rel}: {exc}")

    for path in ROOT.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        if path.suffix.lower() in {".png", ".jpg", ".pdf", ".pyc"}:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        if "\t" in text and path.suffix in {".yaml", ".yml"}:
            fail(f"tab indentation in YAML: {path.relative_to(ROOT)}")
        for label, pattern in SECRET_PATTERNS.items():
            if pattern.search(text):
                fail(f"{label} pattern in {path.relative_to(ROOT)}")

    workflow = (ROOT / ".github/workflows/security.yml").read_text(encoding="utf-8")
    for job in ("sast:", "dependencies:", "secrets:", "iac:", "image:"):
        if job not in workflow:
            fail(f"security workflow missing job: {job[:-1]}")

    manifest = (ROOT / "docs/capstone/evidence-manifest.yaml").read_text(
        encoding="utf-8"
    )
    for number in range(1, 8):
        if f"CAP-0{number}:" not in manifest:
            fail(f"capstone manifest missing CAP-0{number}")

    print(f"repository_structure=pass required_files={len(REQUIRED)}")
    print(f"json_validation=pass files={len(JSON_FILES)}")
    print("secret_pattern_scan=pass")
    print("capstone_links=pass criteria=7")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
