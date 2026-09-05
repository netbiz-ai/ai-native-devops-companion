#!/usr/bin/env bash
# The ci lab, Cost and Cleanup - confirm the lab container and image are gone
#
# Label: Runnable
# --- command as printed, verbatim ---
docker ps -a --filter name=reference-service-ch05
docker image ls ai-native-devops/reference-service
