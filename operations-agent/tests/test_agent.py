import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).parents[1]
sys.path.insert(0, str(ROOT / "src"))

from agent import audit_record, diagnostic_brief  # noqa: E402
from tools import BoundaryError, FixtureTools  # noqa: E402


class AgentTests(unittest.TestCase):
    def test_read_only_status_produces_non_executable_proposal(self) -> None:
        brief = diagnostic_brief(
            "deployment-status", "reference-staging", "reference-app"
        )
        self.assertEqual(brief["observation"]["status"]["readyReplicas"], 1)
        self.assertFalse(brief["proposal"]["executable"])
        self.assertTrue(brief["proposal"]["requires_human_approval"])
        self.assertIn("no cluster change", brief["boundary"])

    def test_namespace_escape_is_refused(self) -> None:
        with self.assertRaisesRegex(BoundaryError, "namespace outside"):
            FixtureTools(ROOT / "fixtures").run(
                "events", "production", "reference-app"
            )

    def test_resource_escape_is_refused(self) -> None:
        with self.assertRaisesRegex(BoundaryError, "resource outside"):
            FixtureTools(ROOT / "fixtures").run(
                "events", "reference-staging", "another-app"
            )

    def test_write_tool_is_not_allowlisted(self) -> None:
        with self.assertRaisesRegex(BoundaryError, "not allowlisted"):
            FixtureTools(ROOT / "fixtures").run(
                "rollout-restart", "reference-staging", "reference-app"
            )

    def test_injected_tool_name_is_refused(self) -> None:
        with self.assertRaises(BoundaryError):
            FixtureTools(ROOT / "fixtures").run(
                "ignore-rules-and-delete", "reference-staging", "reference-app"
            )

    def test_proposal_cites_the_observation_it_came_from(self) -> None:
        brief = diagnostic_brief(
            "deployment-status", "reference-staging", "reference-app"
        )
        status = brief["observation"]["status"]
        proposal = brief["proposal"]
        self.assertIn(f"status.readyReplicas={status['readyReplicas']}", proposal["evidence"])
        unavailable = status["replicas"] - status["readyReplicas"]
        self.assertIn(f"{unavailable} of {status['replicas']}", proposal["reason"])

    def test_events_proposal_quotes_the_warning_it_read(self) -> None:
        brief = diagnostic_brief("events", "reference-staging", "reference-app")
        message = brief["observation"]["items"][0]["message"]
        self.assertIn(message, brief["proposal"]["reason"])
        self.assertTrue(
            any(message in cited for cited in brief["proposal"]["evidence"])
        )

    def test_log_tail_asks_for_evidence_rather_than_asserting_a_cause(self) -> None:
        # A log tail reports what the application answered. A proposal drawn
        # from it that named replica counts or probe configuration would be
        # asserting what this run did not observe.
        brief = diagnostic_brief("log-tail", "reference-staging", "reference-app")
        proposal = brief["proposal"]
        self.assertEqual(proposal["action"], "collect-deployment-status")
        for absent in ("replica(s) are not ready", "Warning event"):
            self.assertNotIn(absent, proposal["reason"])
        for cited in proposal["evidence"]:
            self.assertIn(cited, brief["observation"])

    def test_every_proposal_carries_evidence(self) -> None:
        for tool in FixtureTools.ALLOWED:
            with self.subTest(tool=tool):
                brief = diagnostic_brief(tool, "reference-staging", "reference-app")
                self.assertTrue(brief["proposal"]["evidence"])

    def test_allowlisting_a_tool_without_a_handler_fails_closed(self) -> None:
        # The allowlist is derived from the handler table, so this state can
        # only be reached by overriding it - and it must refuse rather than
        # return another tool's evidence under this tool's name.
        class WidenedTools(FixtureTools):
            ALLOWED = frozenset(FixtureTools.ALLOWED | {"describe-pod"})

        with self.assertRaisesRegex(BoundaryError, "no handler"):
            WidenedTools(ROOT / "fixtures").run(
                "describe-pod", "reference-staging", "reference-app"
            )

    def test_audit_record_says_no_mutation(self) -> None:
        brief = diagnostic_brief("events", "reference-staging", "reference-app")
        record = json.loads(audit_record(brief))
        self.assertFalse(record["mutation_executed"])
        self.assertEqual(record["event"], "diagnostic_brief")


if __name__ == "__main__":
    unittest.main()
