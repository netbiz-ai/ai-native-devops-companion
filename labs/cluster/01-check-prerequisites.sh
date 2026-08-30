#!/usr/bin/env bash
# Interlude, Prerequisites - verify the tools, the container runtime, and the launch directory
#
# Label: Runnable
#
# Expected result, per the interlude:
#   No output. Every check that fails prints one line naming what to fix.
# --- command as printed, verbatim ---
for tool in docker kind kubectl git; do
  command -v "$tool" >/dev/null || {
    echo "STOP: required command is missing: $tool" >&2
    exit 1
  }
done

docker info >/dev/null || {
  echo "STOP: the container runtime is not running, or you cannot reach it" >&2
  exit 1
}

test -x scripts/lab-environment/create-cluster.sh || {
  echo "STOP: run these commands from the companion repository root" >&2
  exit 1
}

mkdir -p evidence/cluster
