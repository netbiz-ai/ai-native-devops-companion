# Getting started: a reader's guide

This page walks you through the book's projects chapter by chapter: what to install, how to set up, and how this repository is meant to be used alongside the printed page.
It is a walkthrough, not a contract: [chapter-map.md](chapter-map.md) is the authority on what each chapter starts from, produces, and validates, and where anything on this page disagrees with the map, the map is correct.

## What this repository is

Every command the book prints exists here as a runnable file under [`labs/`](../labs/README.md), so you never retype from the page.
The repository also ships the working projects those commands build on: the reference application, its CI/CD workflows, Terraform, Kubernetes and GitOps manifests, observability and security assets, and the capstone.
You read the chapter in the book, run its files from here, and check yourself with the chapter's validation command.

## What you need

The book is designed so you can start small and add tools only when a chapter needs them.
There are three levels, and each includes the ones before it:

1. **Offline** - Python 3.11 to 3.13, Bash 4+, and Git 2.40+.
   Enough for Chapters 1, 2, 3, and 14 in full, and the offline parts of every other chapter.
2. **Local tools** - Docker, plus small per-chapter tools such as `actionlint`, `trivy`, `gh`, `ruff`, and `jq`.
   Needed from Chapter 4 onward; each chapter's first lab script checks for exactly what that chapter uses.
3. **A disposable cluster** - `kubectl` plus a local [kind](https://kind.sigs.k8s.io/) cluster is enough, and is what the book's own reference environment used.
   Needed from Chapter 8 onward.
   A cloud account is only relevant to Chapter 7's optional Terraform apply route; every chapter works without one.

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

Three successful responses mean you are ready for Chapter 1.

## How to work through a chapter

Each chapter is the same loop:

1. **Open the chapter's lab folder.**
   `labs/chNN/README.md` lists the chapter's script files in the order the book prints them, mapped to the book section each came from.
2. **Enter the chapter's starting state.**
   Chapters 10 to 13 print `make chNN-start`, which checks out an immutable, verified snapshot on a `lab/chNN` branch.
   For every other chapter, your starting state is simply where the previous chapter left you - keep working on your clone.
   If you run `make chNN-start` for a chapter without a snapshot, it tells you plainly that the tag has not been cut and exits; that is by design ([release-policy.md](release-policy.md) only permits a tag for a state that has actually been executed), not a defect.
   Just continue from where you are.
3. **Run the numbered scripts in order** as the book discusses them.
   A script whose header says `Partial` keeps the book's placeholders and fails until you substitute your own values - exactly as the printed page would.
   A script whose header says `Destructive` creates or changes real things (containers, cluster objects); read it before you run it.
   The documents the chapter prints as **Configuration** blocks (task briefs, policies, manifests) ship in `labs/chNN/config/` - copy the file to the destination the chapter README names rather than retyping it from the page.
4. **Check yourself** with the chapter's validation command - each card below states it, taken from [chapter-map.md](chapter-map.md).
5. **Keep what you made.**
   Some chapters produce artifacts a later chapter reads; the cards say when.

### Using a coding agent

You can have an AI coding agent drive this loop for you while you supervise: the repository carries agent instructions in [`AGENTS.md`](../AGENTS.md), and [running-labs-with-a-coding-agent.md](running-labs-with-a-coding-agent.md) explains what the agent can do, what stays your responsibility, and how to know a chapter is done.
A prompt to start from, adjusted to the chapter:

> Work through chapter 3 of this repository per AGENTS.md.
> Run the lab scripts in labs/ch03/ in numbered order, show me each command and its result before moving on, and stop for my confirmation before anything labeled Destructive or anything that would create a cluster or cost money.
> Finish with the chapter's validation command from docs/chapter-map.md and report whether it passed.

### Things you create yourself

Some paths the book names are deliberately absent here, because they are your output, not the repository's:

- `ai-native-workspace/` - you build it in Chapter 1 (the blank checklist to copy is `templates/verification-checklist.md`); where the book says `workspace/`, it means this directory.
- `devops-prompt-library/` - you build it in Chapter 2, starting from `mkdir`.
- `docs/security/` policy files - you write them in Chapter 11.
- `docs/incidents/ch12-controlled-failure.md` - you write it in Chapter 12; Chapter 14 reads it.
- The Chapter 13 ADR and experiment record - you write them from the templates in `docs/decisions/` and `docs/optimization/`.

If a chapter names one of these, it is telling you to create it, not reporting a missing file.
The full list is in [chapter-map.md](chapter-map.md) under "What the reader writes, and when".

### Things you supply for the cluster chapters

From Chapter 8 onward the labs need three things that cannot live in this repository because they are yours: a disposable cluster, a registry with your image digest in it, and a Git source you can push to.
[`scripts/lab-environment/`](../scripts/lab-environment/README.md) supplies a copy-paste template for each, and a cluster chapter that appears not to work is usually one of these three left unset.

## The chapters

### Chapter 1 - The AI-Native DevOps Mindset

- **You build:** a verified release-gate script with an observed success and failure path, and a recorded decision.
- **You need:** the offline level.
- **Enter it:** a fresh clone; you create `ai-native-workspace/` yourself here.
- **Labs:** [`labs/ch01/`](../labs/ch01/README.md)
- **Check:** the chapter's own syntax, success, and failure runs.

### Chapter 2 - Prompting for Infrastructure and Operations

- **You build:** a reusable prompt library with deterministic evaluation cases.
- **You need:** the offline level.
- **Enter it:** continue from Chapter 1; you create `devops-prompt-library/` yourself here.
- **Labs:** [`labs/ch02/`](../labs/ch02/README.md)
- **Check:** the chapter's own artifact-presence block.

### Chapter 3 - Build the Book's Reference Application

- **You build:** `reference-app` serving `/`, `/health`, and `/ready` on port 8080.
- **You need:** the offline level, plus `curl`.
- **Enter it:** continue from Chapter 2, and pick an entry route first: the clone already ships the finished app, so you either build your own outside the clone (the chapter as written) or work against the shipped one - [`labs/ch03/README.md`](../labs/ch03/README.md) states both ways.
- **Labs:** [`labs/ch03/`](../labs/ch03/README.md)
- **Check:** `cd reference-app && python3 -m unittest discover -s tests`

### Chapter 4 - Containerize and Optimize with AI

- **You build:** a non-root container image, measured against a single-stage baseline.
- **You need:** Docker and `trivy`.
- **Enter it:** continue from Chapter 3.
- **Labs:** [`labs/ch04/`](../labs/ch04/README.md) - note two scripts there share a shell variable and must run in one session; its README says which.
- **Check:** the chapter's `docker build` and label assertions.

### Chapter 5 - Build an AI-Assisted CI Pipeline

- **You build:** a CI pipeline whose required checks are enforced on `main`.
- **You need:** Docker, `actionlint`, `ruff`, `bandit`.
- **Enter it:** continue from Chapter 4.
- **Labs:** [`labs/ch05/`](../labs/ch05/README.md)
- **Check:** `actionlint .github/workflows/ci.yml`

### Chapter 6 - Design Continuous Delivery with Human and AI Guardrails

- **You build:** a delivery workflow that promotes one immutable digest through human approval, with a tested rollback.
- **You need:** Docker, `gh`, `actionlint`, `jq`.
- **Enter it:** continue from Chapter 5.
- **Labs:** [`labs/ch06/`](../labs/ch06/README.md)
- **Check:** `actionlint .github/workflows/*.yml`
- **Heads-up:** the delivery route runs against *your own* GitHub repository, and needs two repository environments (`staging` and `production`) with deployment branches restricted to `main` and a `production` reviewer who is not the person dispatching the run.
  Details in [chapter-map.md](chapter-map.md) under "Known gaps".

### Chapter 7 - Infrastructure as Code with AI

- **You build:** a reviewed Terraform network foundation, by the no-apply route unless you approve your own sandbox.
- **You need:** `terraform`; an AWS account only for the optional apply route.
- **Enter it:** continue from Chapter 6.
- **Labs:** [`labs/ch07/`](../labs/ch07/README.md)
- **Check:** `terraform validate`
- **Heads-up:** the module interface the chapter prints differs from the module shipped here; writing the printed files gives you a working module of your own, but the printed test does not pass against the shipped one.
  Details in [chapter-map.md](chapter-map.md) under "Known gaps".

### Chapter 8 - Kubernetes with AI as a Reviewer

- **You build:** a hardened workload running in a namespace with its policy behavior observed.
- **You need:** `kubectl` and a disposable cluster - set one up with [`scripts/lab-environment/`](../scripts/lab-environment/README.md), which also covers the registry and image digest this chapter needs.
- **Enter it:** continue from Chapter 7.
- **Labs:** [`labs/ch08/`](../labs/ch08/README.md)
- **Check:** `kubectl kustomize deployment/kubernetes/base`

### Chapter 9 - GitOps and Platform Automation

- **You build:** a GitOps path where staging reconciles automatically and production is promoted deliberately.
- **You need:** the Chapter 8 cluster, `argocd`, and a Git source Argo CD can reach - the third template in [`scripts/lab-environment/`](../scripts/lab-environment/README.md).
- **Enter it:** continue from Chapter 8.
- **Labs:** [`labs/ch09/`](../labs/ch09/README.md)
- **Check:** `kubectl kustomize deployment/gitops/overlays/staging`

### Chapter 10 - Observability with AI

- **You build:** a correlated telemetry signal, an owned alert, and a runbook.
- **You need:** the cluster, `promtool`, `otelcol-contrib`.
- **Enter it:** `make ch10-start` - use the tag, not `main`: the telemetry module you implement in this chapter is deliberately absent from the tag, and starting from `main` hands you the solution.
- **Labs:** [`labs/ch10/`](../labs/ch10/README.md)
- **Check:** `labs/ch10/validate.sh` (also `make ch10-validate`)

### Chapter 11 - Design an AI-Assisted DevSecOps Pipeline

- **You build:** security findings that carry a disposition and an owner.
- **You need:** `gh`, Docker, `actionlint`.
- **Enter it:** `make ch11-start`
- **Labs:** [`labs/ch11/`](../labs/ch11/README.md)
- **Check:** `./scripts/validate-offline.sh`

### Chapter 12 - AI for Incident Response and Troubleshooting

- **You build:** a controlled failure diagnosed and restored under human control.
- **You need:** the cluster.
- **Enter it:** `make ch12-start`
- **Labs:** [`labs/ch12/`](../labs/ch12/README.md)
- **Check:** `labs/ch12/validate.sh` (also `make ch12-validate`)
- **Keep:** the sanitized `docs/incidents/ch12-controlled-failure.md` you write here is Chapter 14's input.

### Chapter 13 - Reliability, Performance, and Cost Optimization

- **You build:** comparable performance candidates and a retain-or-revert decision.
- **You need:** the cluster.
- **Enter it:** `make ch13-start`
- **Labs:** [`labs/ch13/`](../labs/ch13/README.md)
- **Check:** `./scripts/validate-offline.sh` (also `make ch13-validate` for the experiment itself)
- **Heads-up:** three helper scripts the chapter prints are not shipped here; follow those steps with the supplied `preflight.sh`, `run-experiment.sh`, and `validate.sh`.
  Details in [chapter-map.md](chapter-map.md) under "Known gaps".

### Chapter 14 - Build a DevOps Operations Assistant

- **You build:** a read-only assistant that answers with citations and refuses action requests.
- **You need:** the offline level.
- **Enter it:** continue with the `docs/incidents/ch12-controlled-failure.md` you wrote in Chapter 12 - the assistant has no input until Chapter 12 has been run.
- **Labs:** [`labs/ch14/`](../labs/ch14/README.md)
- **Check:** `cd operations-assistant && python3 -m unittest discover -s tests`

### Chapter 15 - Design a Bounded AI Operations Agent

- **You build:** a diagnostics agent with allowlisted reads, one bounded proposal, an audit record, and no mutation path.
- **You need:** the offline level for the fixture route; the cluster only for the optional live route.
- **Enter it:** continue from Chapter 14.
- **Labs:** [`labs/ch15/`](../labs/ch15/README.md)
- **Check:** `cd operations-agent && python3 -m unittest discover -s tests`

### Chapter 16 - Capstone: Design the AI-Native Delivery Platform

- **You build:** the connected acceptance path - capstone criteria CAP-01 to CAP-07, each visible and evidence-linked.
- **You need:** everything the prior chapters used; the verifier checks every prior chapter's evidence.
- **Enter it:** continue from Chapter 15.
- **Labs:** [`labs/ch16/`](../labs/ch16/README.md)
- **Check:** `labs/ch16/capstone-verify.sh` (also `make ch16-validate`)

## When something disagrees

Where the book and this repository disagree about a path or a name, [chapter-map.md](chapter-map.md) is correct and the book is the defect - the map's "Path aliases" section lists the known cases.
Report anything new through [GitHub Issues](https://github.com/netbiz-ai/ai-native-devops-companion/issues), the errata channel named in [release-policy.md](release-policy.md).
