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

## What does not behave as printed here

- **01's four file checks cannot all pass from one directory.** It tests `.github/workflows/ci.yml`, `Dockerfile`, `src/app.py` and `tests/test_app.py` together; the first exists only at the repository root and the other three only under `reference-app/`, because this repository splits the application from the workflows. The script sets no `-e` and ends on `git status --short`, so it exits 0 with three assertions failed and says nothing. Check the workflow from the root and the three application files from `reference-app/`, and read the results rather than the exit code - this is the prerequisite gate for a chapter that pushes an image and promotes a digest, so a green exit here is worth less than no check at all.
- **01 moves your working tree before it checks anything.** Its first two commands are `git switch main` and `git pull --ff-only`, which on this clone is a real branch switch and a real pull, not the no-op the chapter assumes for a reader already on `main`.

Everything else in 01 behaves as the chapter says: Docker, Buildx, curl, jq, ripgrep and actionlint all report versions, and `gh auth status` and `gh repo view` confirm the authenticated repository.

- **02, 03, 04 and 06 keep the book's placeholders, and 06's checks do not gate
  its pull.** `06-validate-rollback-evidence.sh` validates a rollback request
  against `release-evidence.json` and then runs `docker pull`, with no `set -e`
  between them. A request whose evidence says `Reject` fails every assertion and
  still reaches the pull, and the script exits 0 because `docker pull` succeeded.
  Read the assertions, not the exit status; the rollback gate reports success on
  a rollback its own evidence refuses.

- **07 deletes the release whether or not its safety checks pass.**
  `07-delete-draft-release.sh` is labelled Destructive. It confirms the target is
  a draft and that the tag matches, then calls `gh release delete` - and with no
  `set -e`, a failing confirmation does not stop the deletion. A published
  release at `v0.0.0-training` would be deleted anyway. In this repository that
  tag returns 404, so the delete fails harmlessly and the defect stays invisible
  to anyone who runs it here.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-delivery-permissions.yaml` | Step 2 - Assemble the controlled delivery workflow | the permissions head of the delivery workflow | `.github/workflows/delivery.yml` |
