# Reusing these projects in your own work

This repository is cumulative and designed to be raided, not only followed.
Each chapter of *AI-Native DevOps* builds on the state the previous one produced, and every chapter's own validation check is what proves that state is real.
This page is for readers who want to take pieces of that work into their own delivery pipeline rather than work the book straight through.

`docs/subject-map.md` remains the canonical contract between the book and this repository, and it is authoritative over the printed page wherever the two disagree.
`labs/<subject>/` holds every printed command as a numbered runnable file, and where a chapter has a handoff tag, `make <subject>-start` puts the tree at its starting state and `make <subject>-complete` at its finished state; the difference between the two is that chapter's work.

## Three tiers of prerequisites

Nothing is needed before the chapter that uses it.

- Chapters 1, 2, and 11, plus chapter 12's fixture route: Python 3.11 or newer, Bash, Git.
- Chapters 3 to 5: add Docker, a GitHub repository of your own, and Terraform.
- The interlude and chapters 6 to 10, plus the capstone: add a disposable cluster, for which a local `kind` cluster is enough.

Three things cannot ship here because they are yours, and a lab that appears broken from chapter 6 onward is usually one of them left unset: a disposable cluster in your `kubectl` context, a registry the cluster can pull from with the digest set in `deployment/kubernetes/base/kustomization.yaml`, and a Git source Argo CD can reach.
The published image digest is an all-zero placeholder on purpose, so an unreplaced value fails at admission instead of deploying something you never reviewed.

## What to lift directly into your own work

| Take this | From | Use it for |
|---|---|---|
| `devops-prompt-library/` structure with deterministic evaluation cases | Ch 1 | Team-owned prompts under version control, with regression cases you can re-run when you change model or vendor |
| The reference app's contract-first test suite | Ch 2 | A template for pinning observable behavior - routes, status codes, configuration failure - before any implementation is trusted |
| Multi-stage `Dockerfile` and `.dockerignore` hardening | Ch 3 | A checklist for your existing images: non-root numeric UID, controlled context, recorded base identity, scanned, labeled |
| `ci.yml` with least-privilege permissions and pinned actions | Ch 4 | A baseline to diff your current workflows against, especially default token permissions and unpinned third-party actions |
| `delivery.yml` and `rollback.yml` | Ch 4 | Digest-based promotion behind an independent human approval, and a rehearsed rollback, replacing tag-based deploys |
| Terraform module layout, input guards, and the plan-review ritual | Ch 5 | A defended-plan review before any apply, and a no-cost way to train reviewers on plan fixtures |
| `deployment/kubernetes/base`: probes, NetworkPolicy, ownership placeholders | Ch 6 | A workload hardening baseline, plus the habit of proving that a policy actually denies |
| Argo CD `AppProject` bounds and overlay promotion flow | Ch 7 | Restricting what your GitOps controller may touch, and promoting an artifact rather than rebuilding it |
| Telemetry contract, alert with a traffic guard, runbook shape | Ch 8 | Cutting alert noise, and making every alert an owned request for action |
| Five-scanner PR gate and `security/finding-disposition-template.yaml` | Ch 9 | Turning scanner output into owned dispositions with expiry dates instead of a dashboard nobody reads |
| `incidents/templates/facts-incident-record.md` and `post-incident-review.md` | Ch 10 | Incident hygiene that keeps facts separate from inference, and a sanitized evidence trail |
| `optimization/scorecard-template.md` and the measured-comparison flow | Ch 10 | Any performance or cost change, so the claim rests on comparable arms rather than an anecdote |
| `operations-assistant/` | Ch 11 | A grounded internal Q and A tool over your own runbooks, with refusal and injection tests already written (6 tests pass from a clean clone) |
| `operations-agent/` | Ch 12 | A template for any agent that touches production: typed tools, allowlist, least-privilege identity, audit log, propose-not-execute |
| The capstone verifier and the CAP criteria | Ch 13 | One command that proves your platform's claims against your own run's evidence, runnable in CI or before a release review |

## Four practical adoption paths

**1. Run the book straight through as a training track.**
Work chapters in order, always finishing with the chapter's validation check before starting the next.
This is the right path for onboarding an engineer or a team into AI-assisted delivery, and it takes you from an empty directory to a verified platform without ever needing a paid cloud account, since chapter 5's no-apply route and a local kind cluster cover the rest.
A coding agent can drive the labs for you: `AGENTS.md` at the repository root and `docs/running-labs-with-a-coding-agent.md` set that up, and destructive or cost-bearing steps still stop for your confirmation.

**2. Use it as a gap audit against your existing pipeline.**
Do not rebuild anything.
Score your current delivery path against the book's checks, then fix only the failures: prompts with regression cases (Ch 1), a contract-first test suite (Ch 2), image identity and non-root runtime (Ch 3), pinned actions and independent production approval (Ch 4), defended infrastructure plans (Ch 5), policies proven by denial (Ch 6), promotion by digest through Git (Ch 7), owned alerts (Ch 8), finding dispositions with expiry (Ch 9), fact-separated incident records and comparable capacity arms (Ch 10), and evidence-linked acceptance criteria (Ch 13).
The checks are deliberately short and evidence-based, so this is a half-day exercise that usually surfaces unpinned actions, a token with write permissions by default, promotion by mutable tag, alerts with no owner, and scanner findings with no disposition.

**3. Adopt the AI working method without adopting the stack.**
The bounded-prompt pattern, the Hallucination Check, and the Break It Deliberately habit are tool-independent and language-independent.
Applied to ordinary application development, they mean: let the model draft, have deterministic tools test the draft, record the accept or reject decision with its reason, and deliberately break what the model built to find out what it assumed.
The prompt library with evaluation cases is the piece that pays back fastest, because it turns one-off chat sessions into an asset the team can review and re-run.

**4. Build your operational AI on chapters 11 and 12 rather than from scratch.**
The assistant and the agent are the two most directly reusable codebases in the repository.
The assistant gives you retrieval, citation requirements, uncertainty labeling, refusal behavior, and injection tests.
The agent gives you the safety architecture that most internal AI tooling skips: typed and allowlisted tools, target binding, a Kubernetes Role that is genuinely least-privilege and tested to be refused where it should be, an ordered audit record, and an approval schema that binds to one exact action rather than to a session.
Swap the model client, keep the boundary.

## The habits that transfer even if you use none of the code

- Promote artifacts by immutable digest, and make one identity traceable from source through registry, desired state, runtime, telemetry, and incident record.
- Make a control prove itself with a negative test, since a policy that is never observed denying anything is not a control.
- Separate evidence from inference in writing, and label estimates, opinions, and predictions as such.
- Give every alert, finding, and exception a named owner and an expiry.
- Rehearse teardown once before you depend on it, because the resources that survive a careless cleanup are usually the expensive ones.
- State what your result does not prove, in the same place where you state what it does.
