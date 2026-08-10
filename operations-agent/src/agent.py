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
    evidence: tuple[str, ...] = ()
    requires_human_approval: bool = True
    executable: bool = False


def _from_deployment_status(observation: dict[str, Any]) -> tuple[str, str, list[str]]:
    status = observation.get("status", {})
    replicas = status.get("replicas", 0)
    ready = status.get("readyReplicas", 0)
    evidence = [f"status.replicas={replicas}", f"status.readyReplicas={ready}"]
    unavailable = replicas - ready
    for condition in status.get("conditions", []):
        if condition.get("type") == "Available" and condition.get("status") != "True":
            evidence.append(
                f"condition Available={condition.get('status')} "
                f"reason={condition.get('reason')}"
            )
    if unavailable <= 0:
        return (
            "no-action",
            f"All {replicas} replica(s) are ready; this observation reports no fault.",
            evidence,
        )
    return (
        "review-deployment-readiness",
        f"{unavailable} of {replicas} replica(s) are not ready. "
        "The cause is not in this observation: deployment status reports the "
        "count, not why a probe failed.",
        evidence,
    )


def _from_events(observation: dict[str, Any]) -> tuple[str, str, list[str]]:
    warnings = [
        item
        for item in observation.get("items", [])
        if item.get("type") == "Warning"
    ]
    if not warnings:
        return (
            "no-action",
            "No Warning events in this observation.",
            ["items: no Warning entries"],
        )
    evidence = [
        f"{item.get('reason')} on "
        f"{item.get('involvedObject', {}).get('kind')}/"
        f"{item.get('involvedObject', {}).get('name')}: {item.get('message')}"
        for item in warnings
    ]
    return (
        "review-readiness-probe-configuration",
        f"{len(warnings)} Warning event(s), the first reporting: "
        f"{warnings[0].get('message')}",
        evidence,
    )


def _from_log_tail(observation: str) -> tuple[str, str, list[str]]:
    lines = [line for line in observation.splitlines() if line.strip()]
    # A log tail records what the application answered. It does not report
    # replica counts or probe configuration, so proposing a fix from it would
    # be asserting evidence this run did not observe.
    return (
        "collect-deployment-status",
        "A log tail does not establish replica state or probe configuration. "
        "Ask for deployment-status or events before proposing a change.",
        lines[-2:],
    )


DIAGNOSERS = {
    "deployment-status": _from_deployment_status,
    "events": _from_events,
    "log-tail": _from_log_tail,
}


def _propose(tool: str, namespace: str, resource: str, observation: Any) -> Proposal:
    """Derive the proposal from what was observed, not from the tool's name."""
    diagnose = DIAGNOSERS.get(tool)
    if diagnose is None:
        # One table per tool, and no fallthrough: a tool with no diagnosis
        # refuses rather than borrowing another tool's conclusion.
        raise BoundaryError(f"no diagnosis defined for tool: {tool}")
    action, reason, evidence = diagnose(observation)
    return Proposal(
        action=action,
        target=f"{namespace}/{resource}",
        reason=reason,
        evidence=tuple(evidence),
    )


def diagnostic_brief(tool: str, namespace: str, resource: str) -> dict[str, Any]:
    tools = FixtureTools(FIXTURES)
    observation = tools.run(tool, namespace, resource)
    proposal = _propose(tool, namespace, resource, observation)
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
