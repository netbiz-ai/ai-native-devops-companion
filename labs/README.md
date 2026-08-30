# Labs

New to the repository? [docs/getting-started.md](../docs/getting-started.md) walks through setup and every chapter's labs step by step.

Every command the book prints exists here as a file, so a reader never retypes from the page.
Each chapter folder holds one numbered `.sh` file per printed bash block, in the order the chapter prints them, with the command body verbatim.
The header of each file carries the chapter's label for the block, a destructive-command warning where one applies, and the chapter's expected result.
A file with a Partial label keeps the book's placeholders and fails until the reader substitutes them, exactly as the printed page does.
Chapters 10 to 13 and 16 also carry the executable validators and helpers that used to live under `scripts/`; `make ch10-validate`, `ch12-validate`, `ch13-validate` and `ch16-validate` run them.

| Chapter | Folder | Runs |
|---:|---|---|
| 1 | `labs/method/` | offline |
| 2 | `labs/prompt-library/` | offline |
| 3 | `labs/reference-app/` | needs a tool (python3, curl) |
| 4 | `labs/container/` | needs a tool (docker, trivy) |
| 5 | `labs/ci/` | needs a tool (docker, actionlint, ruff, bandit) |
| 6 | `labs/delivery/` | needs a tool (docker, gh, actionlint, jq) |
| 7 | `labs/infrastructure/` | needs a cluster (terraform, aws) |
| 8 | `labs/kubernetes/` | needs a cluster (kubectl) |
| 9 | `labs/gitops/` | needs a cluster (kubectl, argocd) |
| 10 | `labs/observability/` | needs a cluster (kubectl, promtool, otelcol-contrib) |
| 11 | `labs/security/` | needs a tool (gh, docker, actionlint) |
| 12 | `labs/incident/` | needs a cluster (kubectl) |
| 13 | `labs/capacity/` | needs a cluster (kubectl) |
| 14 | `labs/assistant/` | offline |
| 15 | `labs/agent/` | needs a cluster (kubectl) |
| 16 | `labs/capstone/` | needs a cluster (runs every prior chapter's evidence checks) |

"Offline" means plain POSIX tools plus git and python3.
"Needs a tool" means at least one locally installable tool from the chapter's prerequisites.
"Needs a cluster" means a Kubernetes cluster or a cloud account is required for at least one block.

Each numbered file is a separate script, so a `cd` inside one does not carry to the next; where the launch directory matters, the chapter README states it.
Each `labs/<subject>/README.md` maps its files to the book section they came from and names any printed block that is not shipped as a file.
The book's **Configuration** blocks ship too, under `labs/<subject>/config/`, one file per printed block in book order, body verbatim, so a reader copies a document rather than retypes it.
Where a live version of the same file ships elsewhere in this repository, the chapter README's table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.
