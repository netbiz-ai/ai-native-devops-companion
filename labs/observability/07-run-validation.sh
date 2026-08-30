#!/usr/bin/env bash
# Chapter 10, Test and Validate - send a delayed request, generate traffic, and run the validation script
#
# Label: Runnable (unlabeled in the chapter)
#
# Expected result, per the chapter:
#   PASS authorized read access and staging receiver readiness
#   PASS raw metric schema, recording rules, and nonzero request rate
#   PASS delayed requests changed the duration distribution
#   PASS trace identifier appears in one log and one trace
#   PASS dashboard values match raw queries for normal, delayed, and empty input
#   PASS rendered panels have units, owners, readable labels, and color-independent states
#   PASS live alert states are inactive, pending, firing, routed, and recovered
#   Evidence written to evidence/ch10-validation.md
# --- command as printed, verbatim ---
curl -i -H 'X-CH10-Delay-Ms: 750' http://127.0.0.1:8080/
./labs/observability/generate-traffic.sh http://127.0.0.1:8080/
./labs/observability/validate.sh \
  --service-url http://127.0.0.1:8080 \
  --evidence evidence/ch10-validation.md
