# gitops lab scripts

These are CH07's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-inspect-the-declared-promotion-path.sh | Step 1 - Inspect the Declared Promotion Path | Runnable |
| 02-give-each-environment-an-explicit-image-identity.sh | Step 2 - Give Each Environment an Explicit Image Identity | Runnable |
| 03-bound-the-controller-s-authority.sh | Step 3 - Bound the Controller's Authority | Runnable |
| 04-bound-the-controller-s-authority-2.sh | Step 3 - Bound the Controller's Authority | Runnable |
| 05-separate-staging-automation-from-production-exec.sh | Step 4 - Separate Staging Automation From Production Execution | Runnable |
| 06-prepare-the-digest-promotion.sh | Step 5 - Prepare the Digest Promotion | Runnable |
| 07-run-optional-server-side-preflight.sh | Step 6 - Run Optional Server-Side Preflight | Runnable |
| 08-functional-checks.sh | Functional Checks | Runnable |
| 09-security-checks.sh | Security Checks | Runnable |
| 10-security-checks-2.sh | Security Checks | Runnable - changes only temporary files |
| 11-negative-tests.sh | Negative Tests | Runnable - changes only temporary files |
| 12-break-it-deliberately.sh | Break It Deliberately | Runnable - changes only a temporary file |
| 13-break-it-deliberately-2.sh | Break It Deliberately | Runnable |
| 14-the-application-remains-outofsync.sh | Symptom: The Application Remains OutOfSync | Runnable |
| 15-the-application-is-synced-but-not-healthy.sh | Symptom: The Application Is Synced but Not Healthy | Runnable |
| 16-the-controller-rejects-a-resource.sh | Symptom: The Controller Rejects a Resource | Runnable |
| 17-the-controller-cannot-read-the-repository.sh | Symptom: The Controller Cannot Read the Repository | Runnable |
| 18-cost-and-cleanup.sh | Cost and Cleanup | Runnable |

## Printed configuration files

| File | Book section |
|---|---|
| config/01-give-each-environment-an-explicit-image-identity.yaml | Step 2 - Give Each Environment an Explicit Image Identity |
