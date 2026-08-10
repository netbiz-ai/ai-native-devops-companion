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


@dataclass(frozen=True)
class _Fixture:
    filename: str
    is_json: bool


class FixtureTools:
    """Read-only tools backed by deterministic, versioned fixtures."""

    # The allowlist and the dispatch are one list, not two kept in step by
    # hand. An allowlist that admits a tool the dispatch does not implement is
    # the fail-open shape this chapter is about, and with a handler table it
    # cannot be written.
    HANDLERS = {
        "deployment-status": _Fixture("deployment.json", is_json=True),
        "events": _Fixture("events.json", is_json=True),
        "log-tail": _Fixture("log-tail.txt", is_json=False),
    }
    ALLOWED = frozenset(HANDLERS)

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
        fixture = self.HANDLERS.get(tool)
        if fixture is None:
            # Unreachable while ALLOWED is derived from HANDLERS, and kept so
            # that a subclass widening the allowlist fails closed rather than
            # returning some other tool's evidence under this tool's name.
            raise BoundaryError(f"allowlisted tool has no handler: {tool}")
        payload = (self.fixture_dir / fixture.filename).read_text(encoding="utf-8")
        return json.loads(payload) if fixture.is_json else payload
