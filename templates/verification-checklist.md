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
