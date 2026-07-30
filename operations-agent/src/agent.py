from __future__ import annotations

import json
import sys
from dataclasses import asdict, dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

from tools import BoundaryError, FixtureTools

ROOT = Path(__file__).parents[1]
FIXTURES = ROOT / "fixtures"


@dataclass(frozen=True)
class Proposal:
    action: str
    target: str
    reason: str
    requires_human_approval: bool = True
    executable: bool = False


def diagnostic_brief(tool: str, namespace: str, resource: str) -> dict[str, Any]:
    tools = FixtureTools(FIXTURES)
    observation = tools.run(tool, namespace, resource)
    proposal = Proposal(
        action="review-gitops-readiness-probe",
        target=f"{namespace}/{resource}",
        reason="Fixture evidence shows a 404 readiness probe and one unavailable replica.",
    )
    return {
        "scope": {"namespace": namespace, "resource": resource},
        "tool": tool,
        "observation": observation,
        "proposal": asdict(proposal),
        "boundary": "read-only fixture; no cluster change executed",
    }


def audit_record(brief: dict[str, Any]) -> str:
    record = {
        "timestamp": datetime.now(UTC).isoformat(),
        "event": "diagnostic_brief",
        "scope": brief["scope"],
        "tool": brief["tool"],
        "proposal": brief["proposal"],
        "mutation_executed": False,
    }
    return json.dumps(record, sort_keys=True)


def main() -> int:
    tool = sys.argv[1] if len(sys.argv) > 1 else "deployment-status"
    namespace = sys.argv[2] if len(sys.argv) > 2 else "reference-staging"
    resource = sys.argv[3] if len(sys.argv) > 3 else "reference-app"
    try:
        brief = diagnostic_brief(tool, namespace, resource)
    except BoundaryError as exc:
        print(json.dumps({"status": "refused", "reason": str(exc)}))
        return 3
    print(json.dumps(brief, indent=2, sort_keys=True))
    print(audit_record(brief))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
