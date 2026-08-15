# Chapter 12 lab commands - AI for Incident Response and Troubleshooting

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-run-preflight.sh | Prerequisites | Runnable | Start the chapter state and run the lab preflight checks. |
| 02-deploy-client.sh | Build It, Step 1 - Establish the healthy baseline | Runnable | Deploy, label, and wait for the in-namespace traffic client Pod. |
| 03-capture-baseline.sh | Build It, Step 1 - Establish the healthy baseline | Runnable | Create the incident record from the template and capture baseline evidence. |
| 04-inject-failure.sh | Build It, Step 2 - Inject one controlled failure | Runnable | Apply the controlled latency fault and drive traffic through it. |
| 05-collect-incident-packet.sh | Build It, Step 4 - Collect a bounded incident packet | Runnable | Capture incident-phase evidence, workload state, rollout history, and events. |
| 06-restore-state.sh | Build It, Step 6 - Restore the accepted state | Runnable | Run the reviewed restoration, wait for the rollout, and capture recovery evidence. |
| 07-verify-recovery.sh | Build It, Step 7 - Verify recovery and complete the review | Runnable | Validate the baseline, incident, and recovery evidence files. |
| 08-check-service-endpoints.sh | Troubleshooting - The alert fires but requests appear healthy | Runnable | Inspect the service and endpoints, then regenerate traffic. |
| 09-validate-kubectl-syntax.sh | Troubleshooting - AI recommends a command that does not exist | Runnable | Validate kubectl syntax and resource fields from help output. |
| 10-cleanup-namespace.sh | Cost and Cleanup | Runnable | Restore, validate, then delete the disposable lab namespace. |

All 10 of the chapter's bash blocks ship as files; none is printed-only.

## Migrated scripts

These scripts predate this extraction and are the working implementations the chapter's commands call.
They are listed for orientation only and are not modified or renamed by this extraction.

- capture-evidence.sh
- generate-traffic.sh
- inject-failure.sh
- preflight.sh
- restore.sh
- validate.sh

## Referenced configuration

The client Pod manifest the blocks apply lives in this repository at deployment/kubernetes/tests/client.yaml; do not duplicate it here.
