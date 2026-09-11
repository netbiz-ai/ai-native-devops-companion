# Supported-version matrix

Verified for the initial offline release:

| Tool | Supported baseline | Used for |
|---|---|---|
| Python | 3.11–3.13 | App, assistant, agent, tests, validators |
| Bash | 4+ | Validation and chapter scripts |
| Git | 2.40+ | Versioned evidence and promotion workflow |

Version-sensitive optional paths must be reconfirmed before use:

| Tool | Suggested minimum | Confirmation command |
|---|---:|---|
| Docker Engine | 25 | `docker version` |
| Terraform | 1.7 | `terraform version` |
| kubectl | 1.29 | `kubectl version --client` |
| Kustomize | 5 | `kustomize version` |
| Argo CD | 2.10 | `argocd version --client` |
| Prometheus promtool | 2.50 | `promtool --version` |
| Trivy | 0.50 | `trivy --version` |

These are compatibility baselines, not promises about the newest release.
Pin CI actions and container images to reviewed immutable identities before a
live acceptance run.
