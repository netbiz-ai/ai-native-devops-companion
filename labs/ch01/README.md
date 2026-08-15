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
