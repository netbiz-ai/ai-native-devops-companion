# Labs

New to the repository? [docs/getting-started.md](../docs/getting-started.md) walks through setup and every chapter's labs step by step.

Every command the book prints exists here as a file, so a reader never retypes from the page.
Each subject folder holds one numbered `.sh` file per printed bash block, in the order the chapter prints them, with the command body verbatim.
The header of each file carries the chapter's label for the block, a destructive-command warning where one applies, and the chapter's expected result.
A file with a Partial label keeps the book's placeholders and fails until the reader substitutes them, exactly as the printed page does.
Five subjects also carry the executable validators and helpers that used to live under `scripts/`: `make observability-validate`, `incident-validate`, `capacity-validate`, `assistant-validate` and `capstone-validate` run them.

Each folder is `labs/<subject>/`. The subject is the stable name; chapter numbers differ between editions, so both are given.

| Subject | Second edition | First edition | Runs |
|---|---:|---:|---|
| `method` | 1 | 1 | offline |
| `prompt-library` | 1 | 2 | offline |
| `reference-app` | 2 | 3 | needs a tool (python3, curl) |
| `container` | 3 | 4 | needs a tool (docker, trivy) |
| `ci` | 4 | 5 | needs a tool (docker, actionlint, ruff, bandit) |
| `delivery` | 4 | 6 | needs a tool (docker, gh, actionlint, jq) |
| `infrastructure` | 5 | 7 | needs a cluster (terraform, aws) |
| `cluster` | interlude | interlude | needs a container runtime (docker, kind, kubectl) |
| `kubernetes` | 6 | 8 | needs a cluster (kubectl) |
| `gitops` | 7 | 9 | needs a cluster (kubectl, argocd) |
| `observability` | 8 | 10 | needs a cluster (kubectl, promtool, otelcol-contrib) |
| `security` | 9 | 11 | needs a tool (gh, docker, actionlint) |
| `incident` | 10 | 12 | needs a cluster (kubectl) |
| `capacity` | 10 | 13 | needs a cluster (kubectl) |
| `assistant` | 11 | 14 | offline |
| `agent` | 12 | 15 | needs a cluster (kubectl) |
| `capstone` | 13 | 16 | needs a cluster (runs every prior subject's evidence checks) |

The second edition covers seventeen subjects in thirteen chapters, so three of its chapters carry two subjects each. `docs/subject-map.md` is the authority on that mapping and on what each subject starts from and ends with.

The row with no chapter number is `labs/cluster/`, which builds the lab environment the cluster subjects assume rather than a chapter's project.
It is the second edition's Bridge to the Cluster interlude, and it is the executable form of the first edition's Bridge to the Cluster section in the infrastructure lab, so it carries no chapter number of its own.
Run it before `labs/kubernetes/` in either edition.

"Offline" means plain POSIX tools plus git and python3.
"Needs a tool" means at least one locally installable tool from the chapter's prerequisites.
"Needs a cluster" means a Kubernetes cluster or a cloud account is required for at least one block.

Each numbered file is a separate script, so a `cd` inside one does not carry to the next; where the launch directory matters, the lab's README states it.
Each `labs/<subject>/README.md` maps its files to the book section they came from and names any printed block that is not shipped as a file.
The book's **Configuration** blocks ship too, under `labs/<subject>/config/`, one file per printed block in book order, body verbatim, so a reader copies a document rather than retypes it.
Where a live version of the same file ships elsewhere in this repository, the lab's README table names it; the live file is canonical per `docs/subject-map.md`, and the config copy is what the page prints.
