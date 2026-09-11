# reference-app lab scripts

These are CH02's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-create-the-smallest-useful-repository.sh | Step 1 - Create the Smallest Useful Repository | Runnable |
| 02-add-contract-tests.sh | Step 3 - Add Contract Tests | Runnable |
| 03-run-and-inspect-the-real-service.sh | Step 4 - Run and Inspect the Real Service | Runnable |
| 04-run-and-inspect-the-real-service-2.sh | Step 4 - Run and Inspect the Real Service | Runnable |
| 05-stage-the-working-deliverable.sh | Step 5 - Stage the Working Deliverable | Runnable |
| 06-test-and-validate.sh | Test and Validate | Runnable |
| 07-test-and-validate-2.sh | Test and Validate | Runnable |
| 08-break-it-deliberately.sh | Break It Deliberately | Runnable - expected to fail |
| 09-the-port-value-is-rejected.sh | Symptom: The Port Value Is Rejected | Runnable |
| 10-the-address-is-already-in-use.sh | Symptom: The Address Is Already in Use | Runnable |
| 11-the-address-is-already-in-use-2.sh | Symptom: The Address Is Already in Use | Runnable |
| 12-a-test-cannot-import-src-app.sh | Symptom: A Test Cannot Import `src.app` | Runnable |
| 13-the-service-starts-but-a-route-fails.sh | Symptom: The Service Starts but a Route Fails | Runnable |
| 14-cost-and-cleanup.sh | Cost and Cleanup | Runnable |
| 15-cost-and-cleanup-2.sh | Cost and Cleanup | Runnable - removes generated caches under the two named directories |
