# container lab scripts

These are CH03's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-control-the-build-context.sh | Step 1 - Control the Build Context | Runnable |
| 02-control-the-build-context-2.sh | Step 1 - Control the Build Context | Runnable |
| 03-build-and-measure-a-baseline.sh | Step 2 - Build and Measure a Baseline | Runnable |
| 04-build-and-measure-a-baseline-2.sh | Step 2 - Build and Measure a Baseline | Runnable |
| 05-record-the-base-identity-and-build-the-final-ima.sh | Step 3 - Record the Base Identity and Build the Final Image | Runnable |
| 06-record-the-base-identity-and-build-the-final-ima-2.sh | Step 3 - Record the Base Identity and Build the Final Image | Runnable |
| 07-run-the-service-under-its-constraints.sh | Step 4 - Run the Service Under Its Constraints | Runnable |
| 08-test-and-validate.sh | Test and Validate | Runnable |
| 09-test-and-validate-2.sh | Test and Validate | Runnable |
| 10-test-and-validate-3.sh | Test and Validate | Runnable |
| 11-test-and-validate-4.sh | Test and Validate | Runnable |
| 12-test-and-validate-5.sh | Test and Validate | Runnable |
| 13-break-it-deliberately.sh | Break It Deliberately | Runnable |
| 14-break-it-deliberately-2.sh | Break It Deliberately | Runnable |
| 15-the-application-source-is-missing.sh | Symptom: The Application Source Is Missing | Runnable |
| 16-the-container-exits-with-a-permission-error.sh | Symptom: The Container Exits With a Permission Error | Runnable |
| 17-the-health-request-cannot-connect.sh | Symptom: The Health Request Cannot Connect | Runnable |
| 18-cost-and-cleanup.sh | Cost and Cleanup | Runnable |
| 19-cost-and-cleanup-2.sh | Cost and Cleanup | Runnable |

## Printed configuration files

| File | Book section |
|---|---|
| config/01-build-and-measure-a-baseline.dockerfile | Step 2 - Build and Measure a Baseline |
| config/02-record-the-base-identity-and-build-the-final-ima.dockerfile | Step 3 - Record the Base Identity and Build the Final Image |
