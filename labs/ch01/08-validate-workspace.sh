#!/usr/bin/env bash
# Chapter 1, Validate the workspace - check that every required artifact exists and is complete
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The `test` and `grep` commands are silent when their conditions pass, and `git status` should be clean.
# --- command as printed, verbatim ---
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
! grep -q 'pending' evidence/verification-checklist.md
git status --short
