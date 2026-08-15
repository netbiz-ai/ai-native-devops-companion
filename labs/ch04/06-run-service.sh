#!/usr/bin/env bash
# Chapter 4, Build It Step 4 - run the service read-only, probe /health, check identity, and stop it
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The bounded retry reaches `/health`, or it exits with container logs.
#   Identity shows uid=10001 and gid=10001.
#   The final inspection shows a stopped container and records its exit state.
# --- command as printed, verbatim ---
docker run --detach \
  --name reference-service-ch04 \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --publish 127.0.0.1:8080:8080 \
  ai-native-devops/reference-service:chapter04

ready=0
for attempt in {1..20}; do
  if curl --fail --silent --show-error \
    http://127.0.0.1:8080/health; then
    ready=1
    break
  fi
  if [ "$(docker container inspect \
    --format '{{.State.Running}}' reference-service-ch04)" != "true" ]; then
    docker logs reference-service-ch04
    exit 1
  fi
  sleep 1
done
if [ "$ready" -ne 1 ]; then
  docker logs reference-service-ch04
  exit 1
fi
docker exec reference-service-ch04 id
docker stop --timeout 10 reference-service-ch04
docker container inspect reference-service-ch04 \
  --format 'status={{.State.Status}} exit={{.State.ExitCode}} finished={{.State.FinishedAt}}'
