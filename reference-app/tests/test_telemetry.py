"""The observability lab's instrumentation, and the two fault gates its lab depends on.

These tests assert the things the chapter asks a reader to observe: that a
successful request carries a well-formed trace identifier, that the metric
attributes stay bounded, and that each gate does exactly what the chapter says
it does. No Collector is needed - the SDK records in process when no OTLP
endpoint is configured, which is what makes the lab's premise checkable offline.
"""

import json
import os
import sys
import threading
import unittest
from pathlib import Path
from unittest.mock import patch
from urllib.request import Request, urlopen

sys.path.insert(0, str(Path(__file__).parents[1] / "src"))

import telemetry
from app import (
    MAX_DELAY_MS,
    ApplicationServer,
    Settings,
    requested_delay_ms,
    route_template,
)


class RouteTemplateTests(unittest.TestCase):
    """`http.route` is a metric attribute, so it must never carry a raw path."""

    def test_known_routes_pass_through(self) -> None:
        for path in ("/", "/health", "/ready"):
            with self.subTest(path=path):
                self.assertEqual(route_template(path), path)

    def test_unknown_paths_collapse_to_one_series(self) -> None:
        for path in ("/wp-admin.php", "/../etc/passwd", "/a/b/c"):
            with self.subTest(path=path):
                self.assertEqual(route_template(path), "/unmatched")


class FaultGateTests(unittest.TestCase):
    off = Settings("reference-app", "test", "127.0.0.1", 8080)
    on = Settings("reference-app", "test", "127.0.0.1", 8080, fault_gate_enabled=True)

    def test_gate_off_ignores_the_header(self) -> None:
        self.assertEqual(requested_delay_ms("500", self.off), 0)

    def test_gate_on_honours_a_bounded_value(self) -> None:
        self.assertEqual(requested_delay_ms("500", self.on), 500)

    def test_bounds_are_inclusive(self) -> None:
        self.assertEqual(requested_delay_ms("0", self.on), 0)
        self.assertEqual(requested_delay_ms(str(MAX_DELAY_MS), self.on), MAX_DELAY_MS)

    def test_out_of_range_is_ignored_not_clamped(self) -> None:
        # Clamping would silently serve a delay the caller did not ask for.
        self.assertEqual(requested_delay_ms(str(MAX_DELAY_MS + 1), self.on), 0)
        self.assertEqual(requested_delay_ms("-1", self.on), 0)

    def test_malformed_value_is_ignored(self) -> None:
        for value in ("abc", "", "1.5", "1e3"):
            with self.subTest(value=value):
                self.assertEqual(requested_delay_ms(value, self.on), 0)

    def test_absent_header_is_zero(self) -> None:
        self.assertEqual(requested_delay_ms(None, self.on), 0)

    def test_gate_refuses_to_start_in_a_protected_environment(self) -> None:
        for environment in ("production", "reference-production", "prod"):
            with self.subTest(environment=environment):
                values = {"APP_ENV": environment, "CH10_FAULT_GATE_ENABLED": "true"}
                with (
                    patch.dict(os.environ, values, clear=True),
                    self.assertRaisesRegex(ValueError, "staging-only"),
                ):
                    Settings.from_environment()

    def test_gate_is_allowed_in_staging(self) -> None:
        values = {"APP_ENV": "reference-staging", "CH10_FAULT_GATE_ENABLED": "true"}
        with patch.dict(os.environ, values, clear=True):
            self.assertTrue(Settings.from_environment().fault_gate_enabled)


class TraceHeaderTests(unittest.TestCase):
    """The correlation header, and the switch that breaks it on purpose."""

    @classmethod
    def setUpClass(cls) -> None:
        telemetry.configure("reference-app", "test")

    def serve(self, settings: Settings):
        server = ApplicationServer(("127.0.0.1", 0), settings)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        self.addCleanup(thread.join, 2)
        self.addCleanup(server.server_close)
        self.addCleanup(server.shutdown)
        return f"http://127.0.0.1:{server.server_port}"

    def test_trace_id_is_a_well_formed_w3c_identifier(self) -> None:
        base = self.serve(Settings("reference-app", "test", "127.0.0.1", 8080))
        with urlopen(base + "/", timeout=2) as response:
            trace_id = response.headers.get("X-Trace-Id")
        self.assertIsNotNone(trace_id)
        self.assertRegex(trace_id, telemetry.TRACE_ID_PATTERN)

    def test_each_request_gets_its_own_trace(self) -> None:
        base = self.serve(Settings("reference-app", "test", "127.0.0.1", 8080))
        seen = set()
        for _ in range(3):
            with urlopen(base + "/", timeout=2) as response:
                seen.add(response.headers.get("X-Trace-Id"))
        self.assertEqual(len(seen), 3)

    def test_omit_flag_removes_the_header_and_nothing_else(self) -> None:
        settings = Settings("reference-app", "test", "127.0.0.1", 8080, omit_trace_id=True)
        base = self.serve(settings)
        with urlopen(base + "/", timeout=2) as response:
            body = json.load(response)
            self.assertIsNone(response.headers.get("X-Trace-Id"))
        # The break the lab teaches: the response is still 200 and still
        # correct. Only the ability to correlate it is gone.
        self.assertEqual(response.status, 200)
        self.assertEqual(body["status"], "ok")

    def test_delay_gate_actually_delays(self) -> None:
        settings = Settings(
            "reference-app", "test", "127.0.0.1", 8080, fault_gate_enabled=True
        )
        base = self.serve(settings)
        request = Request(base + "/", headers={"X-CH10-Delay-Ms": "300"})
        started = __import__("time").perf_counter()
        with urlopen(request, timeout=5) as response:
            self.assertEqual(response.status, 200)
        self.assertGreaterEqual(__import__("time").perf_counter() - started, 0.3)


class InstrumentationContractTests(unittest.TestCase):
    """The instrument name and attributes the recording rules depend on."""

    @classmethod
    def setUpClass(cls) -> None:
        telemetry.configure("reference-app", "test")

    def test_recording_rules_read_the_name_this_emits(self) -> None:
        rules = (Path(__file__).parents[2] / "observability/recording-rules.yaml").read_text()
        prometheus_name = telemetry._INSTRUMENT_NAME.replace(".", "_") + "_seconds"
        self.assertIn(prometheus_name + "_count", rules)
        self.assertIn(prometheus_name + "_bucket", rules)

    def test_recording_rules_read_the_status_attribute_this_sets(self) -> None:
        rules = (Path(__file__).parents[2] / "observability/recording-rules.yaml").read_text()
        self.assertIn("http_response_status_code", rules)

    def test_recording_duration_is_accepted(self) -> None:
        telemetry.record_duration(0.01, "/", 200)

    def test_trace_id_excludes_flags_and_state(self) -> None:
        span = telemetry.start_span("GET", "/")
        try:
            self.assertRegex(telemetry.trace_id_of(span), telemetry.TRACE_ID_PATTERN)
        finally:
            span.end()


if __name__ == "__main__":
    unittest.main()
