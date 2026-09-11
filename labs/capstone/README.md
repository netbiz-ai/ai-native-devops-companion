# capstone lab scripts

These are CH13's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-prerequisites.sh | Prerequisites | Runnable: |
| 02-establish-one-acceptance-run.sh | Step 1 - Establish One Acceptance Run | Runnable: |
| 03-establish-one-acceptance-run-2.sh | Step 1 - Establish One Acceptance Run | Runnable: |
| 04-inspect-the-existing-evidence-index.sh | Step 2 - Inspect the Existing Evidence Index | Runnable: |
| 05-trace-release-identity-and-gates.sh | Step 3 - Trace Release Identity and Gates | Runnable: |
| 06-record-infrastructure-reconciliation.sh | Step 4 - Record Infrastructure Reconciliation | Runnable: |
| 07-validate-runtime-reliability-and-ai-boundaries.sh | Step 5 - Validate Runtime, Reliability, and AI Boundaries | Runnable: |
| 08-run-the-pre-cleanup-acceptance-gate.sh | Step 6 - Run the Pre-Cleanup Acceptance Gate | Runnable: |
| 09-the-starting-command-does-not-run.sh | Symptom: The Starting Command Does Not Run | Runnable: |
| 10-cap-01-reports-missing-or-unsupported-evidence.sh | Symptom: CAP-01 Reports Missing or Unsupported Evidence | Runnable: |
| 11-reconciliation-exits-before-detecting-drift.sh | Symptom: Reconciliation Exits Before Detecting Drift | Runnable: |
| 12-the-pre-cleanup-gate-passes-cleanup-you-never-ra.sh | Symptom: The Pre-Cleanup Gate Passes Cleanup You Never Ran | Runnable: |
| 13-cleanup-stops-before-deleting-anything.sh | Symptom: Cleanup Stops Before Deleting Anything | Runnable: |
| 14-final-validation-finds-a-failed-deletion.sh | Symptom: Final Validation Finds a Failed Deletion | Runnable: |
| 15-cost-and-cleanup.sh | Cost and Cleanup | Runnable: |
| 16-cost-and-cleanup-2.sh | Cost and Cleanup | Runnable - Destructive: |
| 17-cost-and-cleanup-3.sh | Cost and Cleanup | Runnable: |
