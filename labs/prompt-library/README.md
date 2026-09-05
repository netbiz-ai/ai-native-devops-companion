# prompt-library lab scripts - Prompting for Infrastructure and Operations

Second edition: chapter 1. That chapter covers `method` and `prompt-library`. First edition and the full mapping: [docs/subject-map.md](../../docs/subject-map.md).

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-scaffold-repo.sh | Step 1 - Create the prompt library structure | Runnable | Scaffold the devops-prompt-library repository layout. |
| 02-check-identity.sh | Step 1 - Create the prompt library structure | Runnable | Show the Git author identity in effect (any scope). |
| 03-commit-baseline.sh | Step 8 - Commit the baseline | Runnable | Stage, inspect, and commit the initial library state. |
| 04-check-artifacts.sh | Test and Validate | Runnable | Verify prompt, case, result, and review artifacts are present. |
| 05-add-worktree.sh | Break It Deliberately | Runnable | Create the disposable safety-test worktree and branch. |
| 06-remove-worktree.sh | Break It Deliberately | Runnable | Inspect the change, then remove the disposable worktree and branch. |
| 07-diagnose-identity.sh | Troubleshooting: Git refuses the commit | Runnable | Diagnose missing Git author identity. |

All seven bash blocks in the chapter are shipped as files.

Each numbered file is a separate script, so a `cd` inside one does not carry to the next.
Run 01 from wherever you keep your lab work; run 02, 03, 04, 05, and 07 from inside the `devops-prompt-library/` it creates; 06 starts inside the safety-test worktree (`../devops-prompt-library-safety-test`) and returns to the library itself.

The chapter's other fences (the prompt contract, case files, scorecard, ADR, and review templates) are content the reader creates inside their own devops-prompt-library repository during the lab.
They are printed as Configuration blocks in the book and are not duplicated in this repository.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/subject-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-prompt-lab.txt` | Prompt | paste into your approved assistant (AI Prompt Lab) | - |
| `config/02-deployment-debug-prompt.md` | Step 2 - Add the reusable prompt | `prompts/deployment-debug.md` in your library | - |
| `config/03-eval-case-image-pull.txt` | Step 3 - Create a normal evaluation case | `evals/cases/01-image-pull.txt` | - |
| `config/04-eval-case-destructive-request.txt` | Step 4 - Create a safety evaluation case | `evals/cases/02-destructive-request.txt` | - |
| `config/05-library-readme.md` | Step 5 - Define the evaluation scorecard | `README.md` of your library (the scorecard) | - |
| `config/06-adr-001-prompt-evaluation.md` | Step 6 - Write the decision record | `docs/ADR-001-prompt-evaluation.md` | - |
| `config/07-evaluation-results.md` | Step 7 - Run and record the evaluations | your recorded results and reviews: `evals/results/image-pull-001-response.md`, `evals/reviews/image-pull-001-review.md`, and the `destructive-request-001-*` pair - 04's checks glob for exactly these names | - |
| `config/08-worked-review.md` | Worked review: fail, revise, and retest | a worked fail-revise-retest review record | - |
| `config/09-review-prompt.txt` | AI Engineering Review | paste into your assistant (AI Engineering Review) | - |
| `config/10-boundary-stop-line.txt` | Break It Deliberately | the line to weaken: it already sits in your `prompts/deployment-debug.md` via config 01's "Escalation and safety" section | - |
| `config/11-boundary-prefer-line.txt` | Break It Deliberately | the weaker replacement you swap in for config 10's line, inside the safety-test worktree only | - |
