# Chapter-to-repository contract

This file is the canonical contract between the book and this repository.
Where a chapter and this map disagree about a path, an environment name, or a
workload name, this map is correct and the chapter is wrong.
Report the difference through the errata channel named in
`docs/release-policy.md`.

## What each chapter starts from, carries, and ends with

| Chapter | Starting state | Carried in | Primary paths | Ending state | Validation command |
|---:|---|---|---|---|---|
| 1 | Empty workspace | Nothing | `workspace/`, which you create | A verified script with an observed success and failure path, and a recorded decision | The chapter's own syntax, success and failure runs |
| 2 | Chapter 1 workspace | The verification checklist | `devops-prompt-library/`, which you create | Reusable prompts with deterministic evaluation cases | The chapter's own artifact-presence block |
| 3 | Chapter 2 library | The prompt library | `reference-app/src`, `reference-app/tests` | `reference-app` serving `/`, `/health`, and `/ready` on port 8080 | `cd reference-app && python3 -m unittest discover -s tests` |
| 4 | Chapter 3 service | `reference-app/src` | `reference-app/Dockerfile`, `reference-app/.dockerignore` | A non-root image measured against a single-stage baseline | The chapter's `docker build` and label assertions |
| 5 | Chapter 4 image | The Dockerfile and tests | `.github/workflows/ci.yml` | Required checks enforced on `main` for one revision | `actionlint .github/workflows/ci.yml` |
| 6 | Chapter 5 CI | The required check names | `.github/workflows/delivery.yml`, `.github/workflows/rollback.yml` | One immutable digest promoted through human approval, and a tested rollback | `actionlint .github/workflows/*.yml` |
| 7 | Chapter 6 digest | The promoted digest | `infrastructure/terraform/`, fixture at `infrastructure/terraform/fixtures/` | A reviewed network foundation by the no-apply or the separately approved sandbox route | `terraform validate` |
| 8 | Chapter 7 foundation, plus a separately supplied cluster | The promoted digest | `deployment/kubernetes/base`, `deployment/kubernetes/tests` | A hardened workload in `reference-dev` with policy behavior observed | `kubectl kustomize deployment/kubernetes/base` |
| 9 | Chapter 8 workload | `deployment/kubernetes/base`, unchanged | `deployment/gitops/argocd`, `deployment/gitops/overlays` | Staging reconciled automatically, production promoted deliberately | `kubectl kustomize deployment/gitops/overlays/staging` |
| 10 | Chapter 9 GitOps path | The reconciled release identity | `observability/`, `labs/ch10/` | A correlated signal, an owned alert, and a runbook | `labs/ch10/validate.sh` |
| 11 | Chapter 10 telemetry | The release identity | `security/`, CI jobs | Findings that carry a disposition and an owner | `./scripts/validate-offline.sh` |
| 12 | Chapter 11 gates | The application and its telemetry | `incidents/`, `labs/ch12/` | A controlled failure diagnosed and restored under human control | `labs/ch12/validate.sh` |
| 13 | Chapter 12 incident record | The incident evidence | `optimization/` | Comparable candidates and a retain-or-revert decision | `./scripts/validate-offline.sh` |
| 14 | Chapter 12 sanitized summary | `incident-evidence/` | `operations-assistant/` | Cited read-only answers with tested refusals | `cd operations-assistant && python3 -m unittest discover -s tests` |
| 15 | Chapter 14 assistant | The approved knowledge set | `operations-agent/` | Allowlisted reads, a bounded proposal, an audit record, and no mutation | `cd operations-agent && python3 -m unittest discover -s tests` |
| 16 | Every prior chapter | The release identity and evidence manifest | `docs/capstone/`, `labs/ch16/capstone-verify.sh` | CAP-01 to CAP-07 visible and evidence-linked | `labs/ch16/capstone-verify.sh` |

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
| `agents/k8s-diagnostics/` | `operations-agent/` | 15 |
| `infrastructure/modules/`, `infrastructure/environments/` | `infrastructure/terraform/modules/`, `infrastructure/terraform/environments/` | 7 |

## Known gaps in this contract

These are recorded rather than hidden. A gap here is something the book names
that this repository does not supply; an artifact the reader is meant to write
is listed in the section below instead, because calling it a gap told readers
their lab was blocked when it was not.

- **Nothing in this repository is validated against a live cloud account.**
  `scripts/validate-offline.sh` reports
  `live_cloud_cluster_delivery_cleanup=not_evaluated`, and that is accurate.
  The cluster work in Chapters 10 to 13 was verified on a local kind cluster.
  Chapter 7's Terraform takes the no-apply route unless you supply and approve
  your own sandbox.

- **Chapter 6's delivery route now runs, and needs configuration you must
  supply.** `delivery.yml` and `rollback.yml` implement the contract the
  chapter audits against, and both were exercised end to end on 2026-08-10.
  They require two repository environments, `staging` and `production`, with
  deployment branches restricted to `main` and a required reviewer on
  `production` who is not the person dispatching the run. Without them the
  jobs will not gate, and with self-review permitted the chapter's independence
  checkpoint is not met. Protected-check verification uses this repository's
  real check names - `quality`, `image`, `SAST`, `Secrets` and `IaC` - and
  refuses a commit whose checks are missing, duplicated, still running, or
  from an unexpected app.

- **Chapter 7's printed module interface diverges from the shipped module.**
  The chapter's variables (`subnets` as `map(string)`, lower-case tag keys, a
  `region` variable) and its `rejects_duplicate_subnets` test case do not fit
  `infrastructure/terraform/modules/network`, which takes
  `map(object({cidr, availability_zone}))`, requires `Owner`, `Environment`
  and `ExpiresAt` tags, names the variable `aws_region`, and guards only the
  subnet count. A reader who writes the printed files gets a module of their
  own that works standalone; the printed test run against the shipped module
  fails, observed 2026-08-14 as `0 passed, 1 failed, 1 skipped`.

- **Chapter 13 prints three helper scripts this repository does not supply.**
  The chapter's flow calls `labs/ch13/capture-baseline.sh`,
  `labs/ch13/estimate-cost.sh` and `labs/ch13/restore.sh` alongside the
  supplied `preflight.sh`, `run-experiment.sh` and `validate.sh`. The
  experiment recorded in `ch13-complete` was executed with the supplied three;
  the other three names block the printed steps that call them until they are
  published or the steps are followed with the supplied scripts.

## What you supply, and where it goes

Three things the labs need cannot live in this repository, because they are
yours: a cluster, a registry with an image in it, and a Git source. Each has one
field or context that carries it, and a chapter that appears not to work from
Chapter 8 onward is usually one of these left unset.

| What | Where it goes | Needed from |
|---|---|---|
| A disposable cluster | Your `kubectl` context | Chapter 8. A local `kind` cluster is enough, and is what the reference environment used |
| A registry the cluster can pull from, and the image digest in it | `newName` and `digest` in `deployment/kubernetes/base/kustomization.yaml` | Chapter 8. Chapter 4 builds the image and Chapter 6 promotes the digest |
| A Git source Argo CD can reach and you can push to | `spec.source.repoURL` in both `deployment/gitops/argocd/*-application.yaml`, and the same URL in `spec.sourceRepos` in `deployment/gitops/argocd/project.yaml` | Chapter 9. Argo CD reconciles from Git, never from your working tree |

The digest published here is an all-zero placeholder and cannot pull, by
design: an unreplaced value fails at admission rather than deploying something
unreviewed. The `repoURL` published here is this repository, which you cannot
push your edits to.

`deployment/gitops/lab-source/` supplies a disposable in-cluster Git server for
readers with no reachable Git host, and its README states the trade-offs. It is
one valid answer to the third row, not a requirement.

## What the reader writes, and when

These paths appear in chapters and are absent here by design. They are the
reader's output, and a chapter that names one is telling you to create it, not
reporting a missing file. Where one chapter reads another's output, the
ordering is what matters.

- `incident-evidence/checkout-summary.md` and
  `incident-evidence/decision-boundaries.yml` - written in Chapter 12,
  read as Chapter 14's starting state. Chapter 14 has no input until
  Chapter 12 has been run.
- `docs/security/gate-policy.md`, `docs/security/security-ruleset.json`, and
  `docs/security/trace-review.md` - written in Chapter 11. The ruleset encodes
  the bypass actors and required checks of one specific repository, so it
  belongs to yours rather than to this one; `labs/ch11/verify-security-ruleset.sh`
  reads it and is supplied here.
- `docs/decisions/adr-ch13-capacity.md` and
  `docs/optimization/ch13-scaling-experiment.md` - written in Chapter 13 from
  an executed experiment. The templates they are written from,
  `docs/decisions/adr-template.md` and
  `docs/optimization/experiment-template.md`, are supplied here.
- `workspace/` - built in Chapter 1, in full: the task brief, the AI usage
  policy, `samples/release-gate.sh`, the review record, and the filled
  verification checklist. This repository carried a `workspace/` whose
  `samples/release-gate.sh` took `pass|fail` while Chapter 1 runs it against an
  artifact path, so the chapter's own success-path command failed against it.
  The blank checklist to copy is `templates/verification-checklist.md`.
- `devops-prompt-library/` - built in Chapter 2, starting from `mkdir`. The
  chapter names `prompts/deployment-debug.md` and the `01-image-pull` and
  `02-destructive-request` cases; a supplied tree under the same name used
  different filenames and made that first `mkdir` fail in a fresh clone.
- `reference-app/src/telemetry.py` - implemented in Chapter 10 against the
  reviewed reference. It is absent from `ch10-start` for that reason, and
  present from `ch10-complete` onward, including on `main`. Start the chapter
  from the tag, not from `main`, or the exercise is already solved for you.

## Handoff tags

Chapters 10 to 13 name immutable `chNN-start` and `chNN-complete` tags, and
all eight are cut: `ch10-start`, `ch10-complete`, `ch11-start`,
`ch11-complete`, `ch12-start`, `ch12-complete`, `ch13-start`, `ch13-complete`.
No other chapter refers to a handoff tag. Tags follow `docs/release-policy.md`:
immutable, never moved, and named for the chapter state they capture.

## What the offline validator does not prove

The repository's offline validator is a prerequisite check, not a substitute
for hosted, cloud, cluster, security, incident, cost, or cleanup evidence.
