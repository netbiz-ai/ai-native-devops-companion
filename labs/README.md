# Labs

Every command the book prints exists here as a file, so a reader never retypes from the page.
Each chapter folder holds one numbered `.sh` file per printed bash block, in the order the chapter prints them, with the command body verbatim.
The header of each file carries the chapter's label for the block, a destructive-command warning where one applies, and the chapter's expected result.
A file with a Partial label keeps the book's placeholders and fails until the reader substitutes them, exactly as the printed page does.
Chapters 10 to 13 and 16 also carry the executable validators and helpers that used to live under `scripts/`; `make ch10-validate`, `ch12-validate`, `ch13-validate` and `ch16-validate` run them.

| Chapter | Folder | Runs |
|---:|---|---|
| 1 | `labs/ch01/` | offline |
| 2 | `labs/ch02/` | offline |
| 3 | `labs/ch03/` | needs a tool (python3, curl) |
| 4 | `labs/ch04/` | needs a tool (docker, trivy) |
| 5 | `labs/ch05/` | needs a tool (docker, actionlint, ruff, bandit) |
| 6 | `labs/ch06/` | needs a tool (docker, gh, actionlint, jq) |
| 7 | `labs/ch07/` | needs a cluster (terraform, aws) |
| 8 | `labs/ch08/` | needs a cluster (kubectl) |
| 9 | `labs/ch09/` | needs a cluster (kubectl, argocd) |
| 10 | `labs/ch10/` | needs a cluster (kubectl, promtool, otelcol-contrib) |
| 11 | `labs/ch11/` | needs a tool (gh, docker, actionlint) |
| 12 | `labs/ch12/` | needs a cluster (kubectl) |
| 13 | `labs/ch13/` | needs a cluster (kubectl) |
| 14 | `labs/ch14/` | offline |
| 15 | `labs/ch15/` | needs a cluster (kubectl) |
| 16 | `labs/ch16/` | needs a cluster (runs every prior chapter's evidence checks) |

"Offline" means plain POSIX tools plus git and python3.
"Needs a tool" means at least one locally installable tool from the chapter's prerequisites.
"Needs a cluster" means a Kubernetes cluster or a cloud account is required for at least one block.

Each `labs/chNN/README.md` maps its files to the book section they came from and names any printed block that is not shipped as a file.
Configuration the book prints in yaml, hcl, python or dockerfile fences is not duplicated here; it already exists as real files in this repository, and the chapter README says where.
