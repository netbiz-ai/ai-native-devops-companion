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

## What does not behave as printed here

- **The incident overlay is not in this chapter's starting state.** Step 1
  deploys `deployment/gitops/overlays/incident/`, the healthy baseline the
  chapter then breaks, and that overlay was added after `ch12-start` was cut -
  it first appears at `ch12-complete`. So `make ch12-start`, which
  `01-run-preflight.sh` runs, lands in a state that cannot deploy it.

  The preflight catches this and exits 1, naming both files and where to get
  them, so it fails before anything is applied rather than during Step 1:

      FAIL  missing: deployment/gitops/overlays/incident/kustomization.yaml
      FAIL  missing: deployment/gitops/overlays/incident/ch12-latency-fault.yaml
            the incident overlay postdates the starting state of this chapter.
            Restore it from a ref that carries it, then re-run:
              git checkout main -- deployment/gitops/overlays/incident

  Restore it and the chapter runs from the starting state as printed. Re-cutting
  the tag is the durable fix and is a release decision, per
  `docs/release-policy.md`.

- **03 copies the incident template from the book's path, and the copy fails.**
  It runs `cp docs/incidents/incident-template.md
  docs/incidents/ch12-controlled-failure.md`. Per the path alias table in
  `docs/chapter-map.md` that template lives here as
  `incidents/templates/facts-incident-record.md`, and `mkdir -p docs/incidents`
  on the line above creates the directory, so the failure is on the source:

      cp: cannot stat 'docs/incidents/incident-template.md': No such file or directory

  The block sets no `-e` and ends on a command that succeeds, so it exits 0 and
  the baseline evidence is captured normally. Nothing says the incident record
  was never created - and that record is the artifact the chapter's whole
  argument rests on. Copy it from the real path before running 03:

      cp incidents/templates/facts-incident-record.md \
        docs/incidents/ch12-controlled-failure.md

## Referenced configuration

The client Pod manifest the blocks apply lives in this repository at deployment/kubernetes/tests/client.yaml; do not duplicate it here.
