#!/usr/bin/env bash
# The container lab - CH03, Step 1 - Control the Build Context
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The Dockerfile check reports no blocking error.
#   The exported context omits both sentinels and lists the required source and dependency files.
#   Git reports only the chapter files you intended to change.
# --- command as printed, verbatim ---
touch .env.context-audit context-audit.pem
context_audit_dir=$(mktemp -d)
docker buildx build --check .
docker buildx build \
  --file - \
  --output "type=local,dest=$context_audit_dir" . <<'EOF'
# syntax=docker/dockerfile:1
FROM scratch
COPY . /context/
EOF
test ! -e "$context_audit_dir/context/.env.context-audit"
test ! -e "$context_audit_dir/context/context-audit.pem"
test -e "$context_audit_dir/context/src/app.py"
test -e "$context_audit_dir/context/requirements.lock"
find "$context_audit_dir/context" -type f -print | sort
rm -f .env.context-audit context-audit.pem
test -n "$context_audit_dir"
rm -rf -- "$context_audit_dir"
git status --short
