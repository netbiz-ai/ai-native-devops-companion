from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

TOKEN_RE = re.compile(r"[a-z0-9][a-z0-9_-]+")
# Function words carry no operational meaning, and a question that shares only
# these with a runbook has not matched it. The list is deliberately conservative:
# words a reader might genuinely be asking about - "restart", "before",
# "readiness" - are not here, because the threshold below is what does the real
# work.
STOPWORDS = {
    "and",
    "any",
    "are",
    "as",
    "at",
    "be",
    "been",
    "but",
    "by",
    "did",
    "do",
    "does",
    "for",
    "from",
    "had",
    "has",
    "have",
    "how",
    "if",
    "in",
    "into",
    "is",
    "it",
    "its",
    "might",
    "not",
    "of",
    "on",
    "or",
    "our",
    "should",
    "that",
    "the",
    "their",
    "them",
    "then",
    "there",
    "these",
    "they",
    "this",
    "those",
    "to",
    "was",
    "were",
    "what",
    "when",
    "where",
    "which",
    "why",
    "with",
    "you",
    "your",
}

# One shared token is not evidence of relevance. "What is the capital of France?"
# retrieved an operational runbook on the strength of "of" alone, and the
# assistant answered it with a citation - which is the failure a citation is
# meant to prevent, because the cited passage was real and the answer was not
# grounded in it. Require two, and fall back to one only when the question has
# just one content token to give.
MIN_OVERLAP = 2


@dataclass(frozen=True)
class Passage:
    source_id: str
    path: str
    text: str
    score: int


def tokens(text: str) -> set[str]:
    return {
        token
        for token in TOKEN_RE.findall(text.lower())
        if token not in STOPWORDS
    }


def source_id(text: str, path: Path) -> str:
    match = re.search(r"^source_id:\s*(\S+)\s*$", text, re.MULTILINE)
    return match.group(1) if match else path.stem


def load_passages(knowledge_dir: Path) -> list[tuple[str, str, str, str]]:
    """Return (source_id, filename, text, match_text) for each passage.

    `text` is what a citation quotes. `match_text` is what retrieval scores
    against, and carries the heading the passage sits under as well: a document
    titled "High latency" answers a question about high latency, and dropping
    the heading threw away the strongest signal in the file.
    """
    passages: list[tuple[str, str, str, str]] = []
    for path in sorted(knowledge_dir.glob("*.md")):
        content = path.read_text(encoding="utf-8")
        sid = source_id(content, path)
        body = re.sub(r"\A---.*?---\s*", "", content, flags=re.DOTALL)
        heading = ""
        for paragraph in re.split(r"\n\s*\n", body):
            clean = " ".join(paragraph.split())
            if not clean:
                continue
            if clean.startswith("#"):
                heading = clean.lstrip("#").strip()
                continue
            passages.append((sid, path.name, clean, f"{heading} {clean}".strip()))
    return passages


def retrieve(question: str, knowledge_dir: Path, limit: int = 3) -> list[Passage]:
    query_tokens = tokens(question)
    required = MIN_OVERLAP if len(query_tokens) >= MIN_OVERLAP else 1
    ranked: list[Passage] = []
    for sid, path, text, match_text in load_passages(knowledge_dir):
        overlap = query_tokens & tokens(match_text)
        if len(overlap) >= required:
            ranked.append(Passage(sid, path, text, len(overlap)))
    ranked.sort(key=lambda item: (-item.score, item.source_id, item.text))
    return ranked[:limit]
