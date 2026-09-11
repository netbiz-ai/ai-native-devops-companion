#!/usr/bin/env bash
# The container lab - CH03, Step 4 - Run the Service Under Its Constraints
#
# Label: Runnable
#
# Expected result, per the chapter:
#   {"status": "healthy"}
#   uid=10001(app) gid=10001(app) groups=10001(app)
# --- command as printed, verbatim ---
docker run --detach \
  --name reference-app-ch03 \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --publish 127.0.0.1:8080:8080 \
  ai-native-devops/reference-app:chapter03

ready=0
for attempt in {1..20}; do
  if curl --fail --silent --show-error \
    http://127.0.0.1:8080/health; then
    ready=1
    break
  fi
  if [ "$(docker container inspect \
    --format '{{.State.Running}}' reference-app-ch03)" != "true" ]; then
    break
  fi
  sleep 1
done
if [ "$ready" -ne 1 ]; then
  printf 'the service did not become healthy; container logs follow\n'
  docker logs reference-app-ch03
else
  docker exec reference-app-ch03 id
fi
