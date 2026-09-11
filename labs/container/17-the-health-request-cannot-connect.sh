#!/usr/bin/env bash
# The container lab - CH03, Symptom: The Health Request Cannot Connect
#
# Label: Runnable
# --- command as printed, verbatim ---
docker logs reference-app-ch03
docker container inspect reference-app-ch03 \
  --format 'status={{.State.Status}} ports={{json .NetworkSettings.Ports}}'
curl --verbose http://127.0.0.1:8080/health
