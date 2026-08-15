# AI-Native DevOps companion project

This repository is the cumulative project used by *AI-Native DevOps: A Hands-On
Guide to Becoming an AI-Native DevOps Engineer* by Elvis Tafoh-Ngunjoh.

`docs/chapter-map.md` is the canonical contract between the book and this
repository: what each chapter starts from, carries in, produces, and how to
validate it. Where the book and that map disagree, the map is correct.
`docs/release-policy.md` states how this repository is versioned, supported,
and archived.

It connects one small reference service to the book's evidence-driven delivery
path: bounded prompting, tests, containers, CI/CD, Terraform, Kubernetes,
GitOps, observability, DevSecOps, incident response, optimization, a read-only
operations assistant, a proposal-only diagnostics agent, and a capstone
acceptance manifest.

## Safety and evidence labels

- **Runnable offline:** works with Python 3.11+ and no cloud credentials.
- **Runnable with prerequisites:** requires the named local tool.
- **Fixture:** deterministic teaching input, not observed production output.
- **Design-only:** requires an explicitly approved disposable environment.

Nothing in this repository is evidence that a cloud, cluster, alert, or
promotion succeeded until you run the applicable path and retain sanitized
results.

## Quick start

```bash
git clone https://github.com/netbiz-ai/ai-native-devops-companion.git
cd ai-native-devops-companion
./scripts/validate-offline.sh
python3 reference-app/src/app.py
```

In another terminal:

```bash
curl --fail http://127.0.0.1:8080/
curl --fail http://127.0.0.1:8080/health
curl --fail http://127.0.0.1:8080/ready
```

The offline validator runs the application, assistant, and agent tests;
compiles Python; validates JSON without third-party Python packages; checks
YAML indentation hygiene and required files; and scans tracked source for
obvious secret patterns.

## Repository map

| Book area | Repository path | Baseline |
|---|---|---|
| Chapters 1–2: bounded AI work and prompt evaluation | You create `workspace/` and `devops-prompt-library/`; this repository supplies neither | Offline |
| Chapters 3–6: application, container, CI, delivery | `reference-app/`, `.github/workflows/` | Offline plus Docker/GitHub |
| Chapter 7: Terraform network module | `infrastructure/terraform/` | Static; apply is opt-in |
| Chapters 8–9: Kubernetes and GitOps | `deployment/` | Static; cluster is opt-in |
| Chapters 10–13: telemetry, security, incidents, optimization | `observability/`, `security/`, `incidents/`, `optimization/` | Fixtures and templates |
| Chapter 14: cited operations assistant | `operations-assistant/` | Offline |
| Chapter 15: read-only diagnostics agent | `operations-agent/` | Offline fixture; live cluster opt-in |
| Chapter 16: connected acceptance path | `docs/capstone/`, `labs/ch16/capstone-verify.sh` | Offline design check; live result requires evidence |

See [docs/chapter-map.md](docs/chapter-map.md) for exact chapter handoffs.

## Supported baseline

- Python 3.11 or newer
- Bash 4 or newer for repository scripts
- Docker for the container exercises
- Terraform, kubectl, Kustomize, Argo CD, Prometheus tooling, and a disposable
  cloud/cluster only for their respective optional paths

Use the version matrix in `docs/supported-versions.md` and confirm current
tool behavior before running version-sensitive commands.

## What this initial release proves

The local release proves only that:

- the reference app contract passes direct and real-HTTP tests;
- the local retriever cites approved runbooks and refuses action requests;
- the diagnostics agent enforces tool, namespace, and proposal boundaries
  against deterministic fixtures;
- repository configuration is structurally parseable; and
- the offline acceptance design is internally linked.

It does not prove cloud deployment, hosted CI enforcement, live GitOps
reconciliation, production readiness, or cleanup of resources you create.
