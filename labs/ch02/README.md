# Chapter 2 lab scripts - Prompting for Infrastructure and Operations

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-scaffold-repo.sh | Step 1 - Create the prompt library structure | Runnable | Scaffold the devops-prompt-library repository layout. |
| 02-check-identity.sh | Step 1 - Create the prompt library structure | Runnable | Check repository-local Git author identity. |
| 03-commit-baseline.sh | Step 8 - Commit the baseline | Runnable | Stage, inspect, and commit the initial library state. |
| 04-check-artifacts.sh | Test and Validate | Runnable | Verify prompt, case, result, and review artifacts are present. |
| 05-add-worktree.sh | Break It Deliberately | Runnable | Create the disposable safety-test worktree and branch. |
| 06-remove-worktree.sh | Break It Deliberately | Runnable | Inspect the change, then remove the disposable worktree and branch. |
| 07-diagnose-identity.sh | Troubleshooting: Git refuses the commit | Runnable | Diagnose missing Git author identity. |

All seven bash blocks in the chapter are shipped as files.

The chapter's other fences (the prompt contract, case files, scorecard, ADR, and review templates) are content the reader creates inside their own devops-prompt-library repository during the lab.
They are printed as Configuration blocks in the book and are not duplicated in this repository.
