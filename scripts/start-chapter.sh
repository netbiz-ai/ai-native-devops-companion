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

git checkout --quiet -B "lab/ch${chapter}" "${tag}"
printf 'chapter=%s state=%s tag=%s branch=lab/ch%s\n' "$chapter" "$state" "$tag" "$chapter"
