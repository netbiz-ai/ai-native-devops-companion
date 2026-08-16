# Chapter 10 lab commands - Observability with AI

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-check-environment.sh | Prerequisites - Required environment | Runnable | Record cluster context, namespaces, and tool versions |
| 02-run-unit-tests.sh | Build It - Step 2 | Runnable | Run the unit tests and check the diff for whitespace errors |
| 03-validate-collector.sh | Build It - Step 3 | Runnable | Validate the Collector config and inspect its rollout and logs |
| 04-test-alert-rules.sh | Build It - Step 4 | Runnable | Check and unit-test the Prometheus recording and alert rules |
| 05-verify-runbook-url.sh | Build It - Step 5 | Runnable | Confirm the runbook URL placeholder is gone and retest the rules |
| 06-port-forward-service.sh | Test and Validate | Runnable | Port-forward the staging service for local requests |
| 07-run-validation.sh | Test and Validate | Runnable (unlabeled in the chapter) | Send a delayed request, generate traffic, and run the validation script |
| 08-diagnose-missing-metrics.sh | Troubleshooting - The metric query returns no data | Runnable (unlabeled in the chapter) | Inspect Collector logs and regenerate traffic |
| 09-cleanup-lab.sh | Cost and Cleanup | Runnable | Delete the temporary alert sink and confirm the app is healthy |

## Migrated scripts

These scripts predate this extraction and are referenced by the chapter's commands.
They are left exactly as migrated.

- generate-traffic.sh - keeps the latency condition true across the alert's two-minute for window.
- validate.sh - the chapter's evidence-collection script, invoked by 07-run-validation.sh.

## Referenced configuration

The chapter's commands reference configuration the book prints in yaml fences.
Those files already exist in this repository under /home/elvis/projects/ai-native-devops-companion/observability/ (collector.yaml, recording-rules.yaml, alerts/reference-app.yaml, alerts/reference-app.test.yaml) and are not duplicated here.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-recording-rules.yaml` | Step 4 - Provision the dashboard and alert | the recording rules | `observability/recording-rules.yaml` |
| `config/02-alerts.yaml` | Step 4 - Provision the dashboard and alert | the alert rules | `observability/alerts/reference-app.yaml` |
