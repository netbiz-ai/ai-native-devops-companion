# Chapter-to-repository contract

This file is the canonical contract between the book and this repository.
Where a chapter and this map disagree about a path, an environment name, or a
workload name, this map is correct and the chapter is wrong.
Report the difference through the errata channel named in
`docs/release-policy.md`.

## What each chapter starts from, carries, and ends with

| Chapter | Starting state | Carried in | Primary paths | Ending state | Validation command |
|---:|---|---|---|---|---|
| 1 | Empty workspace | Nothing | `workspace/` | A verified script with an observed success and failure path, and a recorded decision | `./scripts/validate-offline.sh` |
| 2 | Chapter 1 workspace | The verification checklist | `devops-prompt-library/` | Reusable prompts with deterministic evaluation cases | `./scripts/validate-offline.sh` |
| 3 | Chapter 2 library | The prompt library | `reference-app/src`, `reference-app/tests` | `reference-app` serving `/`, `/health`, and `/ready` on port 8080 | `python3 -m pytest reference-app/tests` |
| 4 | Chapter 3 service | `reference-app/src` | `reference-app/Dockerfile`, `reference-app/.dockerignore` | A non-root image measured against a single-stage baseline | The chapter's `docker build` and label assertions |
| 5 | Chapter 4 image | The Dockerfile and tests | `.github/workflows/ci.yml` | Required checks enforced on `main` for one revision | `actionlint .github/workflows/ci.yml` |
| 6 | Chapter 5 CI | The required check names | `.github/workflows/delivery.yml`, `.github/workflows/rollback.yml` | One immutable digest promoted through human approval, and a tested rollback | `actionlint .github/workflows/*.yml` |
| 7 | Chapter 6 digest | The promoted digest | `infrastructure/terraform/` | A reviewed network foundation by the no-apply or the separately approved sandbox route | `terraform validate` |
| 8 | Chapter 7 foundation, plus a separately supplied cluster | The promoted digest | `deployment/kubernetes/base`, `deployment/kubernetes/tests` | A hardened workload in `reference-staging` with policy behavior observed | `kubectl kustomize deployment/kubernetes/base` |
| 9 | Chapter 8 workload | `deployment/kubernetes/base`, unchanged | `deployment/gitops/argocd`, `deployment/gitops/overlays` | Staging reconciled automatically, production promoted deliberately | `kubectl kustomize deployment/gitops/overlays/staging` |
| 10 | Chapter 9 GitOps path | The reconciled release identity | `observability/`, `scripts/ch10/` | A correlated signal, an owned alert, and a runbook | `scripts/ch10/validate.sh` |
| 11 | Chapter 10 telemetry | The release identity | `security/`, CI jobs | Findings that carry a disposition and an owner | `./scripts/validate-offline.sh` |
| 12 | Chapter 11 gates | The application and its telemetry | `incidents/`, `scripts/ch12/` | A controlled failure diagnosed and restored under human control | `scripts/ch12/validate.sh` |
| 13 | Chapter 12 incident record | The incident evidence | `optimization/` | Comparable candidates and a retain-or-revert decision | `./scripts/validate-offline.sh` |
| 14 | Chapter 12 sanitized summary | `incident-evidence/` | `operations-assistant/` | Cited read-only answers with tested refusals | `python3 -m pytest operations-assistant/tests` |
| 15 | Chapter 14 assistant | The approved knowledge set | `operations-agent/` | Allowlisted reads, a bounded proposal, an audit record, and no mutation | `python3 -m pytest operations-agent/tests` |
| 16 | Every prior chapter | The release identity and evidence manifest | `docs/capstone/`, `scripts/capstone-verify.sh` | CAP-01 to CAP-07 visible and evidence-linked | `scripts/capstone-verify.sh` |

## Canonical names

These names apply in every chapter that touches them.
A chapter that uses a different name for the same thing is wrong.

| Thing | Canonical name |
|---|---|
| Application workload | `reference-app` |
| Staging namespace | `reference-staging` |
| Production namespace | `reference-production` |
| Shared Kubernetes base | `deployment/kubernetes/base` |
| Environment overlays | `deployment/gitops/overlays/{staging,production}` |
| Argo CD declarations | `deployment/gitops/argocd` |
| Incident evidence carried into Chapter 14 | `incident-evidence/` |

## How a chapter reaches its starting state

A chapter prints `make chNN-start`, never a git command. The Makefile target
resolves the name through `scripts/start-chapter.sh`, so this repository can be
restructured without invalidating a printed page. If the handoff tag has not
been cut, the target says so and exits 3 rather than failing obscurely.

## Path aliases

Some chapters name a path that differs from where the file lives here. This map
is authoritative, per the statement at the top of this file. These are the known
differences; a chapter naming the left-hand path means the right-hand file.

| Named in the book | Actual path here | Chapters |
|---|---|---|
| `src/app.py`, `src/telemetry.py` | `reference-app/src/` | 3, 4, 10 |
| `docs/incidents/incident-template.md` | `incidents/templates/facts-incident-record.md` | 12 |
| `docs/incidents/post-incident-review.md` | `incidents/templates/post-incident-review.md` | 12 |
| `docs/optimization/scorecard-template.md` | `optimization/scorecard-template.md` | 13 |
| `docs/security/finding-disposition.yaml` | `security/finding-disposition-template.yaml` | 11 |

## Known gaps in this contract

These are recorded rather than hidden, and each one blocks the chapter step
that depends on it.

- **Per-chapter handoff tags do not exist.** The book refers to immutable
  `chNN-start` and `chNN-complete` tags. This repository currently carries one
  release tag. Treat any step requiring a `chNN-*` tag as blocked, exactly as
  the chapter's own execution status says. When those tags are cut they will
  follow `docs/release-policy.md`: immutable, never moved, and named for the
  chapter state they capture.
- **`incident-evidence/` is not populated.** Chapter 14 reads
  `incident-evidence/checkout-summary.md` and
  `incident-evidence/decision-boundaries.yml` as its starting state. Chapter 12
  produces them, so a reader who has not run Chapter 12 has no input for
  Chapter 14.
- **Chapter 11's security documents are not written.** The chapter names
  `docs/security/gate-policy.md`, `docs/security/security-ruleset.json`, and
  `docs/security/trace-review.md`. `.github/workflows/security.yml` exists, but
  those three do not. The first two are configuration this repository can carry;
  the third records a review that has to be performed before it can be written.
- **Chapter 13's measured outputs are not written.** `docs/decisions/adr-template.md`
  and `docs/optimization/experiment-template.md` are now provided. The filled
  documents the chapter also names, `docs/decisions/adr-ch13-capacity.md` and
  `docs/optimization/ch13-scaling-experiment.md`, state measured results and are
  only written from an executed experiment. `scripts/ch13/` does not exist.
- **`reference-app/src/telemetry.py` is not provided.** Chapter 10 has the reader
  implement it and then compare against the reviewed reference. That reference is
  the content of `ch10-complete`, so it is deliberately absent from `main`.
- **`observability/test-receiver.yaml` is not provided.** Chapter 10 names it as
  the local collector target used before any cluster is involved.
- **Environment overlays carry a kustomization only.** The namespace and
  fault-injection files that Chapters 9 and 10 name under
  `deployment/gitops/overlays/` are not yet in the repository.

## What the offline validator does not prove

The repository's offline validator is a prerequisite check, not a substitute
for hosted, cloud, cluster, security, incident, cost, or cleanup evidence.
