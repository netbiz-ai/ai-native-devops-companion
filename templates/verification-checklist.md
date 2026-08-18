# AI Output Verification Checklist

Copy this file to `evidence/verification-checklist.md` and fill it in per review.
Chapter 1 prints an excerpt; this is the full form.

## Test results

Replace `pending` after each run.
Record concise output, including `<no output>` when silence is expected.

| Check | Precondition | Command | Observed output | Exit status | Result | What this does not prove |
|---|---|---|---|---|---|---|
| Syntax | Original or corrected script | `bash -n samples/release-gate.sh` |  |  | pending | Runtime behavior |
| Success path | `artifacts/release.tar` exists | `bash samples/release-gate.sh artifacts/release.tar` |  |  | pending | Missing-artifact behavior |
| Negative before fix | `artifacts/missing.tar` is absent | Run the negative-test wrapper |  |  | pending | Production integration |
| Negative after fix | Final line is `exit 1` | Run the negative-test wrapper |  |  | pending | Permissions, artifact authenticity, monitoring, or rollback |

## Evidence metadata

- Reviewer:
- Date:
- Environment: Bash version and operating environment
- Source draft: drafts/model-response.md
- Evidence limits:

## Intent

- [ ] Outcome and acceptance criteria are explicit.
- [ ] Output stays within scope.
- [ ] Assumptions and unknowns are visible.

## Information safety

- [ ] Inputs contain no credentials or unapproved data.
- [ ] Output exposes no secrets or private information.
- [ ] Data handling follows the applicable policy.

## Technical correctness

- [ ] Names, paths, fields, and commands match the target.
- [ ] A deterministic syntax check is recorded.
- [ ] Success behavior is tested in isolation.
- [ ] Negative and failure behavior is tested.

## Engineering quality

- [ ] Security, reliability, observability, maintainability, and cost are reviewed.
- [ ] Permissions follow the principle of least privilege.
- [ ] Rollback or recovery is defined where relevant.
- [ ] The change is no larger than needed.

## Evidence and decision

- [ ] Important claims map to results or authoritative sources.
- [ ] Each check states what it does not prove.
- [ ] Suggestions are marked accepted, changed, rejected, or unresolved.
- [ ] A named human owns the final decision.
