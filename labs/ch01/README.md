# Chapter 1 lab - The AI-Native DevOps Mindset

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-check-required-tools.sh | Prerequisites / Required tools | Runnable | Confirm bash and git are installed. |
| 02-create-workspace.sh | Build It / Step 1 | Runnable | Create the ai-native-workspace repository, directories, and sample artifact. |
| 03-define-release-gate.sh | Build It / Step 1 | Runnable | The samples/release-gate.sh script body, including its deliberate exit-status defect. |
| 04-validate-syntax.sh | Test and Validate | Runnable | Syntax-check the release gate with bash -n. |
| 05-test-success-path.sh | Test and Validate | Runnable | Run the gate against a present artifact and confirm exit status 0. |
| 06-test-negative-path.sh | Break It Deliberately | Runnable | Negative test against a missing artifact, exposing the false-success defect. |
| 07-commit-artifacts.sh | Commit the artifacts | Runnable | Commit the workspace and tag it ch01-verified. |
| 08-validate-workspace.sh | Validate the workspace | Runnable | Check that every required artifact exists and the checklist is complete. |

All 8 bash blocks in the chapter are shipped as files; none were printed-only.

The chapter also prints the workspace documents (task brief, AI usage policy, verification checklist, review record) in Markdown fences.
You write those yourself into the `workspace/` you create in this chapter - per `docs/chapter-map.md`, `workspace/` is the reader's output and this repository deliberately does not supply one.
The blank checklist to copy is `templates/verification-checklist.md`.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-context-boundary-example.txt` | Treat context as both fuel and exposure | an example of task context worth sharing | - |
| `config/02-prompt-lab.txt` | Prompt | paste into your approved assistant (AI Prompt Lab) | - |
| `config/03-task-brief.md` | Step 2 - Define intent and information boundaries | `context/task-brief.md` in your workspace | - |
| `config/04-ai-usage-policy.md` | Step 2 - Define intent and information boundaries | `context/ai-usage-policy.md` in your workspace | - |
| `config/05-draft-provenance.md` | Step 3 - Collect a review draft | the header of `drafts/model-response.md` | - |
| `config/06-verification-checklist.md` | Apply the AI Output Verification Checklist | `evidence/verification-checklist.md` | `templates/verification-checklist.md` (the chapter prints an excerpt; the template is the full form) |
| `config/07-review-record.md` | Record the engineering decision | `decisions/review-record.md` | - |
| `config/08-portfolio-readme.md` | Create the portfolio overview | `README.md` of your workspace | - |
