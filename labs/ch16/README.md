# Chapter 16 lab - Capstone: Design the AI-Native Delivery Platform

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-define-capstone-verifier.sh | Build It, Step 3 - Define one verification entry point | Partial | The top-level verifier listing that dispatches CAP-01 through CAP-07 checks to helper scripts. |
| 02-run-verify-all.sh | Build It, Step 3 - Define one verification entry point | Runnable (unlabeled in the chapter) | Run all live-platform checks from the repository root before the demonstration. |
| 03-run-cleanup.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Remove the capstone's temporary resources through the intended cleanup entry point. |
| 04-run-verify-final.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Run the final acceptance check after cleanup evidence is recorded. |

## Migrated scripts

- capstone-verify.sh - pre-existing migrated script, kept as is.

## Related configuration

The evidence manifest that the chapter prints as a Configuration block lives at docs/capstone/evidence-manifest.yaml in this repository.
