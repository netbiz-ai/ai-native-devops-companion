#!/usr/bin/env bash
# The method lab, Validate the workspace - check that every required artifact exists and is complete
#
# Label: Runnable
#
# Expected result, per the chapter:
#   set -e stops the block at the first failing check; the `test` and `grep` commands
#   are silent when their conditions pass, the pending search is scoped to the
#   checklist's result cells, and `git status` should be clean.
# --- command as printed, verbatim ---
set -e
test -f context/task-brief.md
test -f context/ai-usage-policy.md
test -f drafts/model-response.md
test -f evidence/verification-checklist.md
test -f decisions/review-record.md
test -f samples/release-gate.sh
test -s README.md
test -s evidence/verification-checklist.md
grep -q '^# Draft provenance' drafts/model-response.md
grep -q '^## Test results' evidence/verification-checklist.md
if grep -q '| pending |' evidence/verification-checklist.md; then
    echo "verification checklist still has pending results"
    exit 1
fi
git status --short
