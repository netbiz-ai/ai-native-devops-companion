#!/usr/bin/env bash
# Chapter 12, Step 2 - Inject one controlled failure - apply the latency fault and drive traffic through it
#
# Label: Runnable
# Destructive: applies the CH12_INJECTED_LATENCY_MS fault overlay to the reference application in reference-incident
#
# Expected result, per the chapter:
#   Controlled fault applied to reference-incident.
#   Traffic completed: every request succeeded and p95 latency crossed the alert threshold.
# --- command as printed, verbatim ---
labs/incident/inject-failure.sh
labs/incident/generate-traffic.sh --duration 120
