# Reusing these projects in your own work

This repository is cumulative and designed to be raided, not only followed.
Each chapter of *AI-Native DevOps* starts from the state the previous one ended in, and every chapter's own validation command is what proves that state is real.
This page is for readers who want to take pieces of that work into their own delivery pipeline rather than work the book straight through.

`docs/chapter-map.md` remains the canonical contract between the book and this repository, and it is authoritative over the printed page wherever the two disagree.
`labs/chNN/` holds every printed command as a numbered runnable file, `make chNN-start` puts the tree at a chapter's starting state, `make chNN-complete` at its finished state, and the difference between the two is that chapter's work.

## Three tiers of prerequisites

Nothing is needed before the chapter that uses it.

- Chapters 1 to 3, 14 and 15: Python 3.11 or newer, Bash, Git.
- Chapters 4 to 6: add Docker and a GitHub repository of your own.
- Chapters 8 to 13: add a disposable cluster, for which a local `kind` cluster is enough.

Three things cannot ship here because they are yours, and a lab that appears broken from Chapter 8 onward is usually one of them left unset: a disposable cluster in your `kubectl` context, a registry the cluster can pull from with the digest set in `deployment/kubernetes/base/kustomization.yaml`, and a Git source Argo CD can reach.
The published image digest is an all-zero placeholder on purpose, so an unreplaced value fails at admission instead of deploying something you never reviewed.

## What to lift directly into your own work

| Take this | From | Use it for |
|---|---|---|
| The AI Output Verification Checklist | Ch 1 | A pull-request template or definition-of-done item for any AI-assisted change |
| `devops-prompt-library/` structure with evaluation cases | Ch 2 | Team-owned prompts under version control, with regression cases you can re-run when you change model or vendor |
| Multi-stage `Dockerfile` and `.dockerignore` plus the CLEAR gate | Ch 4 | A hardening checklist for your existing images: non-root numeric UID, controlled context, scanned, labeled |
| `ci.yml` with least-privilege permissions and pinned actions | Ch 5 | A baseline to diff your current workflows against, especially default token permissions and unpinned third-party actions |
| `delivery.yml` and `rollback.yml`, the PAUSE record | Ch 6 | Digest-based promotion and a rehearsed rollback, replacing tag-based deploys |
| Terraform module layout, input guards, and the SAFE review | Ch 7 | A plan-review ritual before apply, and a no-cost way to train reviewers using plan fixtures |
| `deployment/kubernetes/base`, probes, NetworkPolicy, PRISM | Ch 8 | A workload hardening baseline, plus the habit of testing that a policy actually denies |
| Argo CD `AppProject` bounds and overlay promotion flow | Ch 9 | Restricting what your GitOps controller may touch, and promoting an artifact rather than rebuilding it |
| Telemetry contract, alert with a traffic guard, runbook shape | Ch 10 | Cutting alert noise, and making every alert an owned request for action |
| Five-scanner PR gate and the Security Finding Review | Ch 11 | Turning scanner output into owned dispositions with expiry dates instead of a dashboard nobody reads |
| FACTS incident record and post-incident review templates | Ch 12 | Incident hygiene that keeps facts separate from inference, and a sanitized evidence trail |
| Measured Trade-off Loop and the scorecard | Ch 13 | Any performance or cost change, so the claim rests on comparable arms rather than an anecdote |
| `operations-assistant/` | Ch 14 | A grounded internal Q and A tool over your own runbooks, with refusal and injection tests already written (6 tests pass from a clean clone) |
| `operations-agent/` | Ch 15 | A template for any agent that touches production: typed tools, allowlist, least-privilege identity, audit log, propose-not-execute |
| `capstone-verify.sh` and the CAP criteria | Ch 16 | One command that proves your platform's claims, runnable in CI or before a release review |

## Four practical adoption paths

**1. Run the book straight through as a training track.**
Work chapters in order, always finishing with the chapter's confirmation command before starting the next.
This is the right path for onboarding an engineer or a team into AI-assisted delivery, and it takes you from an empty directory to a verified platform without ever needing a paid cloud account, since Chapter 7's no-apply route and a local kind cluster cover the rest.
A coding agent can drive the labs for you: `AGENTS.md` at the repository root and `docs/running-labs-with-a-coding-agent.md` set that up, and destructive or cost-bearing steps still stop for your confirmation.

**2. Use it as a gap audit against your existing pipeline.**
Do not rebuild anything.
Score your current delivery path against the book's named gates, then fix only the failures: the AI Output Verification Checklist (Ch 1), BOUNDARIES (Ch 2), the Baseline Fitness Check (Ch 3), CLEAR (Ch 4), TRACE (Ch 5), PAUSE (Ch 6), SAFE (Ch 7), PRISM (Ch 8), the GitOps Change Review (Ch 9), the FACTS Incident Loop (Ch 12), the Measured Trade-off Loop (Ch 13), and the Capstone Evidence Review (Ch 16).
The gates are deliberately short and evidence-based, so this is a half-day exercise that usually surfaces unpinned actions, a token with write permissions by default, promotion by mutable tag, alerts with no owner, and scanner findings with no disposition.

**3. Adopt the AI working method without adopting the stack.**
The Draft-Test-Decide Loop, the BOUNDARIES prompt pattern, the Hallucination Check, and the Break It Deliberately habit are tool-independent and language-independent.
Applied to ordinary application development, they mean: let the model draft, have deterministic tools test the draft, record the accept or reject decision with its reason, and deliberately break what the model built to find out what it assumed.
The prompt library with evaluation cases is the piece that pays back fastest, because it turns one-off chat sessions into an asset the team can review and re-run.

**4. Build your operational AI on Chapters 14 and 15 rather than from scratch.**
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
