#!/usr/bin/env bash
# Chapter 4, Build It Step 3 - pull the base tag and record its registry digest
#
# Label: Runnable
#
# --- command as printed, verbatim ---
docker pull python:3.12-slim
docker image inspect \
  --format '{{range .RepoDigests}}{{println .}}{{end}}' \
  python:3.12-slim
python_base=$(docker image inspect \
  --format '{{range .RepoDigests}}{{println .}}{{end}}' \
  python:3.12-slim \
  | awk '/^(docker\.io\/library\/)?python@sha256:/ {print; exit}')
test -n "$python_base"
printf 'python_base=%s\n' "$python_base"
