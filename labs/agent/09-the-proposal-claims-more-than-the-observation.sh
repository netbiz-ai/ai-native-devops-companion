#!/usr/bin/env bash
# The agent lab - CH12, Symptom: The Proposal Claims More Than the Observation
#
# Label: Runnable:
# --- command as printed, verbatim ---
python3 -m unittest operations-agent.tests.test_agent.AgentTests.test_log_tail_asks_for_evidence_rather_than_asserting_a_cause
