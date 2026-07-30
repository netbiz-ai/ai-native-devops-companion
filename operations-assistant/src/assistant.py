from __future__ import annotations

import re
import sys
from pathlib import Path

from retriever import Passage, retrieve

KNOWLEDGE_DIR = Path(__file__).parents[1] / "knowledge"
ACTION_TERMS = {
    "apply",
    "delete",
    "destroy",
    "execute",
    "patch",
    "restart",
    "rollback",
    "scale",
    "write",
}
INJECTION_MARKERS = {
    "ignore prior",
    "ignore previous",
    "system prompt",
    "override instructions",
}


def unsafe_request(question: str) -> str | None:
    lower = question.lower()
    if any(marker in lower for marker in INJECTION_MARKERS):
        return "untrusted instruction pattern"
    requested = sorted(
        term
        for term in ACTION_TERMS
        if re.search(rf"\b{re.escape(term)}\b", lower)
    )
    if requested:
        return "state-changing request: " + ", ".join(requested)
    return None


def cited_answer(question: str, passages: list[Passage]) -> str:
    if not passages:
        return (
            "REFUSE: approved evidence does not support an answer. "
            "Request the environment, release identity, observed symptom, and "
            "relevant approved runbook."
        )
    lines = [
        "READ-ONLY DIAGNOSTIC BRIEF",
        "Question: " + question.strip(),
        "Evidence-backed checks:",
    ]
    for item in passages:
        lines.append(f"- {item.text} [{item.source_id}:{item.path}]")
    lines.extend(
        [
            "Uncertainty: retrieved guidance has not inspected a live system.",
            "Boundary: an accountable human must authorize any operational action.",
        ]
    )
    return "\n".join(lines)


def answer(question: str, knowledge_dir: Path = KNOWLEDGE_DIR) -> str:
    reason = unsafe_request(question)
    if reason:
        return (
            f"REFUSE: {reason}. This assistant is read-only. "
            "Reframe the request as evidence gathering or escalate to the "
            "governed human-approval workflow."
        )
    return cited_answer(question, retrieve(question, knowledge_dir))


def main() -> int:
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0]} "operational question"', file=sys.stderr)
        return 2
    print(answer(sys.argv[1]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
