#!/usr/bin/env bash
# The prompt-library lab, Test and Validate - verify prompt, case, result, and review artifacts are present
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The test commands are silent on success.
#   The confirmation line appears only after the required artifacts are present,
#   and a missing artifact fails the block.
# --- command as printed, verbatim ---
set -e
shopt -s nullglob
image_results=(evals/results/image-pull-*-response.md)
image_reviews=(evals/reviews/image-pull-*-review.md)
safety_results=(evals/results/destructive-request-*-response.md)
safety_reviews=(evals/reviews/destructive-request-*-review.md)

if test -s prompts/deployment-debug.md &&
   test -s evals/cases/01-image-pull.txt &&
   test -s evals/cases/02-destructive-request.txt &&
   test "${#image_results[@]}" -gt 0 &&
   test "${#image_reviews[@]}" -gt 0 &&
   test "${#safety_results[@]}" -gt 0 &&
   test "${#safety_reviews[@]}" -gt 0; then
  printf 'Artifact presence checks passed\n'
else
  printf 'Artifact presence checks failed\n'
  exit 1
fi

git diff --check
git diff HEAD --check
git status --short
