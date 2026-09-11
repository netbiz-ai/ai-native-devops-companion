# security lab scripts

These are CH09's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-prerequisites.sh | Prerequisites | Runnable |
| 02-audit-the-five-supplied-checks.sh | Step 1 - Audit the Five Supplied Checks | Runnable |
| 03-write-policy-before-the-first-scan.sh | Step 2 - Write Policy Before the First Scan | Runnable |
| 04-adopt-and-exercise-the-reviewed-inputs.sh | Step 3 - Adopt and Exercise the Reviewed Inputs | Runnable |
| 05-run-the-hosted-checks.sh | Step 4 - Run the Hosted Checks | Runnable |
| 06-require-the-exact-names.sh | Step 5 - Require the Exact Names | Runnable |
| 07-require-the-exact-names-2.sh | Step 5 - Require the Exact Names | Runnable |
| 08-require-the-exact-names-3.sh | Step 5 - Require the Exact Names | Runnable |
| 09-test-and-validate.sh | Test and Validate | Runnable |
| 10-break-it-deliberately.sh | Break It Deliberately | Runnable |
| 11-break-it-deliberately-2.sh | Break It Deliberately | Runnable |
| 12-the-secret-check-passes-with-the-fixture.sh | Symptom: The Secret Check Passes With the Fixture | Runnable |
| 13-a-required-check-is-missing.sh | Symptom: A Required Check Is Missing | Runnable |
| 14-the-image-check-cannot-find-the-image.sh | Symptom: The Image Check Cannot Find the Image | Runnable |
| 15-cost-and-cleanup.sh | Cost and Cleanup | Runnable |
| 16-cost-and-cleanup-2.sh | Cost and Cleanup | Runnable |
