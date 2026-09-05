# Subject-to-repository contract

This file is the canonical contract between the book and this repository.
Where a chapter and this map disagree about a path, an environment name, or a
workload name, this map is correct and the chapter is wrong.
Report the difference through the errata channel named in
`docs/release-policy.md`.

The contract is keyed by **subject**, not by chapter number.
A chapter number means different work in different editions; a subject does not
move. The lab directories, the `make` targets and the handoff tags are all named
for subjects for the same reason, so `labs/gitops/`, `make gitops-start` and
`gitops-start` all refer to the same thing in any edition.

## Which chapter is which subject

Find your book on the cover, then read down its column.

| Subject | Second edition | First edition (archived) |
|---|---:|---:|
| `method` | 1 | 1 |
| `prompt-library` | 1 | 2 |
| `reference-app` | 2 | 3 |
| `container` | 3 | 4 |
| `ci` | 4 | 5 |
| `delivery` | 4 | 6 |
| `infrastructure` | 5 | 7 |
| `kubernetes` | 6 | 8 |
| `gitops` | 7 | 9 |
| `observability` | 8 | 10 |
| `security` | 9 | 11 |
| `incident` | 10 | 12 |
| `capacity` | 10 | 13 |
| `assistant` | 11 | 14 |
| `agent` | 12 | 15 |
| `capstone` | 13 | 16 |
| `cluster` | interlude | interlude |

The second edition covers the same seventeen subjects in thirteen chapters, so
two of its chapters carry two subjects each: chapter 1 covers `method` and
`prompt-library`, chapter 4 covers `ci` and `delivery`, and chapter 10 covers
`incident` and `capacity`.

The first edition was never published and is archived; its column is here so
that anyone holding that draft can still locate a lab.

## What each subject starts from, carries, and ends with

| Subject | Starting state | Carried in | Primary paths | Ending state | Validation command |
|---|---|---|---|---|---|
| `method` | Empty workspace | Nothing | `ai-native-workspace/`, which you create | A verified script with an observed success and failure path, and a recorded decision | The chapter's own syntax, success and failure runs |
| `prompt-library` | The `method` workspace | The verification checklist | `devops-prompt-library/`, which you create | Reusable prompts with deterministic evaluation cases | The chapter's own artifact-presence block |
| `reference-app` | The `prompt-library` library | The prompt library | `reference-app/src`, `reference-app/tests` | `reference-app` serving `/`, `/health`, and `/ready` on port 8080 | `cd reference-app && python3 -m unittest discover -s tests` |
| `container` | The `reference-app` service | `reference-app/src` | `reference-app/Dockerfile`, `reference-app/.dockerignore` | A non-root image measured against a single-stage baseline | The chapter's `docker build` and label assertions |
| `ci` | The `container` image | The Dockerfile and tests | `.github/workflows/ci.yml` | Required checks enforced on `main` for one revision | `actionlint .github/workflows/ci.yml` |
| `delivery` | The `ci` pipeline | The required check names | `.github/workflows/delivery.yml`, `.github/workflows/rollback.yml` | One immutable digest promoted through human approval, and a tested rollback | `actionlint .github/workflows/*.yml` |
| `infrastructure` | The `delivery` digest | The promoted digest | `infrastructure/terraform/`, fixture at `infrastructure/terraform/fixtures/` | A reviewed network foundation by the no-apply or the separately approved sandbox route | `terraform validate` |
| `kubernetes` | The `infrastructure` foundation, plus a separately supplied cluster | The promoted digest | `deployment/kubernetes/base`, `deployment/kubernetes/tests` | A hardened workload in `reference-dev` with policy behavior observed | `kubectl kustomize deployment/kubernetes/base` |
| `gitops` | The `kubernetes` workload | `deployment/kubernetes/base`, unchanged | `deployment/gitops/argocd`, `deployment/gitops/overlays` | Staging reconciled automatically, production promoted deliberately | `kubectl kustomize deployment/gitops/overlays/staging` |
| `observability` | The `gitops` path | The reconciled release identity | `observability/`, `labs/observability/` | A correlated signal, an owned alert, and a runbook | `labs/observability/validate.sh` |
| `security` | The `observability` telemetry | The release identity | `security/`, CI jobs | Findings that carry a disposition and an owner | `./scripts/validate-offline.sh` |
| `incident` | The `security` gates | The application and its telemetry | `incidents/`, `labs/incident/` | A controlled failure diagnosed and restored under human control | `labs/incident/validate.sh` |
| `capacity` | The `incident` record | The incident evidence | `optimization/` | Comparable candidates and a retain-or-revert decision | `./scripts/validate-offline.sh` |
| `assistant` | The `incident` sanitized summary | `docs/incidents/ch12-controlled-failure.md` | `operations-assistant/`, `labs/assistant/` | Cited read-only answers with tested refusals, evidenced by the reader's knowledge doc | `labs/assistant/validate.sh` |
| `agent` | The `assistant` assistant | The approved knowledge set | `operations-agent/` | Allowlisted reads, a bounded proposal, an audit record, and no mutation | `cd operations-agent && python3 -m unittest discover -s tests` |
| `capstone` | Every prior subject | The release identity and evidence manifest | `docs/capstone/`, `infrastructure/terraform/capstone/`, `labs/capstone/` | CAP-01 to CAP-07 visible and evidence-linked | `labs/capstone/capstone-verify.sh` |

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
| Incident evidence carried into the assistant lab | `docs/incidents/ch12-controlled-failure.md` |

## How a subject reaches its starting state

A chapter prints `make <subject>-start`, never a git command. The Makefile target
resolves the name through `scripts/start-lab.sh`, so this repository can be
restructured without invalidating a printed page. If the handoff tag has not
been cut, the target says so and exits 3 rather than failing obscurely.

## Path aliases

Some chapters name a path that differs from where the file lives here. This map
is authoritative, per the statement at the top of this file. These are the known
differences; a chapter naming the left-hand path means the right-hand file.

| Named in the book | Actual path here | Subjects |
|---|---|---|
| `src/app.py`, `src/telemetry.py` | `reference-app/src/` | `reference-app`, `container`, `observability` |
| `docs/incidents/post-incident-review.md` | `incidents/templates/post-incident-review.md` | `incident` |
| `docs/optimization/scorecard-template.md` | `optimization/scorecard-template.md` | `capacity` |
| `docs/security/finding-disposition.yaml` | `security/finding-disposition-template.yaml` | `security` |
| `agents/k8s-diagnostics/` | `operations-agent/` | `agent` |
| `workspace/` | `ai-native-workspace/`, which the reader creates; the method lab script names the directory in full | `method` |
| `infrastructure/modules/`, `infrastructure/environments/` | `infrastructure/terraform/modules/`, `infrastructure/terraform/environments/` | `infrastructure` |

## A handoff tag can predate what its subject applies

The `<subject>-*` tags are cut from executed states, so each predates whatever landed
after it. Where that later work includes something the chapter itself applies,
the chapter cannot run from its own starting state.

The known case is the incident lab. `deployment/gitops/overlays/incident/` is the
healthy baseline Step 1 deploys, and it first appears at `incident-complete`;
`incident-start` carries only the staging and production overlays.
`labs/incident/preflight.sh` fails on it by name and prints the restore command, so
this surfaces before anything is applied:

    git checkout main -- deployment/gitops/overlays/incident

`labs/` was the same shape and is handled differently: `scripts/start-lab.sh`
carries it forward, because it is the harness rather than chapter content. An
overlay a chapter applies is content, and carrying it forward automatically
would risk pre-solving work the reader is meant to do.

## One subject's cleanup removes the next subject's starting state

Each chapter's Cost and Cleanup step is right on its own terms, and the
sequence still breaks: three chapters begin from something the chapter before
has just deleted. Redeploying is one command, and knowing that in advance is
the point.

| Deleted by | Needed by | Restore with |
|---|---|---|
| The gitops lab's `15-delete-applications.sh` removes `reference-staging` | The observability lab's `01-check-environment.sh` | `kubectl apply -k deployment/gitops/overlays/staging` |
| The incident lab's `10-cleanup-namespace.sh` removes `reference-incident` | The capacity lab's `preflight.sh`, which defaults to that namespace | `kubectl apply -k deployment/gitops/overlays/incident` |

The observability lab additionally needs the `observability` namespace, which is created
by `observability/collector-deployment.yaml` rather than by any chapter.

## Why these names have no chapter numbers

Lab folders, make targets and handoff tags are named after their subject, not
after a chapter number. Chapter numbers change between editions and subjects do
not, so a printed path stays correct when the book is reordered, and a reader
adopting one piece on an existing project can find it by what it does.

The first edition's `chNN-*` tags are still present and still immutable. Each
subject tag points at the same commit as the chapter tag it replaces, so both
editions resolve to the same verified state and neither can shadow the other.

## Known gaps in this contract

These are recorded rather than hidden. A gap here is something the book names
that this repository does not supply; an artifact the reader is meant to write
is listed in the section below instead, because calling it a gap told readers
their lab was blocked when it was not.

- **Nothing in this repository is validated against a live cloud account.**
  `scripts/validate-offline.sh` reports
  `live_cloud_cluster_delivery_cleanup=not_evaluated`, and that is accurate.
  The cluster work in Chapters 10 to 13 was verified on a local kind cluster.
  the infrastructure lab's Terraform takes the no-apply route unless you supply and approve
  your own sandbox.

- **The delivery lab's delivery route now runs, and needs configuration you must
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

- **The infrastructure lab's printed module interface diverges from the shipped module.**
  The chapter's variables (`subnets` as `map(string)`, lower-case tag keys, a
  `region` variable) and its `rejects_duplicate_subnets` test case do not fit
  `infrastructure/terraform/modules/network`, which takes
  `map(object({cidr, availability_zone}))`, requires `Owner`, `Environment`
  and `ExpiresAt` tags, names the variable `aws_region`, and guards only the
  subnet count. A reader who writes the printed files gets a module of their
  own that works standalone; the printed test run against the shipped module
  fails, observed 2026-08-14 as `0 passed, 1 failed, 1 skipped`.

- **The reference-app lab arrives pre-solved on `main`.** The chapter has you build
  `reference-app`, but later chapters depend on the finished app, so it ships
  here in full and there is no `reference-app-start` tag to hide it (a tag is only cut
  from an executed state, and no pre-app state of this repository was ever
  executed). Choose a route before the chapter's Step 1: build your own
  `reference-app` from the printed page in a directory outside the clone
  (every printed command then behaves as the page says, and the shipped app is
  your solution key), or work against the shipped app and skip the scaffold
  step, whose `git init` would otherwise nest a second repository inside the
  clone. `labs/reference-app/README.md` states both routes; from the container lab onward the
  labs use the clone's `reference-app/` either way.

- **The reference-app lab's printed run command fails against the shipped app.**
  `python3 -m src.app` (Steps 4, Break It, and Troubleshooting) dies with
  `No module named 'telemetry'` against `reference-app/src/app.py` on `main`,
  which carries the observability lab refactor's flat `import telemetry`. Run
  `python3 src/app.py` with the same environment variables instead; the printed
  form works against the app as the chapter has you write it. Observed
  2026-08-17; worst in the Break It step, which exits nonzero with the wrong
  error, so confirm the `ValueError`, not just a failure. The shipped app's
  startup banner also carries three fields the chapter's expected result does
  not show - `fault_gate`, `trace_header` and `injected_latency_ms`, added by
  the observability lab and 12 work - which is correct here rather than a
  misconfiguration.

- **Printed expected test output describes the chapter-time suites, not the
  shipped tree.** the reference-app lab says ten passing tests, but `main` runs 37 (the
  the observability lab and 12 suites ship alongside). The assistant lab's printed names now
  match the shipped six-test suite, and its validator (`labs/assistant/validate.sh`,
  also `make assistant-validate`) checks the reader's knowledge doc and the demo
  behavior, so it fails on an untouched clone by design. The reference-app lab's
  validation command still passes on an untouched fresh clone, so it proves
  the shipped suite still works, not that the reader's chapter work was done -
  the chapter's own artifacts (the evidence file) are the reader-side proof. The reference-app lab's ten printed test *names* are
  renamed too, not just outnumbered: none of them exists in the shipped tree,
  so a reader grepping for one finds nothing and reads it as a missing suite.
  `reference-app/tests/test_app.py` holds exactly those ten contracts under
  different names, and `labs/reference-app/README.md` maps each printed name to its
  shipped one.

- **The container lab's shipped Dockerfile is the observability lab file, so the chapter's
  validation cannot pass against it.** `reference-app/Dockerfile` on `main` is
  single-stage on `python:3.12-alpine` with a `pip install` and no `ARG` or
  `LABEL`, not the multi-stage build the chapter prints as
  `labs/container/config/03-dockerfile-final.dockerfile`. This row's validation entry
  is the chapter's `docker build` and label assertions, and against the shipped
  file the three build args are rejected as unconsumed and `title`, `revision`
  and `source` come back empty. The Break It step is worse than a failure: 11's
  `awk` deletes a line the shipped file does not contain, so the "broken" image
  is byte-for-byte the working one, it starts, and the script prints
  `unexpected success: investigate before continuing`. Write
  `config/03-dockerfile-final.dockerfile` to `reference-app/Dockerfile` for the
  chapter and restore it afterwards; `labs/container/README.md` states the route.
  Step 06 still cannot pass on the shipped-app route, because an image built
  from the chapter's Dockerfile cannot run the shipped application: the flat
  `import telemetry` does not resolve under `python3 -m src.app`, and the
  chapter's Dockerfile installs no dependencies. A reader who built their own
  the reference-app lab application outside the clone is unaffected, which makes that route
  choice consequential beyond the reference-app lab. Separately, the baseline and final
  images the chapter has you measure share `python:3.12-slim`, which is about
  99.99% of both, and the baseline's `COPY . .` ships whatever the build context
  holds: the byte comparison is decided by the reader's directory and has been
  measured with either sign, while the file count under `/app` and the image
  user are stable. `labs/container/README.md` carries the numbers.

- **The infrastructure lab's scaffold creates the book's paths as empty directories, and
  Terraform then validates one of them successfully.** `01-setup-workspace.sh`
  ends with `mkdir -p infrastructure/modules/network
  infrastructure/environments/dev docs/decisions`. Those first two are the
  book's names for `infrastructure/terraform/modules/` and
  `infrastructure/terraform/environments/`, per the path alias table above, and
  `mkdir -p` does not resolve an alias: it creates two empty directories beside
  the real configuration. `03-validate-config.sh` then starts with
  `cd infrastructure/environments/dev`, which now resolves to the empty one,
  where `terraform init` reports no configuration files and `terraform validate`
  prints `Success! The configuration is valid.` at exit 0 - character for
  character the chapter's expected result, with nothing validated. This row's
  validation entry is `terraform validate`, so the chapter can report success
  against a directory holding no infrastructure. Run 03 and 06 from
  `infrastructure/terraform/environments/dev` and
  `infrastructure/terraform/modules/network` instead, where the configuration is
  real and genuinely valid. Relatedly, `06-test-module.sh` runs
  `terraform test` against a module that ships no `.tftest.hcl`, which reports
  `Success! 0 passed, 0 failed.` - the chapter's expected line differs only in
  the count, which is the only part carrying information. Writing
  `labs/infrastructure/config/05-network.tftest.hcl` into the module is what the chapter
  intends, and it then fails as the module-interface entry below records.

- **The chapters assume the application and `.github/` share one repository.**
  The book's blocks run from a single root holding `src/`, `tests/`,
  `Dockerfile` and `.github/workflows/`; here the application is under
  `reference-app/` and the workflows are at the repository root, so a block
  naming both cannot pass from either directory. The ci lab's
  `04-review-workflow.sh` stages `requirements-dev.txt` beside
  `.github/workflows/ci.yml` and fails with `pathspec 'requirements-dev.txt'
  did not match any files`. The delivery lab's `01-check-prereqs.sh` tests
  `.github/workflows/ci.yml`, `Dockerfile`, `src/app.py` and
  `tests/test_app.py` in one directory: the first exists only at the root and
  the other three only under `reference-app/`, so three of the four always
  fail. Neither script sets `-e`, and both end on a command that succeeds
  regardless, so each reports success while its assertions fail - which for
  the delivery lab is the prerequisite gate of a chapter that pushes an image and
  promotes a digest. Run the file checks from the directory that holds the
  files and read the results rather than the exit code; `labs/ci/README.md`
  and `labs/delivery/README.md` name which directory is which.

- **The ci lab's printed workflow fails the chapter's own validation command,
  and its local check blocks report success either way.** Written to
  `.github/workflows/ci.yml` as Step 2 directs,
  `labs/ci/config/02-ci-workflow.yaml` exits 1 under actionlint with
  shellcheck installed - one `SC2034` for a loop variable the retry never uses,
  four `SC2317` against the `cleanup` trap - while this row's validation entry,
  `actionlint .github/workflows/ci.yml`, passes because the live workflow is
  clean. The result also depends on shellcheck being installed, since actionlint
  skips the shell analysis without it. Separately, `03-run-local-checks.sh` and
  `06-validate-local-layer.sh` set no `-e` and end on a command that succeeds
  regardless, so both exit 0 whatever Ruff and unittest reported; the same holds
  for `02-check-tool-versions.sh` with a tool missing. `labs/ci/README.md`
  lists these and the split-layout consequences for 04 and 07.

- **The method lab's workspace validation checks one of the checklist's seven
  sections.** `labs/method/08-validate-workspace.sh` asserts that
  `evidence/verification-checklist.md` exists, is non-empty, carries
  `## Test results`, and holds no `| pending |` cell. The other six sections -
  `## Evidence metadata`, `## Intent`, `## Information safety`,
  `## Technical correctness`, `## Engineering quality` and
  `## Evidence and decision` - are never checked, so a checklist carrying only
  a filled results table exits 0 against a block the chapter describes as
  confirming the checklist is complete. The script is verbatim book content and
  is not patched here. Read 08 passing as "the results table has no unreplaced
  placeholders", and confirm the remaining six sections yourself -
  `## Evidence and decision` above all, since it carries the chapter's own
  requirement that a named human owns the final decision.

- **The capacity lab prints three helper scripts this repository does not supply.**
  The chapter's flow calls `labs/capacity/capture-baseline.sh`,
  `labs/capacity/estimate-cost.sh` and `labs/capacity/restore.sh` alongside the
  supplied `preflight.sh`, `run-experiment.sh` and `validate.sh`. The
  experiment recorded in `capacity-complete` was executed with the supplied three;
  the other three names block the printed steps that call them until they are
  published or the steps are followed with the supplied scripts.

## What you supply, and where it goes

Three things the labs need cannot live in this repository, because they are
yours: a cluster, a registry with an image in it, and a Git source. Each has one
field or context that carries it, and a chapter that appears not to work from
The kubernetes lab onward is usually one of these left unset.

| What | Where it goes | Needed from |
|---|---|---|
| A disposable cluster | Your `kubectl` context | The kubernetes lab. A local `kind` cluster is enough, and is what the reference environment used |
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
reporting a missing file. Where one chapter reads another's output, the
ordering is what matters.

- `docs/incidents/ch12-controlled-failure.md` - the incident record you
  write in the incident lab from `incidents/templates/facts-incident-record.md`,
  read as the assistant lab's starting state. The assistant lab has no input until
  the incident lab has been run.
- `docs/security/gate-policy.md`, `docs/security/security-ruleset.json`, and
  `docs/security/trace-review.md` - written in the security lab. The ruleset encodes
  the bypass actors and required checks of one specific repository, so it
  belongs to yours rather than to this one; `labs/security/verify-security-ruleset.sh`
  reads it and is supplied here.
- `docs/decisions/adr-ch13-capacity.md` and
  `docs/optimization/ch13-scaling-experiment.md` - written in the capacity lab from
  an executed experiment. The templates they are written from,
  `docs/decisions/adr-template.md` and
  `docs/optimization/experiment-template.md`, are supplied here.
- `ai-native-workspace/` (the book sometimes says `workspace/` for short) -
  built in the method lab, in full: the task brief, the AI usage
  policy, `samples/release-gate.sh`, the review record, and the filled
  verification checklist. This repository carried a `workspace/` whose
  `samples/release-gate.sh` took `pass|fail` while the method lab runs it against an
  artifact path, so the chapter's own success-path command failed against it.
  The blank checklist to copy is `templates/verification-checklist.md`.
- `devops-prompt-library/` - built in the prompt-library lab, starting from `mkdir`. The
  chapter names `prompts/deployment-debug.md` and the `01-image-pull` and
  `02-destructive-request` cases; a supplied tree under the same name used
  different filenames and made that first `mkdir` fail in a fresh clone.
- `reference-app/src/telemetry.py` - implemented in the observability lab against the
  reviewed reference. It is absent from `observability-start` for that reason, and
  present from `observability-complete` onward, including on `main`. Start the chapter
  from the tag, not from `main`, or the exercise is already solved for you.

## Handoff tags

Chapters 10 to 13 name immutable `<subject>-start` and `<subject>-complete` tags, and
all eight are cut: `observability-start`, `observability-complete`, `security-start`,
`security-complete`, `incident-start`, `incident-complete`, `capacity-start`, `capacity-complete`.
No other chapter refers to a handoff tag. Tags follow `docs/release-policy.md`:
immutable, never moved, and named for the chapter state they capture.

## What the offline validator does not prove

The repository's offline validator is a prerequisite check, not a substitute
for hosted, cloud, cluster, security, incident, cost, or cleanup evidence.
