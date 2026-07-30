# Chapter-to-repository map

| Chapter | Outcome | Primary paths | Acceptance boundary |
|---:|---|---|---|
| 1 | Bound and verify AI-assisted work | `workspace/` | Script success and failure are observed; a human records the decision |
| 2 | Evaluate reusable prompts | `devops-prompt-library/` | Cases are deterministic; model output remains untrusted |
| 3 | Build the reference HTTP service | `reference-app/src`, `reference-app/tests` | Local HTTP contract passes |
| 4 | Containerize and optimize | `reference-app/Dockerfile`, `.dockerignore` | Image is non-root and measured in the same environment |
| 5 | Add CI gates | `.github/workflows/ci.yml` | Required jobs pass for the same revision |
| 6 | Control delivery and rollback | `.github/workflows/delivery.yml`, `rollback.yml` | Immutable digest and human environment approval |
| 7 | Review Terraform | `infrastructure/terraform/` | Static/no-apply route or separately approved sandbox |
| 8 | Harden Kubernetes | `deployment/kubernetes/` | Immutable image, policy behavior, recovery evidence |
| 9 | Promote through GitOps | `deployment/gitops/` | Approved Git revision reconciles to runtime |
| 10 | Build actionable observability | `observability/` | Rules and fixtures link service behavior to an owned response |
| 11 | Add DevSecOps gates | `security/`, CI jobs | Findings carry disposition and owner |
| 12 | Diagnose a controlled incident | `incidents/`, `scripts/ch12/` | Evidence and recovery remain human-controlled |
| 13 | Measure reliability, performance, and cost | `optimization/` | Comparable candidates and retain/revert decision |
| 14 | Build an operations assistant | `operations-assistant/` | Cited, read-only answers and tested refusals |
| 15 | Design a diagnostics agent | `operations-agent/` | Allowlisted reads, bounded proposal, audit record, no mutation |
| 16 | Prove the connected platform | `docs/capstone/`, `scripts/capstone-verify.sh` | CAP-01–CAP-07 remain visible and evidence-linked |

The repository's offline validator is a prerequisite check, not a substitute
for hosted, cloud, cluster, security, incident, cost, or cleanup evidence.
