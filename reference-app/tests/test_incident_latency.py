"""The incident lab's injected latency: the deployment-level fault the incident stages.

The observability lab's delay is a client's choice, per request. This one is the
service's condition, applied to everything including the readiness probe,
because an incident a caller can opt out of is not an incident.
"""

import os
import sys
import threading
import time
import unittest
from pathlib import Path
from unittest.mock import patch
from urllib.request import urlopen

sys.path.insert(0, str(Path(__file__).parents[1] / "src"))

from app import (
    MAX_INJECTED_LATENCY_MS,
    ApplicationServer,
    Settings,
)


class InjectedLatencySettingsTests(unittest.TestCase):
    def test_absent_is_zero(self) -> None:
        with patch.dict(os.environ, {}, clear=True):
            self.assertEqual(Settings.from_environment().injected_latency_ms, 0)

    def test_empty_string_is_zero(self) -> None:
        with patch.dict(os.environ, {"CH12_INJECTED_LATENCY_MS": "  "}, clear=True):
            self.assertEqual(Settings.from_environment().injected_latency_ms, 0)

    def test_valid_value_is_read(self) -> None:
        values = {"CH12_INJECTED_LATENCY_MS": "1500", "APP_ENV": "reference-incident"}
        with patch.dict(os.environ, values, clear=True):
            self.assertEqual(Settings.from_environment().injected_latency_ms, 1500)

    def test_malformed_value_refuses_to_start(self) -> None:
        # Deliberately unlike the observability lab's header, which ignores nonsense. This
        # value arrives through a reviewed change; if it cannot be read, the
        # change being applied is not the change that was reviewed.
        with (
            patch.dict(os.environ, {"CH12_INJECTED_LATENCY_MS": "soon"}, clear=True),
            self.assertRaisesRegex(ValueError, "must be an integer"),
        ):
            Settings.from_environment()

    def test_out_of_range_refuses_to_start(self) -> None:
        for value in (str(MAX_INJECTED_LATENCY_MS + 1), "-1"):
            with self.subTest(value=value):
                values = {
                    "CH12_INJECTED_LATENCY_MS": value,
                    "APP_ENV": "reference-incident",
                }
                with (
                    patch.dict(os.environ, values, clear=True),
                    self.assertRaisesRegex(ValueError, "between 0 and"),
                ):
                    Settings.from_environment()

    def test_refuses_in_protected_environments(self) -> None:
        for environment in ("production", "reference-production", "prod"):
            with self.subTest(environment=environment):
                values = {
                    "CH12_INJECTED_LATENCY_MS": "1500",
                    "APP_ENV": environment,
                }
                with (
                    patch.dict(os.environ, values, clear=True),
                    self.assertRaisesRegex(ValueError, "disposable namespace"),
                ):
                    Settings.from_environment()

    def test_zero_is_allowed_everywhere(self) -> None:
        # Restoration sets the value back to 0, and that has to be applicable
        # in any environment or the fault could not be reverted where it was
        # mistakenly applied.
        values = {"CH12_INJECTED_LATENCY_MS": "0", "APP_ENV": "production"}
        with patch.dict(os.environ, values, clear=True):
            self.assertEqual(Settings.from_environment().injected_latency_ms, 0)


class InjectedLatencyBehaviourTests(unittest.TestCase):
    def serve(self, settings: Settings) -> str:
        server = ApplicationServer(("127.0.0.1", 0), settings)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        self.addCleanup(thread.join, 3)
        self.addCleanup(server.server_close)
        self.addCleanup(server.shutdown)
        return f"http://127.0.0.1:{server.server_port}"

    def elapsed(self, url: str) -> float:
        started = time.perf_counter()
        with urlopen(url, timeout=10) as response:
            self.assertEqual(response.status, 200)
        return time.perf_counter() - started

    def test_every_route_is_slowed_including_readiness(self) -> None:
        settings = Settings(
            "reference-app", "reference-incident", "127.0.0.1", 8080,
            injected_latency_ms=400,
        )
        base = self.serve(settings)
        # /ready is the one that matters: it is what the kubelet probes, so
        # slowing it is what turns a latency fault into an availability
        # incident rather than a slow dashboard.
        for path in ("/", "/health", "/ready"):
            with self.subTest(path=path):
                self.assertGreaterEqual(self.elapsed(base + path), 0.4)

    def test_no_latency_when_unset(self) -> None:
        base = self.serve(Settings("reference-app", "test", "127.0.0.1", 8080))
        self.assertLess(self.elapsed(base + "/ready"), 0.2)


if __name__ == "__main__":
    unittest.main()
