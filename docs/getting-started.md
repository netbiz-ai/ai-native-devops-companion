# Getting started: a reader's guide

This page walks you through the book's projects chapter by chapter: what to install, how to set up, and how this repository is meant to be used alongside the printed page.
It is a walkthrough, not a contract: [subject-map.md](subject-map.md) is the authority on what each chapter starts from, produces, and validates, and where anything on this page disagrees with the map, the map is correct.

## What this repository is

From chapter 2 onward, every bash block the book prints exists here as a runnable file under [`labs/`](../labs/README.md), one numbered file per printed block, so you never retype from the page.
Chapter 1 is the one chapter with no companion material by design: you build its `workspace/` from a printed `mkdir`, outside this clone, and the book alone is sufficient.
The repository also ships the working projects those commands build on: the reference application, its CI/CD workflows, Terraform, Kubernetes and GitOps manifests, observability and security assets, and the capstone.
You read the chapter in the book, run its files from here, and check yourself with the chapter's validation command.

## What you need

The book is designed so you can start small and add tools only when a chapter needs them.
There are three levels, and each includes the ones before it:

1. **Offline** - Python 3.11 to 3.13, Bash 4+, and Git 2.40+.
   Enough for Chapters 1, 2, and 11 in full, chapter 12's fixture route, and the offline parts of every other chapter.
2. **Local tools** - Docker, plus small per-chapter tools such as `actionlint`, `trivy`, `gh`, `ruff`, and `jq`.
   Needed from chapter 3 onward; each chapter's Prerequisites step names exactly what that chapter uses.
3. **A disposable cluster** - `kubectl` plus a local [kind](https://kind.sigs.k8s.io/) cluster is enough, and is what the book's own reference environment used.
   Needed from chapter 6 onward; the book's Bridge to the Cluster interlude builds it with [`labs/cluster/`](../labs/cluster/README.md).
   A cloud account is only relevant to chapter 5's optional Terraform apply route; every chapter works without one.

Exact versions live in [supported-versions.md](supported-versions.md).
Which level each chapter needs is in the table in [`labs/README.md`](../labs/README.md), and repeated on the chapter cards below.

## First-time setup (about 10 minutes)

Check your Python first: `python3 --version` must report 3.11, 3.12, or 3.13.
If it reports something older, create the virtual environment below from a newer interpreter instead (`python3.12 -m venv .venv`).
The setup creates a virtual environment even when the system Python is new enough: Debian and Ubuntu mark the system interpreter as externally managed (PEP 668), so a bare `pip install` outside one fails with `error: externally-managed-environment` before it reads the requirements file.
Stay in the environment for everything below.

```bash
git clone https://github.com/netbiz-ai/ai-native-devops-companion.git
cd ai-native-devops-companion
python3 -m venv .venv
. .venv/bin/activate
pip install -r reference-app/requirements.lock
./scripts/validate-offline.sh
```

The `pip install` step matters: the offline validator imports the reference app's telemetry dependencies and fails without it.
When the validator finishes with `offline_validation=pass`, your machine can run everything the offline level covers - the three test suites, every script's syntax, and the repository's structural checks.

Then prove the reference application runs:

```bash
make run
```

The application binds port 8080, and the book's printed commands, the lab validators, and the `curl` checks below all assume that port.
If something else already holds it, `make run` fails with `OSError: [Errno 98] Address already in use`; free the port by stopping or moving whatever occupies it, and run the reference app on 8080 itself.
The app does accept an `APP_PORT` override, but running the labs anywhere but 8080 means every later printed snippet needs hand-adjusting, so do not use it for the book's exercises.

And in a second terminal:

```bash
curl --fail http://127.0.0.1:8080/
curl --fail http://127.0.0.1:8080/health
curl --fail http://127.0.0.1:8080/ready
```

Three successful responses mean you are ready for chapter 1.

## How to work through a chapter

Each chapter is the same loop:

1. **Open the chapter's lab folder.**
   `labs/<subject>/README.md` lists the chapter's script files in the order the book prints them, mapped to the book section each came from, with the chapter's label for each file.
2. **Enter the chapter's starting state with the chapter's printed starting command.**
   Chapters 4, 8, 9, and 10 print a `make` target (`make delivery-start`, `make observability-start`, `make security-start`, `make capacity-start`), chapter 12 prints `make agent-complete`, and chapter 13 prints `make capstone-start`; each checks out an immutable, verified snapshot on a `lab/<subject>` branch.
   Chapters 3, 5, 6, 7, and 11 have no snapshot tag and pin the release instead: their printed starting command is `git switch --detach v1.0.0`.
   Chapters 1 and 2 start outside the clone with a printed `mkdir`.
3. **Run the numbered scripts in order** as the book discusses them.
   Each file is one printed bash block, and its label in the lab README is the chapter's own label for that block: skip any file whose label says it is expected to fail or that it needs your values filled in first - those behave exactly as the printed page says they do.
   A label that marks a script destructive or disruptive means it creates or changes real things (containers, cluster objects); read it before you run it.
   The documents the chapter prints as **Configuration** blocks ship in `labs/<subject>/config/` - copy the file to the destination the chapter names rather than retyping it from the page.
4. **Check yourself** with the chapter's validation command - each card below states it, taken from [subject-map.md](subject-map.md).
5. **Keep what you made.**
   Some chapters produce artifacts a later chapter reads; the cards say when.

### Using a coding agent

You can have an AI coding agent drive this loop for you while you supervise: the repository carries agent instructions in [`AGENTS.md`](../AGENTS.md), and [running-labs-with-a-coding-agent.md](running-labs-with-a-coding-agent.md) explains what the agent can do, what stays your responsibility, and how to know a chapter is done.
A prompt to start from, adjusted to the chapter:

> Work through chapter 3 of this repository per AGENTS.md.
> Run the lab scripts in labs/container/ in numbered order, show me each command and its result before moving on, skip anything whose label says it is expected to fail or needs my values, and stop for my confirmation before anything destructive or anything that would create a cluster or cost money.
> Finish with the chapter's validation command from docs/subject-map.md and report whether it passed.

### Things you create yourself

Some paths the book names are deliberately absent here, because they are your output, not the repository's:

- `workspace/`, holding `devops-prompt-library/` and the single running `platform-log.md` - you build it in chapter 1, outside this clone.
- `reference-app/` as your own build - you create it in chapter 2, outside this clone, beside `workspace/`; the app shipped here is your solution key.
- `security/gate-policy.md` and the security ruleset - you write them in chapter 9.
- `reference-app/src/telemetry.py` - you implement it in chapter 8, which is why it is absent from `observability-start`.
- `operations-assistant/knowledge/checkout-api.md` - the approved knowledge document you write in chapter 11's Step 1.

If a chapter names one of these, it is telling you to create it, not reporting a missing file.
The full list is in [subject-map.md](subject-map.md) under "What the reader writes, and when".

### Things you supply for the cluster chapters

From chapter 6 onward the labs need three things that cannot live in this repository because they are yours: a disposable cluster, a registry with your image digest in it, and a Git source you can push to.
The interlude's [`labs/cluster/`](../labs/cluster/README.md) builds the cluster, [`scripts/lab-environment/`](../scripts/lab-environment/README.md) supplies a copy-paste template for each of the three, and a cluster chapter that appears not to work is usually one of these left unset.

## The chapters

### Chapter 1 - The AI-Native Method

- **You build:** a bounded AI workspace with a reusable prompt library and two deterministic evaluation cases.
- **You need:** the offline level.
- **Enter it:** the chapter's printed `mkdir workspace`, outside this clone; no companion material is used.
- **Check:** from `devops-prompt-library/`, `python3 tools/evaluate.py` reports two passing cases.

### Chapter 2 - Build the Book's Reference Application

- **You build:** `reference-app` serving `/`, `/health`, and `/ready` on port 8080.
- **You need:** the offline level, plus `curl`.
- **Enter it:** the chapter's printed `mkdir reference-app`, outside this clone; the app shipped here is your solution key, and [`labs/reference-app/`](../labs/reference-app/README.md) holds the printed blocks.
- **Check:** `python3 -m unittest discover -s tests` from your app directory - `Ran 11 tests` and `OK`.

### Chapter 3 - Containerize and Optimize with AI

- **You build:** a non-root multi-stage container image, measured against a single-stage baseline.
- **You need:** Docker with Buildx, `trivy`, and `curl`.
- **Enter it:** `git switch --detach v1.0.0`, then `cd reference-app`.
- **Labs:** [`labs/container/`](../labs/container/README.md)
- **Check:** the chapter's `docker build` and label assertions.

### Chapter 4 - CI and Delivery with Human and AI Guardrails

- **You build:** a CI gate and a delivery workflow that promotes one immutable digest through human approval, with a tested rollback.
- **You need:** Docker, `gh`, `actionlint`, `jq`, `ripgrep`, a fork of this repository you own, and a second account as the production reviewer.
- **Enter it:** `make delivery-start`, from a clean clone of your fork.
- **Labs:** [`labs/delivery/`](../labs/delivery/README.md)
- **Check:** the chapter's Static Validation step.
- **Heads-up:** the hosted route needs two repository environments (`staging` and `production`) with deployment branches restricted to `main` and a `production` reviewer who is not the person dispatching the run.
  Details in [subject-map.md](subject-map.md) under "Known gaps".

### Chapter 5 - Defend an Infrastructure as Code Plan with AI

- **You build:** a defended Terraform network plan, by the no-apply route unless you approve your own sandbox.
- **You need:** `terraform`; an AWS account only for the optional apply route.
- **Enter it:** `git switch --detach v1.0.0`.
- **Labs:** [`labs/infrastructure/`](../labs/infrastructure/README.md)
- **Check:** `terraform validate`

### The interlude - Bridge to the Cluster

- **You build:** the disposable kind cluster, local registry, and enforcing network setup the cluster chapters assume.
- **You need:** Docker, `kind`, `kubectl`.
- **Enter it:** run it between chapters 5 and 6, from the repository root.
- **Labs:** [`labs/cluster/`](../labs/cluster/README.md)
- **Check:** the interlude's own verification blocks, including the denial probe.

### Chapter 6 - Prove a Kubernetes Workload's Allowed and Denied Paths

- **You build:** a hardened workload in `reference-dev` with its allowed and denied paths proved.
- **You need:** `kubectl` and the interlude's disposable cluster, plus the registry and image digest from [`scripts/lab-environment/`](../scripts/lab-environment/README.md).
- **Enter it:** `git switch --detach v1.0.0`.
- **Labs:** [`labs/kubernetes/`](../labs/kubernetes/README.md)
- **Check:** `kubectl kustomize deployment/kubernetes/base`

### Chapter 7 - Promote a Verified Digest Through GitOps

- **You build:** a GitOps path where staging reconciles automatically and production is promoted deliberately.
- **You need:** the cluster, `argocd`, and a Git source Argo CD can reach - the third template in [`scripts/lab-environment/`](../scripts/lab-environment/README.md).
- **Enter it:** `git switch --detach v1.0.0`.
- **Labs:** [`labs/gitops/`](../labs/gitops/README.md)
- **Check:** `kubectl kustomize deployment/gitops/overlays/staging`

### Chapter 8 - Observability with AI

- **You build:** a correlated telemetry signal, an owned alert, and a runbook.
- **You need:** the cluster, `promtool`, `otelcol-contrib`.
- **Enter it:** `make observability-start` - use the tag, not `main`: the telemetry module you implement in this chapter is deliberately absent from the tag, and starting from `main` hands you the solution.
- **Labs:** [`labs/observability/`](../labs/observability/README.md)
- **Check:** the chapter's `./labs/observability/validate.sh`

### Chapter 9 - Design an AI-Assisted DevSecOps Pipeline

- **You build:** security findings that carry a disposition and an owner, behind exact required check names.
- **You need:** `gh`, Docker, `actionlint`.
- **Enter it:** `make security-start`
- **Labs:** [`labs/security/`](../labs/security/README.md)
- **Check:** `./scripts/validate-offline.sh`

### Chapter 10 - Incident Response, Reliability, and Cost

- **You build:** a controlled failure diagnosed and restored under human control, then a measured retain-or-revert capacity decision.
- **You need:** the cluster.
- **Enter it:** `make capacity-start` - the `capacity-start` snapshot deliberately carries the completed incident starting assets, so one checkout serves the whole chapter.
- **Labs:** [`labs/incident/`](../labs/incident/README.md), plus the [`labs/capacity/`](../labs/capacity/README.md) helper scripts the chapter calls by name.
- **Check:** the chapter's `labs/incident/validate.sh`

### Chapter 11 - Build a DevOps Operations Assistant

- **You build:** a read-only assistant that answers with citations and refuses action requests, over a knowledge document you approve.
- **You need:** the offline level.
- **Enter it:** `git switch --detach v1.0.0`; you write the knowledge document in the chapter's Step 1.
- **Labs:** [`labs/assistant/`](../labs/assistant/README.md)
- **Check:** `labs/assistant/validate.sh`; it checks your knowledge doc and the demo behavior, so it fails on an untouched clone by design.

### Chapter 12 - Design a Bounded AI Operations Agent

- **You build:** a review of a diagnostics agent with allowlisted reads, one bounded proposal, an audit record, and no mutation path.
- **You need:** the offline level for the fixture route; the cluster only for the optional live route.
- **Enter it:** `make agent-complete` - the chapter reviews the completed agent rather than building it from scratch.
- **Labs:** [`labs/agent/`](../labs/agent/README.md)
- **Check:** `cd operations-agent && python3 -m unittest discover -s tests`

### Chapter 13 - Capstone: The AI-Native Delivery Platform

- **You build:** the connected acceptance path - capstone criteria CAP-01 to CAP-07, each visible and evidence-linked to your own run.
- **You need:** everything the prior chapters used; the verifier checks every prior chapter's evidence.
- **Enter it:** `make capstone-start`
- **Labs:** [`labs/capstone/`](../labs/capstone/README.md)
- **Check:** the chapter's `labs/capstone/capstone-verify.sh` runs.

## When something disagrees

Where the book and this repository disagree about a path or a name, [subject-map.md](subject-map.md) is correct and the book is the defect.
Report anything new through [GitHub Issues](https://github.com/netbiz-ai/ai-native-devops-companion/issues), the errata channel named in [release-policy.md](release-policy.md).
