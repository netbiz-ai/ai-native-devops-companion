#!/usr/bin/env bash
# The container lab - CH03, Step 3 - Record the Base Identity and Build the Final Image
#
# Label: Runnable
# --- command as printed, verbatim ---
docker pull python:3.12-slim
python_base=$(docker image inspect \
  --format '{{range .RepoDigests}}{{println .}}{{end}}' \
  python:3.12-slim \
  | awk '/^(docker\.io\/library\/)?python@sha256:/ {print; exit}')
test -n "$python_base"
base_platform=$(docker image inspect \
  --format '{{.Os}}/{{.Architecture}}' python:3.12-slim)
printf 'python_base=%s base_platform=%s\n' \
  "$python_base" "$base_platform"
