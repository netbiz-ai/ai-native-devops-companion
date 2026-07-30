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

    def test_audit_record_says_no_mutation(self) -> None:
        brief = diagnostic_brief("events", "reference-staging", "reference-app")
        record = json.loads(audit_record(brief))
        self.assertFalse(record["mutation_executed"])
        self.assertEqual(record["event"], "diagnostic_brief")


if __name__ == "__main__":
    unittest.main()
