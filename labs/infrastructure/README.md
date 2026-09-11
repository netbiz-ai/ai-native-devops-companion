# infrastructure lab scripts

These are CH05's commands exactly as the book prints them, one file per bash block, in book order.
This directory is generated from the printed chapter and verified by the book's `scripts/check_labs.py`; edit the chapter, not these files.

Run the numbered files from the repository root, in order, skipping any whose label below says it is expected to fail or needs values filled in first.
Each numbered file is a separate script, so an environment variable exported in one does not carry to the next; export what a step needs before each file that needs it.

| File | Book section | Label |
|---|---|---|
| 01-review-the-module-contract.sh | Step 1 - Review the Module Contract | Runnable |
| 02-inventory-the-declared-resources.sh | Step 2 - Inventory the Declared Resources | Runnable |
| 03-review-the-development-caller.sh | Step 3 - Review the Development Caller | Runnable |
| 04-review-the-development-caller-2.sh | Step 3 - Review the Development Caller | Runnable |
| 05-review-the-development-caller-3.sh | Step 3 - Review the Development Caller | Runnable |
| 06-format-initialize-and-validate.sh | Step 4 - Format, Initialize, and Validate | Runnable |
| 07-review-the-sanitized-plan-with-ai.sh | Step 5 - Review the Sanitized Plan with AI | Runnable |
| 08-review-the-sanitized-plan-with-ai-2.sh | Step 5 - Review the Sanitized Plan with AI | Runnable |
| 09-harden-the-contract.sh | Step 6 - Harden the Contract | Runnable |
| 10-break-it-deliberately.sh | Break It Deliberately | Runnable |
| 11-initialization-requests-credentials-or-backend-a.sh | Symptom: Initialization Requests Credentials or Backend Access | Runnable |
| 12-validation-succeeds-in-the-wrong-directory.sh | Symptom: Validation Succeeds in the Wrong Directory | Runnable |
| 13-the-fixture-inventory-differs-from-configuration.sh | Symptom: The Fixture Inventory Differs From Configuration | Runnable |
| 14-cost-and-cleanup.sh | Cost and Cleanup | Runnable |
| 15-cost-and-cleanup-2.sh | Cost and Cleanup | Runnable - destructive to local initialization data only |
| 16-cost-and-cleanup-3.sh | Cost and Cleanup | Runnable |
