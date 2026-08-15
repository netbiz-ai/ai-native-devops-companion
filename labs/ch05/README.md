# Chapter 5 lab commands - Build an AI-Assisted CI Pipeline

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-verify-repo-state.sh | Prerequisites | Runnable | Confirm the Chapter 4 files exist, tests pass, and the worktree is clean |
| 02-check-tool-versions.sh | Prerequisites | Runnable | Verify Git, Python, Docker, curl, rg, and actionlint are installed |
| 03-run-local-checks.sh | Build It, Step 1 | Runnable | Install pinned dev tools and run Ruff, unittest, and Bandit locally |
| 04-review-workflow.sh | Build It, Step 3 | Runnable | Stage the workflow and review it with git, actionlint, and rg |
| 05-commit-and-push.sh | Build It, Step 4 | Runnable | Commit the CI workflow and push the branch so the gates run |
| 06-validate-local-layer.sh | Test and Validate | Runnable | Run checks, build the image, start the container, and probe /health |
| 07-reproduce-failed-test.sh | Break It Deliberately, Failure 1 | Runnable | Inspect the test diff and reproduce the single failing test locally |
| 08-clean-up-lab-resources.sh | Cost and Cleanup | Runnable | Remove the labeled lab container, the lab image, and the virtualenv session |
| 09-confirm-cleanup.sh | Cost and Cleanup | Runnable | Confirm the Chapter 5 container and image are absent |

All nine bash blocks in the chapter ship as files.
No block is printed but withheld.

## Referenced configuration files

The workflow the blocks reference lives in this repository at `.github/workflows/ci.yml`.
The chapter also prints a two-line `requirements-dev.txt` (ruff==0.16.0, bandit==1.9.4), which is not carried as a standalone file in this repository.
