#!/usr/bin/env bash
# The container lab - CH03, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
docker image inspect ai-native-devops/reference-app:chapter03 \
  --format 'platform={{.Os}}/{{.Architecture}} user={{.Config.User}} cmd={{json .Config.Cmd}} ports={{json .Config.ExposedPorts}}'
docker history --no-trunc ai-native-devops/reference-app:chapter03
docker image inspect ai-native-devops/reference-app:chapter03 \
  --format '{{.Id}}'
docker run --rm --entrypoint sh \
  ai-native-devops/reference-app:chapter03 \
  -c 'test ! -e /tmp/wheels; find /app -maxdepth 3 -type f -print; test -r /app/src/app.py'
