# Chapter 6 lab scripts - Design Continuous Delivery with Human and AI Guardrails

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
|---|---|---|---|
| `01-check-prereqs.sh` | Required environment | Runnable | Verify Chapter 5 files, local tooling, and GitHub CLI authentication. |
| `02-verify-protected-checks.sh` | Step 2 - Assemble the controlled delivery workflow | Partial | Require exactly one successful run per protected check name from the expected source app. |
| `03-build-push-image.sh` | Step 2 - Assemble the controlled delivery workflow | Partial | Build and push once with Buildx metadata and verify the registry digest. |
| `04-probe-staging-container.sh` | Step 2 - Assemble the controlled delivery workflow | Partial | Pull the candidate digest, start a runner-local staging container, and probe `/health`. |
| `05-validate-workflows.sh` | Step 3 - Validate before dispatch | Runnable | Stage both workflow files and inspect them locally with actionlint and ripgrep. |
| `06-validate-rollback-evidence.sh` | Step 4 - Assemble and audit rollback | Partial | Validate a rollback request against recorded release evidence before pulling the digest. |
| `07-delete-draft-release.sh` | Cost and Cleanup | Runnable | Delete the failed training draft release after confirming it is a draft with the expected tag. |
| `08-clean-local-resources.sh` | Cost and Cleanup | Runnable | Remove the named local staging container and review remaining images and worktree state. |

All 8 bash blocks in the chapter ship as files; none are output transcripts.

The chapter's blocks reference `.github/workflows/delivery.yml` and `.github/workflows/rollback.yml`, which live at the root of this repository under `.github/workflows/`.
The chapter's yaml Configuration excerpt (`permissions: {}` and the `delivery-production` concurrency group) is part of that `delivery.yml`; it is not duplicated here.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-delivery-permissions.yaml` | Step 2 - Assemble the controlled delivery workflow | the permissions head of the delivery workflow | `.github/workflows/delivery.yml` |
