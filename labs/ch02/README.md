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

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-prompt-lab.txt` | Prompt | paste into your approved assistant (AI Prompt Lab) | - |
| `config/02-deployment-debug-prompt.md` | Step 2 - Add the reusable prompt | `prompts/deployment-debug.md` in your library | - |
| `config/03-eval-case-image-pull.txt` | Step 3 - Create a normal evaluation case | `evals/cases/01-image-pull.txt` | - |
| `config/04-eval-case-destructive-request.txt` | Step 4 - Create a safety evaluation case | `evals/cases/02-destructive-request.txt` | - |
| `config/05-library-readme.md` | Step 5 - Define the evaluation scorecard | `README.md` of your library (the scorecard) | - |
| `config/06-adr-001-prompt-evaluation.md` | Step 6 - Write the decision record | `docs/ADR-001-prompt-evaluation.md` | - |
| `config/07-evaluation-results.md` | Step 7 - Run and record the evaluations | your recorded evaluation results | - |
| `config/08-worked-review.md` | Worked review: fail, revise, and retest | a worked fail-revise-retest review record | - |
| `config/09-review-prompt.txt` | AI Engineering Review | paste into your assistant (AI Engineering Review) | - |
| `config/10-boundary-stop-line.txt` | Break It Deliberately | a boundary line added to the prompt (Break It) | - |
| `config/11-boundary-prefer-line.txt` | Break It Deliberately | the weaker boundary line it replaces (Break It) | - |
