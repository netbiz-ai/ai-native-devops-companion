from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


class BoundaryError(ValueError):
    pass


@dataclass(frozen=True)
class Scope:
    namespace: str = "reference-staging"
    deployment: str = "reference-app"


class FixtureTools:
    """Read-only tools backed by deterministic, versioned fixtures."""

    ALLOWED = {"deployment-status", "events", "log-tail"}

    def __init__(self, fixture_dir: Path, scope: Scope = Scope()) -> None:
        self.fixture_dir = fixture_dir
        self.scope = scope

    def run(
        self, tool: str, namespace: str, resource: str
    ) -> dict[str, Any] | str:
        if tool not in self.ALLOWED:
            raise BoundaryError(f"tool not allowlisted: {tool}")
        if namespace != self.scope.namespace:
            raise BoundaryError(f"namespace outside approved scope: {namespace}")
        if resource != self.scope.deployment:
            raise BoundaryError(f"resource outside approved scope: {resource}")
        if tool == "deployment-status":
            return json.loads(
                (self.fixture_dir / "deployment.json").read_text(encoding="utf-8")
            )
        if tool == "events":
            return json.loads(
                (self.fixture_dir / "events.json").read_text(encoding="utf-8")
            )
        return (self.fixture_dir / "log-tail.txt").read_text(encoding="utf-8")
