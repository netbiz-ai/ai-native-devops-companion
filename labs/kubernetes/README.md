# kubernetes lab scripts

These are CH06's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-establish-ownership-then-review-the-workload.sh | Step 1 - Establish Ownership, Then Review the Workload | Runnable |
| 02-establish-ownership-then-review-the-workload-2.sh | Step 1 - Establish Ownership, Then Review the Workload | Runnable |
| 03-establish-ownership-then-review-the-workload-3.sh | Step 1 - Establish Ownership, Then Review the Workload | Runnable - builds and pushes an image, then creates and deletes a pull test Pod |
| 04-establish-ownership-then-review-the-workload-4.sh | Step 1 - Establish Ownership, Then Review the Workload | Runnable |
| 05-restrict-who-may-reach-the-application.sh | Step 2 - Restrict Who May Reach the Application | Runnable |
| 06-restrict-who-may-reach-the-application-2.sh | Step 2 - Restrict Who May Reach the Application | Runnable - creates and deletes the `policy-check` Namespace |
| 07-validate-before-changing-the-cluster.sh | Step 3 - Validate Before Changing the Cluster | Runnable |
| 08-validate-before-changing-the-cluster-2.sh | Step 3 - Validate Before Changing the Cluster | Runnable - creates a Namespace |
| 09-validate-before-changing-the-cluster-3.sh | Step 3 - Validate Before Changing the Cluster | Runnable |
| 10-validate-before-changing-the-cluster-4.sh | Step 3 - Validate Before Changing the Cluster | Runnable |
| 11-apply-and-observe-reconciliation.sh | Step 4 - Apply and Observe Reconciliation | Runnable |
| 12-apply-and-observe-reconciliation-2.sh | Step 4 - Apply and Observe Reconciliation | Runnable |
| 13-prove-allowed-and-denied-access.sh | Step 5 - Prove Allowed and Denied Access | Runnable |
| 14-prove-allowed-and-denied-access-2.sh | Step 5 - Prove Allowed and Denied Access | Runnable |
| 15-prove-allowed-and-denied-access-3.sh | Step 5 - Prove Allowed and Denied Access | Runnable |
| 16-prove-allowed-and-denied-access-4.sh | Step 5 - Prove Allowed and Denied Access | Runnable |
| 17-security-checks.sh | Security Checks | Runnable |
| 18-negative-tests.sh | Negative Tests | Runnable |
| 19-break-it-deliberately.sh | Break It Deliberately | Runnable |
| 20-the-deployment-never-becomes-available.sh | Symptom: The Deployment Never Becomes Available | Runnable |
| 21-the-service-has-no-ready-endpoints.sh | Symptom: The Service Has No Ready Endpoints | Runnable |
| 22-the-unlabeled-client-still-connects.sh | Symptom: The Unlabeled Client Still Connects | Runnable |
| 23-cleanup-would-delete-an-unknown-namespace.sh | Symptom: Cleanup Would Delete an Unknown Namespace | Runnable |
| 24-cleanup-would-delete-an-unknown-namespace-2.sh | Symptom: Cleanup Would Delete an Unknown Namespace | Runnable |
| 25-cost-and-cleanup.sh | Cost and Cleanup | Runnable |
| 26-cost-and-cleanup-2.sh | Cost and Cleanup | Runnable - destructive |
