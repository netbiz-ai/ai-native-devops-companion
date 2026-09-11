# observability lab scripts

These are CH08's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-convert-the-complaint-into-a-telemetry-contract.sh | Step 1 - Convert the Complaint into a Telemetry Contract | Runnable |
| 02-review-and-adopt-the-instrumented-route.sh | Step 2 - Review and Adopt the Instrumented Route | Runnable |
| 03-configure-and-inspect-telemetry-flow.sh | Step 3 - Configure and Inspect Telemetry Flow | Runnable |
| 04-configure-and-inspect-telemetry-flow-2.sh | Step 3 - Configure and Inspect Telemetry Flow | Runnable |
| 05-provision-the-dashboard-and-alert.sh | Step 4 - Provision the Dashboard and Alert | Runnable |
| 06-provision-the-dashboard-and-alert-2.sh | Step 4 - Provision the Dashboard and Alert | Runnable |
| 07-provision-the-dashboard-and-alert-3.sh | Step 4 - Provision the Dashboard and Alert | Runnable |
| 08-connect-the-runbook-before-routing.sh | Step 5 - Connect the Runbook Before Routing | Runnable |
| 09-connect-the-runbook-before-routing-2.sh | Step 5 - Connect the Runbook Before Routing | Runnable |
| 10-test-and-validate.sh | Test and Validate | Runnable, terminal one |
| 11-test-and-validate-2.sh | Test and Validate | Runnable, terminal two |
| 12-test-and-validate-3.sh | Test and Validate | Runnable, terminal two |
| 13-test-and-validate-4.sh | Test and Validate | Runnable, terminal two |
| 14-test-and-validate-5.sh | Test and Validate | Runnable, terminal three |
| 15-test-and-validate-6.sh | Test and Validate | Runnable, terminal two |
| 16-test-and-validate-7.sh | Test and Validate | Runnable, terminal two |
| 17-break-it-deliberately.sh | Break It Deliberately | Runnable |
| 18-break-it-deliberately-2.sh | Break It Deliberately | Runnable |
| 19-the-metric-query-returns-no-data.sh | Symptom: The Metric Query Returns No Data | Runnable |
| 20-the-alert-test-passes-but-the-live-alert-never-f.sh | Symptom: The Alert Test Passes but the Live Alert Never Fires | Runnable |
| 21-the-dashboard-is-empty-while-raw-metrics-exist.sh | Symptom: The Dashboard Is Empty While Raw Metrics Exist | Runnable |
| 22-cost-and-cleanup.sh | Cost and Cleanup | Runnable, destructive within the disposable lab |
