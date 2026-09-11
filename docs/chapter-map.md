# Chapter-to-repository contract

This file is the canonical contract between the book and this repository.
Where a chapter and this map disagree about a path, an environment name, or a
workload name, this map is correct and the chapter is wrong.
Report the difference through the errata channel named in
`docs/release-policy.md`.

## What each chapter starts from, carries, and ends with

| Chapter | Starting state | Carried in | Primary paths | Ending state | Validation command |
|---:|---|---|---|---|---|
| 1 | Empty workspace | Nothing | `ai-native-workspace/`, which you create | A verified script with an observed success and failure path, and a recorded decision | The chapter's own syntax, success and failure runs |
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
| 14 | Chapter 12 sanitized summary | `docs/incidents/ch12-controlled-failure.md` | `operations-assistant/`, `labs/ch14/` | Cited read-only answers with tested refusals, evidenced by the reader's knowledge doc | `labs/ch14/validate.sh` |
| 15 | Chapter 14 assistant | The approved knowledge set | `operations-agent/` | Allowlisted reads, a bounded proposal, an audit record, and no mutation | `cd operations-agent && python3 -m unittest discover -s tests` |
| 16 | Every prior chapter | The release identity and evidence manifest | `docs/capstone/`, `infrastructure/terraform/capstone/`, `labs/ch16/` | CAP-01 to CAP-07 visible and evidence-linked | `labs/ch16/capstone-verify.sh` |

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
| Incident evidence carried into Chapter 14 | `docs/incidents/ch12-controlled-failure.md` |

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
| `docs/incidents/post-incident-review.md` | `incidents/templates/post-incident-review.md` | 12 |
| `docs/optimization/scorecard-template.md` | `optimization/scorecard-template.md` | 13 |
| `docs/security/finding-disposition.yaml` | `security/finding-disposition-template.yaml` | 11 |
| `agents/k8s-diagnostics/` | `operations-agent/` | 15 |
| `workspace/` | `ai-native-workspace/`, which the reader creates; the Chapter 1 script names the directory in full | 1 |
| `infrastructure/modules/`, `infrastructure/environments/` | `infrastructure/terraform/modules/`, `infrastructure/terraform/environments/` | 7 |

## A handoff tag can predate what its chapter applies

The `chNN-*` tags are cut from executed states, so each predates whatever landed
after it. Where that later work includes something the chapter itself applies,
the chapter cannot run from its own starting state.

The known case is Chapter 12. `deployment/gitops/overlays/incident/` is the
healthy baseline Step 1 deploys, and it first appears at `ch12-complete`;
`ch12-start` carries only the staging and production overlays.
`labs/ch12/preflight.sh` fails on it by name and prints the restore command, so
this surfaces before anything is applied:

    git checkout main -- deployment/gitops/overlays/incident

`labs/` was the same shape and is handled differently: `scripts/start-chapter.sh`
carries it forward, because it is the harness rather than chapter content. An
overlay a chapter applies is content, and carrying it forward automatically
would risk pre-solving work the reader is meant to do.

## A chapter's cleanup removes the next chapter's starting state

Each chapter's Cost and Cleanup step is right on its own terms, and the
sequence still breaks: three chapters begin from something the chapter before
has just deleted. Redeploying is one command, and knowing that in advance is
the point.

| Deleted by | Needed by | Restore with |
|---|---|---|
| Chapter 9's `15-delete-applications.sh` removes `reference-staging` | Chapter 10's `01-check-environment.sh` | `kubectl apply -k deployment/gitops/overlays/staging` |
| Chapter 12's `10-cleanup-namespace.sh` removes `reference-incident` | Chapter 13's `preflight.sh`, which defaults to that namespace | `kubectl apply -k deployment/gitops/overlays/incident` |

Chapter 10 additionally needs the `observability` namespace, which is created
by `observability/collector-deployment.yaml` rather than by any chapter.

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

- **Chapter 3 arrives pre-solved on `main`.** The chapter has you build
  `reference-app`, but later chapters depend on the finished app, so it ships
  here in full and there is no `ch03-start` tag to hide it (a tag is only cut
  from an executed state, and no pre-app state of this repository was ever
  executed). Choose a route before the chapter's Step 1: build your own
  `reference-app` from the printed page in a directory outside the clone
  (every printed command then behaves as the page says, and the shipped app is
  your solution key), or work against the shipped app and skip the scaffold
  step, whose `git init` would otherwise nest a second repository inside the
  clone. `labs/ch03/README.md` states both routes; from Chapter 4 onward the
  labs use the clone's `reference-app/` either way.

- **Chapter 3's printed run command fails against the shipped app.**
  `python3 -m src.app` (Steps 4, Break It, and Troubleshooting) dies with
  `No module named 'telemetry'` against `reference-app/src/app.py` on `main`,
  which carries the Chapter 10 refactor's flat `import telemetry`. Run
  `python3 src/app.py` with the same environment variables instead; the printed
  form works against the app as the chapter has you write it. Observed
  2026-08-17; worst in the Break It step, which exits nonzero with the wrong
  error, so confirm the `ValueError`, not just a failure. The shipped app's
  startup banner also carries three fields the chapter's expected result does
  not show - `fault_gate`, `trace_header` and `injected_latency_ms`, added by
  the Chapter 10 and 12 work - which is correct here rather than a
  misconfiguration.

- **Printed expected test output describes the chapter-time suites, not the
  shipped tree.** Chapter 3 says ten passing tests, but `main` runs 37 (the
  Chapter 10 and 12 suites ship alongside). Chapter 14's printed names now
  match the shipped six-test suite, and its validator (`labs/ch14/validate.sh`,
  also `make ch14-validate`) checks the reader's knowledge doc and the demo
  behavior, so it fails on an untouched clone by design. Chapter 3's
  validation command still passes on an untouched fresh clone, so it proves
  the shipped suite still works, not that the reader's chapter work was done -
  the chapter's own artifacts (the evidence file) are the reader-side proof. Chapter 3's ten printed test *names* are
  renamed too, not just outnumbered: none of them exists in the shipped tree,
  so a reader grepping for one finds nothing and reads it as a missing suite.
  `reference-app/tests/test_app.py` holds exactly those ten contracts under
  different names, and `labs/ch03/README.md` maps each printed name to its
  shipped one.

- **Chapter 4's shipped Dockerfile is the Chapter 10 file, so the chapter's
  validation cannot pass against it.** `reference-app/Dockerfile` on `main` is
  single-stage on `python:3.12-alpine` with a `pip install` and no `ARG` or
  `LABEL`, not the multi-stage build the chapter prints as
  `labs/ch04/config/03-dockerfile-final.dockerfile`. This row's validation entry
  is the chapter's `docker build` and label assertions, and against the shipped
  file the three build args are rejected as unconsumed and `title`, `revision`
  and `source` come back empty. The Break It step is worse than a failure: 11's
  `awk` deletes a line the shipped file does not contain, so the "broken" image
  is byte-for-byte the working one, it starts, and the script prints
  `unexpected success: investigate before continuing`. Write
  `config/03-dockerfile-final.dockerfile` to `reference-app/Dockerfile` for the
  chapter and restore it afterwards; `labs/ch04/README.md` states the route.
  Step 06 still cannot pass on the shipped-app route, because an image built
  from the chapter's Dockerfile cannot run the shipped application: the flat
  `import telemetry` does not resolve under `python3 -m src.app`, and the
  chapter's Dockerfile installs no dependencies. A reader who built their own
  Chapter 3 application outside the clone is unaffected, which makes that route
  choice consequential beyond Chapter 3. Separately, the baseline and final
  images the chapter has you measure share `python:3.12-slim`, which is about
  99.99% of both, and the baseline's `COPY . .` ships whatever the build context
  holds: the byte comparison is decided by the reader's directory and has been
  measured with either sign, while the file count under `/app` and the image
  user are stable. `labs/ch04/README.md` carries the numbers.

- **Chapter 7's scaffold creates the book's paths as empty directories, and
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
  `labs/ch07/config/05-network.tftest.hcl` into the module is what the chapter
  intends, and it then fails as the module-interface entry below records.

- **The chapters assume the application and `.github/` share one repository.**
  The book's blocks run from a single root holding `src/`, `tests/`,
  `Dockerfile` and `.github/workflows/`; here the application is under
  `reference-app/` and the workflows are at the repository root, so a block
  naming both cannot pass from either directory. Chapter 5's
  `04-review-workflow.sh` stages `requirements-dev.txt` beside
  `.github/workflows/ci.yml` and fails with `pathspec 'requirements-dev.txt'
  did not match any files`. Chapter 6's `01-check-prereqs.sh` tests
  `.github/workflows/ci.yml`, `Dockerfile`, `src/app.py` and
  `tests/test_app.py` in one directory: the first exists only at the root and
  the other three only under `reference-app/`, so three of the four always
  fail. Neither script sets `-e`, and both end on a command that succeeds
  regardless, so each reports success while its assertions fail - which for
  Chapter 6 is the prerequisite gate of a chapter that pushes an image and
  promotes a digest. Run the file checks from the directory that holds the
  files and read the results rather than the exit code; `labs/ch05/README.md`
  and `labs/ch06/README.md` name which directory is which.

- **Chapter 5's printed workflow fails the chapter's own validation command,
  and its local check blocks report success either way.** Written to
  `.github/workflows/ci.yml` as Step 2 directs,
  `labs/ch05/config/02-ci-workflow.yaml` exits 1 under actionlint with
  shellcheck installed - one `SC2034` for a loop variable the retry never uses,
  four `SC2317` against the `cleanup` trap - while this row's validation entry,
  `actionlint .github/workflows/ci.yml`, passes because the live workflow is
  clean. The result also depends on shellcheck being installed, since actionlint
  skips the shell analysis without it. Separately, `03-run-local-checks.sh` and
  `06-validate-local-layer.sh` set no `-e` and end on a command that succeeds
  regardless, so both exit 0 whatever Ruff and unittest reported; the same holds
  for `02-check-tool-versions.sh` with a tool missing. `labs/ch05/README.md`
  lists these and the split-layout consequences for 04 and 07.

- **Chapter 1's workspace validation checks one of the checklist's seven
  sections.** `labs/ch01/08-validate-workspace.sh` asserts that
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

- `docs/incidents/ch12-controlled-failure.md` - the incident record you
  write in Chapter 12 from `incidents/templates/facts-incident-record.md`,
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
- `ai-native-workspace/` (the book sometimes says `workspace/` for short) -
  built in Chapter 1, in full: the task brief, the AI usage
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
