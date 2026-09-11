# Subject-to-repository contract

This file is the canonical contract between the book and this repository.
Where a chapter and this map disagree about a path, an environment name, or a
workload name, this map is correct and the chapter is wrong.
Report the difference through the errata channel named in
`docs/release-policy.md`.

The contract is keyed by **subject**, not by chapter number.
A subject names the work; a chapter number names where the work currently sits
in the book, and reordering a book must not invalidate a printed path. The lab
directories, the `make` targets and the handoff tags are all named for subjects
for that reason, so `labs/gitops/`, `make gitops-start` and `gitops-start` all
refer to the same thing.

## Which chapter is which subject

| Subject | Chapter |
|---|---:|
| `reference-app` | 2 |
| `container` | 3 |
| `delivery` | 4 |
| `infrastructure` | 5 |
| `cluster` | interlude |
| `kubernetes` | 6 |
| `gitops` | 7 |
| `observability` | 8 |
| `security` | 9 |
| `incident` | 10 |
| `assistant` | 11 |
| `agent` | 12 |
| `capstone` | 13 |

Thirteen subjects across twelve chapters and the interlude.
Chapter 1 ships no companion material by contract: the reader builds
`workspace/` and `devops-prompt-library/` from `mkdir`, outside this clone,
and the book alone is sufficient.
Chapter 4 covers both CI and delivery in one lab, `labs/delivery/`, and
chapter 10 covers both incident response and capacity through
`labs/incident/`.
The name `ci` survives only in the immutable `ci-complete` tag and its `make`
target; `capacity` survives in the `capacity-start` and `capacity-complete`
tags and in `labs/capacity/`, which ships the helper scripts the chapter
calls by name rather than a printed-block mirror of its own.

## What each subject starts from, carries, and ends with

| Subject | Starting state | Carried in | Primary paths | Ending state | Validation |
|---|---|---|---|---|---|
| `reference-app` | A new directory outside the clone, created by the chapter's `mkdir` | The chapter's service contract | `reference-app/src`, `reference-app/tests` | `reference-app` serving `/`, `/health`, and `/ready` on port 8080 | The chapter's suite: `python3 -m unittest discover -s tests` reporting `Ran 11 tests` and `OK` |
| `container` | The `v1.0.0` checkout's `reference-app/` | `reference-app/src` | `reference-app/Dockerfile`, `reference-app/.dockerignore` | A non-root multi-stage image measured against a single-stage baseline | The chapter's `docker build` and label assertions |
| `delivery` | `delivery-start`, on a fork the reader owns | The reviewed CI gate | `.github/workflows/ci.yml`, `.github/workflows/delivery.yml`, `.github/workflows/rollback.yml` | One immutable digest promoted through human approval, and a tested rollback | The chapter's Static Validation step |
| `infrastructure` | The `v1.0.0` checkout | The promoted digest | `infrastructure/terraform/` | A defended network plan by the no-apply route | `terraform validate` |
| `kubernetes` | The `v1.0.0` checkout, plus the interlude's disposable cluster | The promoted digest | `deployment/kubernetes/base`, `deployment/kubernetes/tests` | A hardened workload in `reference-dev` with allowed and denied paths proved | `kubectl kustomize deployment/kubernetes/base` |
| `gitops` | The `v1.0.0` checkout and the `kubernetes` workload | `deployment/kubernetes/base`, unchanged | `deployment/gitops/argocd`, `deployment/gitops/overlays` | Staging reconciled automatically, production promoted deliberately | `kubectl kustomize deployment/gitops/overlays/staging` |
| `observability` | `observability-start` | The reconciled release identity | `observability/`, `labs/observability/` | A correlated signal, an owned alert, and a runbook | The chapter's `./labs/observability/validate.sh` |
| `security` | `security-start` | The release identity | `security/`, `rules/semgrep.yml`, `.github/workflows/security.yml` | Findings that carry a disposition and an owner | `./scripts/validate-offline.sh` |
| `incident` | `capacity-start`, which carries the completed incident starting assets | The application and its telemetry | `incidents/`, `optimization/`, `labs/incident/`, `labs/capacity/` | A controlled failure diagnosed and restored under human control, and a measured retain-or-revert decision | The chapter's `labs/incident/validate.sh` |
| `assistant` | The `v1.0.0` checkout | Nothing; the knowledge document is written in the chapter's own Step 1 | `operations-assistant/`, `labs/assistant/` | Cited read-only answers with tested refusals, evidenced by the reader's knowledge doc | `labs/assistant/validate.sh` |
| `agent` | `agent-complete` | The approved knowledge set | `operations-agent/` | Allowlisted reads, a bounded proposal, an audit record, and no mutation | `cd operations-agent && python3 -m unittest discover -s tests` |
| `capstone` | `capstone-start` | The release identity and evidence manifest | `docs/capstone/`, `infrastructure/terraform/capstone/`, `labs/capstone/` | CAP-01 to CAP-07 visible and evidence-linked | The chapter's `labs/capstone/capstone-verify.sh` runs |

The `cluster` subject has no row because it is the interlude's lab environment,
not a chapter's project; `labs/cluster/README.md` and the interlude itself are
its contract.

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
| Staging Application | `reference-staging` |
| Production Application | `reference-production` |
| Argo CD project | `ai-native-devops` |

## How a subject reaches its starting state

There are two routes, and each chapter prints exactly one of them.

Where a handoff tag is cut, the chapter prints a `make` target: chapter 4
prints `make delivery-start`, chapter 8 `make observability-start`, chapter 9
`make security-start`, chapter 10 `make capacity-start`, chapter 12
`make agent-complete`, and chapter 13 `make capstone-start`.
The target resolves the name through `scripts/start-lab.sh`, so this
repository can be restructured without invalidating a printed page, and it
checks out the immutable tag on a disposable `lab/<subject>` branch.
If the handoff tag has not been cut, the target says so and exits 3 rather
than failing obscurely.

Where no handoff tag is cut, the chapter pins the release directly: chapters
3, 5, 6, 7, and 11 print `git switch --detach v1.0.0` as their starting
command, most with a `git status --porcelain` cleanliness test alongside.
A release tag is as immutable as a handoff tag, so both routes give the
chapter a verified, reproducible starting state.

Chapters 1 and 2 start outside the clone entirely, with a `mkdir` printed on
the page, and need no repository state at all.

## Path aliases

Earlier editions printed some paths that differed from where the files live
here, and this section carried the translation table.
The second edition prints repository paths as they are, and no alias is
currently needed.
If you find a printed path this repository does not contain, check "What the
reader writes, and when" below first, then report it through the errata
channel; a confirmed difference would be recorded here.

## A handoff tag can predate what its subject applies

The `<subject>-*` tags are cut from executed states, so each predates whatever
landed after it.
Where that later work includes something the chapter itself applies, the
chapter cannot run from its own starting state, and the tag must be re-cut.

This release re-cuts four tags for exactly that reason, so each now carries
what its chapter applies: `observability-start` and `observability-complete`
carry `observability/collector-deployment.yaml`, the `le="1"` fixture bucket,
and the telemetry export wiring the chapter's live checks need;
`security-start` carries `rules/semgrep.yml`; and `capstone-start` carries the
run-binding verifier work the chapter depends on.

The incident case is handled by the chapter's own start choice instead:
`incident-start` predates `deployment/gitops/overlays/incident/`, the healthy
baseline the chapter deploys, so chapter 10 starts from `capacity-start`,
which points at the same tree as `incident-complete` and carries the overlay.

## One subject's cleanup removes the next subject's starting state

Each chapter's Cost and Cleanup step is right on its own terms, and the
sequence can still break: a chapter may begin from something the chapter
before has just deleted from the cluster.
Redeploying is one command, and knowing that in advance is the point.

| Deleted by | Needed by | Restore with |
|---|---|---|
| The gitops lab's Cost and Cleanup step removes `reference-staging` | The observability lab's environment checks | `kubectl apply -k deployment/gitops/overlays/staging` |

The observability lab additionally needs the `observability` namespace, which
is created by `observability/collector-deployment.yaml` rather than by any
chapter.

## Why these names have no chapter numbers

Lab folders, make targets and handoff tags are named after their subject, not
after a chapter number, so a printed path stays correct when the book is
reordered, and a reader adopting one piece on an existing project can find it by
what it does.

## Known gaps in this contract

These are recorded rather than hidden. A gap here is something the book names
that this repository does not supply; an artifact the reader is meant to write
is listed in the section below instead, because calling it a gap told readers
their lab was blocked when it was not.

- **Nothing in this repository is validated against a live cloud account.**
  `scripts/validate-offline.sh` reports
  `live_cloud_cluster_delivery_cleanup=not_evaluated`, and that is accurate.
  The cluster work - the interlude, chapters 6 to 10, and the capstone - was
  verified on a local kind cluster, and the infrastructure chapter's Terraform
  takes the no-apply route unless you supply and approve your own sandbox.

- **The delivery route runs, and needs configuration you must supply.**
  `delivery.yml` and `rollback.yml` implement the contract the
  chapter audits against, and both were exercised end to end on 2026-08-10.
  They require two repository environments, `staging` and `production`, with
  deployment branches restricted to `main` and a required reviewer on
  `production` who is not the person dispatching the run. Without them the
  jobs will not gate, and with self-review permitted the chapter's independence
  checkpoint is not met. Protected-check verification uses this repository's
  real check names - `quality`, `image`, `SAST`, `Secrets` and `IaC` - and
  refuses a commit whose checks are missing, duplicated, still running, or
  from an unexpected app.

- **The reference application ships pre-solved on `main`.** Chapter 2 has you
  build `reference-app`, but later chapters depend on the finished app, so it
  ships here in full and there is no `reference-app-start` tag to hide it (a
  tag is only cut from an executed state, and no pre-app state of this
  repository was ever executed).
  The chapter's printed route already accounts for this: its starting command
  creates a new `reference-app/` directory outside the clone, every printed
  command then behaves as the page says, and the shipped app is your solution
  key.

- **The chapter's printed run command fails against the shipped app.**
  `python3 -m src.app` dies with `No module named 'telemetry'` against
  `reference-app/src/app.py` on `main`, which carries the observability
  refactor's flat `import telemetry`.
  Against the app as the chapter has you write it, outside the clone, the
  printed form works; against the shipped app, run `python3 src/app.py` with
  the same environment variables instead.
  The shipped app's startup banner also carries fields the chapter's expected
  result does not show - `fault_gate`, `trace_header` and
  `injected_latency_ms`, added by the observability and incident work - which
  is correct here rather than a misconfiguration.

- **The shipped test tree runs more tests than the chapter prints.** Chapter 2
  expects `Ran 11 tests`; `cd reference-app && python3 -m unittest discover
  -s tests` in this clone runs more, because the observability and incident
  suites ship alongside the chapter's own.
  Against the app you build outside the clone, the printed count holds.
  A passing run on an untouched clone proves the shipped suites still work,
  not that your chapter work was done.

- **The pinned checkout already ships a finished `reference-app/Dockerfile`.**
  Chapter 3 has you write `.dockerignore`, `Dockerfile.baseline`, and the
  multi-stage `Dockerfile` yourself; writing them replaces the shipped
  single-stage file in your working tree, which is the intended flow, and the
  next clean checkout restores it.
  Judge your work by the chapter's build, label, and runtime assertions, not
  by a diff against the shipped file.

## What you supply, and where it goes

Three things the labs need cannot live in this repository, because they are
yours: a cluster, a registry with an image in it, and a Git source. Each has one
field or context that carries it, and a chapter that appears not to work from
the kubernetes subject onward is usually one of these left unset.

| What | Where it goes | Needed from |
|---|---|---|
| A disposable cluster | Your `kubectl` context | The kubernetes lab. A local `kind` cluster is enough, and is what the reference environment used; the interlude's `labs/cluster/` builds it |
| A registry the cluster can pull from, and the image digest in it | `newName` and `digest` in `deployment/kubernetes/base/kustomization.yaml` | The kubernetes lab. The container lab builds the image and the delivery lab promotes the digest |
| A Git source Argo CD can reach and you can push to | `spec.source.repoURL` in both `deployment/gitops/argocd/*-application.yaml`, and the same URL in `spec.sourceRepos` in `deployment/gitops/argocd/project.yaml` | The gitops lab. Argo CD reconciles from Git, never from your working tree |

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
reporting a missing file.

- `workspace/`, with `devops-prompt-library/` and the single running
  `platform-log.md` inside it - built in chapter 1, outside this clone,
  starting from the chapter's printed `mkdir`.
- `reference-app/` as your own build - created in chapter 2, also outside this
  clone, beside `workspace/` in the same book-workspace directory.
- `security/gate-policy.md` and the chapter's security ruleset - written in
  chapter 9, the policy from `security/README.md` and the ruleset at the
  git-internal path the chapter prints.
- `reference-app/src/telemetry.py` - implemented in chapter 8 against the
  reviewed reference. It is deliberately absent from `observability-start`,
  and present from `observability-complete` onward, including on `main`.
  Start the chapter from the tag, not from `main`, or the exercise is already
  solved for you.
- `operations-assistant/knowledge/checkout-api.md` - the approved knowledge
  document you write in chapter 11's Step 1, from the frontmatter template in
  `labs/assistant/config/`; the chapter's validator checks it, so it fails on
  an untouched clone by design.

## Handoff tags

Fourteen immutable tags are cut, and six chapters start from one:
`ci-complete`, `delivery-start` and `delivery-complete` (chapter 4),
`observability-start` and `observability-complete` (chapter 8),
`security-start` and `security-complete` (chapter 9), `incident-start`,
`incident-complete`, `capacity-start` and `capacity-complete` (chapter 10),
`agent-complete` (chapter 12), and `capstone-start` and `capstone-complete`
(chapter 13).
Chapters without a cut tag pin the release with `git switch --detach v1.0.0`
instead, as "How a subject reaches its starting state" above records.
Tags follow `docs/release-policy.md`: immutable, never moved, and named for
the state they capture.
Where a chapter's needs outgrow a tag's content, the tag is re-cut rather than
moved, as the re-cut note above records for this release.

## What the offline validator does not prove

The repository's offline validator is a prerequisite check, not a substitute
for hosted, cloud, cluster, security, incident, cost, or cleanup evidence.
