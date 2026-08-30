#!/usr/bin/env bash
# Chapter 4, Troubleshooting "The health request cannot connect" - read container logs and published ports
#
# Label: Runnable (unlabeled in the chapter)
#
# --- command as printed, verbatim ---
docker logs reference-service-ch04
docker container inspect reference-service-ch04 \
  --format '{{json .NetworkSettings.Ports}}'
