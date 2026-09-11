# Changelog

## 1.0.1 - 2026-09-11

- Fix a garbled sentence in `deployment/kubernetes/base/kustomization.yaml`: the comment telling you which two fields to replace read "the digest your the container lab build produced". It now reads "the digest the container lab build produced". Comment text only; no manifest field changes, and the all-zero placeholder digest is untouched.

## 1.0.0 - 2026-09-11

First public release, and the release *AI-Native DevOps* is written against.

- The reference service, its container, CI, delivery and rollback workflows, Terraform, Kubernetes and GitOps assets, the observability, security, incident-response and capacity artifacts, the grounded operations assistant, the bounded diagnostics agent, and the capstone evidence contracts.
- `labs/`, holding every command the book prints, extracted verbatim and gated against the manuscript.
- The `<subject>-start` and `<subject>-complete` handoff tags, reachable through the `make` targets the chapters print, and the `lab/<subject>` branches they check out.
- `docs/subject-map.md`, the chapter-by-chapter contract between the book and this repository, including its recorded gaps.
- `AGENTS.md` and the coding-agent guide, for readers working the labs with an agent.
- `scripts/validate-offline.sh`, which proves the stated contract with no network and no cloud account.
