#!/usr/bin/env bash
# Put the working tree at a chapter's starting state.
#
# Chapters print `make chNN-start` rather than a git command on purpose: a
# printed page cannot be corrected, so the book depends on this name and the
# repository decides what it resolves to. If the handoff tag has not been cut
# yet, say so plainly and point at the recorded gap instead of failing with a
# bare git error.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

chapter="${1:?usage: start-chapter.sh NN [start|complete]}"
state="${2:-start}"
tag="ch${chapter}-${state}"

if ! git rev-parse --verify --quiet "refs/tags/${tag}" >/dev/null; then
  cat >&2 <<MSG
${tag} has not been cut.

Per docs/release-policy.md a chNN-* tag is only cut from a state that has
actually been executed and whose observed output matches the chapter. This one
has not been, so the chapter's own execution status applies: treat the lab as a
design and review exercise.

Recorded gaps: docs/chapter-map.md ("Known gaps in this contract")
MSG
  exit 3
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  printf 'FAIL: working tree has uncommitted changes; commit or stash first\n' >&2
  exit 1
fi

# The handoff tags were cut before the labs/ extraction, so a chapter's starting
# state does not carry the lab scripts the chapter then tells you to run. Without
# this, `make ch12-start` removes labs/ch12/preflight.sh and the very next line of
# labs/ch12/01-run-preflight.sh cannot find it. Remember where the scripts are
# before moving the tree.
harness_ref=""
for candidate in HEAD main origin/main; do
  if git cat-file -e "${candidate}:labs" 2>/dev/null; then
    harness_ref="$(git rev-parse --verify --quiet "$candidate")"
    break
  fi
done

git checkout --quiet -B "lab/ch${chapter}" "${tag}"

labs_note=""
if [ ! -d labs ] && [ -n "$harness_ref" ]; then
  # Restore onto the lab branch and commit, so the branch is a usable starting
  # state rather than a tree with pending changes. lab/chNN is disposable.
  #
  # This script comes forward too. It is the harness, not chapter content, and
  # the checkout above has just replaced it on disk with the tag's older copy -
  # so without this, re-running `make chNN-start` from the lab branch would run
  # the version that does not restore anything.
  git checkout --quiet "$harness_ref" -- labs scripts/start-chapter.sh
  git commit --quiet --no-verify -m "Restore labs/ onto lab/ch${chapter}

The chNN-* tags predate the labs/ extraction, so the chapter's starting state
does not carry its own lab scripts. Restored from ${harness_ref}." \
    -- labs scripts/start-chapter.sh
  labs_note=" labs=restored"
elif [ ! -d labs ]; then
  printf 'WARNING: labs/ is absent at %s and no ref carrying it was found;\n' "$tag" >&2
  printf '         the chapter cannot run its numbered scripts from this state.\n' >&2
fi

printf 'chapter=%s state=%s tag=%s branch=lab/ch%s%s\n' "$chapter" "$state" "$tag" "$chapter" "$labs_note"
