# Chapter 16 lab - Capstone: Design the AI-Native Delivery Platform

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-define-capstone-verifier.sh | Build It, Step 3 - Define one verification entry point | Partial | The top-level verifier listing that dispatches CAP-01 through CAP-07 checks to helper scripts. |
| 02-run-verify-all.sh | Build It, Step 3 - Define one verification entry point | Runnable (unlabeled in the chapter) | Run all live-platform checks from the repository root before the demonstration. |
| 03-record-reconciliation.sh | Build It, Step 5 - Record the infrastructure reconciliation | Runnable (unlabeled in the chapter) | Apply the capstone's Terraform contract, induce and reconcile one drift, and retain the CAP-03 evidence. Set `CAPSTONE_IAC_ROUTE=cloud-sandbox` to read the drift result from Chapter 7's sandbox workspace instead. |
| 04-run-cleanup.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Destroy the capstone's Terraform-managed objects, then remove the lab's temporary resources through the cleanup entry point. |
| 05-run-verify-final.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Run the final acceptance check after cleanup evidence is recorded. |

## Migrated scripts

- capstone-verify.sh - the shipped acceptance verifier the runnable steps call. Its retained results for this repository's own acceptance run live under `evidence/capstone/`.

## Related configuration

The evidence manifest that the chapter prints as a Configuration block lives at docs/capstone/evidence-manifest.yaml in this repository.
The Terraform contract the reconciliation step applies lives at infrastructure/terraform/capstone/.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-evidence-manifest.yaml` | Step 2 - Create the evidence manifest | the capstone evidence manifest | `docs/capstone/evidence-manifest.yaml` |
