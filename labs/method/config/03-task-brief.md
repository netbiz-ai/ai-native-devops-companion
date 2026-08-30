# Task brief

## Outcome
Review samples/release-gate.sh and verify that it stops a release when the
artifact path is missing.

## In scope
- Identify risky or incorrect command behavior.
- Propose syntax, success-path, and negative-path tests.
- Mark assumptions and missing context.

## Out of scope
- Execute commands or change files.
- Access a live environment.
- Invent credentials, paths, or deployment details.

## Constraints
- Use Bash as the tested shell.
- Use only local, non-destructive checks.
- Explain what each check proves and does not prove.

## Acceptance criteria
- Bash syntax validation passes.
- An existing artifact returns exit status 0.
- A missing artifact returns a nonzero exit status.
- Every model suggestion receives a recorded disposition.
