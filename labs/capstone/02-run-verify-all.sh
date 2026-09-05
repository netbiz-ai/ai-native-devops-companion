#!/usr/bin/env bash
# Chapter 16, Step 3 - Define one verification entry point - run all live-platform checks before the demonstration
#
# Label: Runnable (unlabeled in the chapter)
#
# Expected result, per the chapter, when the teardown for the active run has
# not been recorded yet. Auditing the run this repository retains, whose
# teardown is recorded, reports RESULT: READY and cleanup: pass instead.
#   PRE-CLEANUP RESULT: READY
#   release identity: consistent
#   delivery gates: pass
#   runtime state: reconciled
#   service targets: pass
#   incident recovery: pass
#   agent boundary tests: pass
#   cost guardrail: pass
#   cleanup: pending
# --- command as printed, verbatim ---
bash labs/capstone/capstone-verify.sh all
