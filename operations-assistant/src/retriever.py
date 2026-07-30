from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

TOKEN_RE = re.compile(r"[a-z0-9][a-z0-9_-]+")
STOPWORDS = {
    "and",
    "are",
    "for",
    "from",
    "how",
    "is",
    "might",
    "should",
    "the",
    "this",
    "what",
    "when",
    "where",
    "which",
    "why",
    "with",
}


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


def load_passages(knowledge_dir: Path) -> list[tuple[str, str, str]]:
    passages: list[tuple[str, str, str]] = []
    for path in sorted(knowledge_dir.glob("*.md")):
        content = path.read_text(encoding="utf-8")
        sid = source_id(content, path)
        body = re.sub(r"\A---.*?---\s*", "", content, flags=re.DOTALL)
        for paragraph in re.split(r"\n\s*\n", body):
            clean = " ".join(paragraph.split())
            if clean and not clean.startswith("#"):
                passages.append((sid, path.name, clean))
    return passages


def retrieve(question: str, knowledge_dir: Path, limit: int = 3) -> list[Passage]:
    query_tokens = tokens(question)
    ranked: list[Passage] = []
    for sid, path, text in load_passages(knowledge_dir):
        overlap = query_tokens & tokens(text)
        if overlap:
            ranked.append(Passage(sid, path, text, len(overlap)))
    ranked.sort(key=lambda item: (-item.score, item.source_id, item.text))
    return ranked[:limit]
