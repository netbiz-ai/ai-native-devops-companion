"""Fake-client command-line demonstration.

Stands in for a live model with one canned brief per approved source, so the
assistant's gates can be demonstrated end to end, deterministically and
offline. The gates are real: the canned brief is only emitted when retrieval
actually returns its source, unsafe requests are refused before retrieval,
and anything else refuses for lack of approved evidence. A live deployment
would replace the table with a model call behind the same gates.
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from assistant import KNOWLEDGE_DIR, unsafe_request  # noqa: E402
from retriever import retrieve  # noqa: E402

REFUSAL = "REFUSE: Approved current evidence is insufficient."

FAKE_BRIEFS = {
    "checkout-api.md": "\n".join(
        [
            "Fact: The runbook says to compare the alert window with"
            " deployment events. [checkout-api.md:2]",
            "Hypothesis: A recent release may align with the error window."
            " [checkout-api.md:2]",
            "Check: inspect_deployment_event target=checkout-api"
            " [checkout-api.md:2]",
            "Uncertainty: The evidence does not establish a root cause.",
            "Human decision required: verify the cited runbook before acting.",
        ]
    ),
}


def demo_answer(question: str, knowledge_dir: Path = KNOWLEDGE_DIR) -> str:
    if unsafe_request(question):
        return REFUSAL
    for passage in retrieve(question, knowledge_dir):
        brief = FAKE_BRIEFS.get(passage.path)
        if brief:
            return brief
    return REFUSAL


def main() -> int:
    if len(sys.argv) != 2:
        print('Usage: python3 -m src.demo "operational question"', file=sys.stderr)
        return 2
    print(demo_answer(sys.argv[1]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
