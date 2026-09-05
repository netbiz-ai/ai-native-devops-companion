#!/usr/bin/env bash
# The ci lab, Test and Validate - run the local layer: checks, image build, and health probe
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Lint, unit tests, and source review pass.
#   The image builds.
#   The service returns a successful health response.
#   The named local container is removed.
# --- command as printed, verbatim ---
. .venv/bin/activate
ruff check src tests
python -m unittest discover -v
bandit -q -r src -ll -ii
docker build --tag ai-native-devops/reference-service:chapter05 .
if docker container inspect reference-service-ch05 >/dev/null 2>&1; then
  echo "Stop: reference-service-ch05 already exists."
  exit 1
fi
cleanup_ch05() {
  docker rm -f reference-service-ch05 >/dev/null 2>&1 || true
}
trap cleanup_ch05 EXIT
docker run --detach \
  --name reference-service-ch05 \
  --label ai-native-devops.lab=ch05 \
  --publish 127.0.0.1:8080:8080 \
  ai-native-devops/reference-service:chapter05
healthy=false
for attempt in {1..15}; do
  if curl --fail --silent http://127.0.0.1:8080/health; then
    healthy=true
    break
  fi
  sleep 1
done
test "$healthy" = true
cleanup_ch05
trap - EXIT
