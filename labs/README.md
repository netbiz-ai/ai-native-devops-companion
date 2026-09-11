# Labs

New to the repository? [docs/getting-started.md](../docs/getting-started.md) walks through setup and every chapter's labs step by step.

Every command the book prints exists here, so a reader never retypes from the page.
Most subject folders are **mirrors**: one numbered `.sh` file per printed bash block, in the order the chapter prints them, with the command body verbatim.
Mirror folders are generated from the printed chapters by the book's `scripts/extract_labs.py` and verified by its `scripts/check_labs.py`; never edit their numbered files directly.
The header of each numbered file carries the chapter's label for the block and, where the chapter states one, its expected result.
A file whose label says it is expected to fail, or Partial, behaves exactly as the printed page does: run it for the failure exercise, or substitute your values first.
Three folders are **harnesses** rather than mirrors, because their chapters invoke the files by name: `incident/` and `capacity/` (Chapter 10) and `assistant/` (Chapter 11).
Five subjects carry executable validators and helpers: `make observability-validate`, `incident-validate`, `capacity-validate`, `assistant-validate` and `capstone-validate` run them.

Each folder is `labs/<subject>/`. The subject is the stable name; the chapter is where that work sits in the book.

| Subject | Chapter | Runs |
|---|---:|---|
| `reference-app` | 2 | needs a tool (python3, curl) |
| `container` | 3 | needs a tool (docker, trivy) |
| `delivery` | 4 | needs a tool (docker, gh, actionlint, jq) |
| `infrastructure` | 5 | needs a tool (terraform) |
| `cluster` | interlude | needs a container runtime (docker, kind, kubectl) |
| `kubernetes` | 6 | needs a cluster (kubectl) |
| `gitops` | 7 | needs a cluster (kubectl, argocd) |
| `observability` | 8 | needs a cluster (kubectl, promtool, otelcol-contrib) |
| `security` | 9 | needs a tool (gh, docker, actionlint) |
| `incident` | 10 | needs a cluster (kubectl) |
| `capacity` | 10 | needs a cluster (kubectl) |
| `assistant` | 11 | offline |
| `agent` | 12 | needs a cluster (kubectl) |
| `capstone` | 13 | needs a cluster (runs every prior subject's evidence checks) |

Fourteen subject folders across twelve chapters and the interlude; Chapter 1 ships no lab on purpose, because its workspace is built outside this clone, and Chapter 10 carries two subjects.
`docs/subject-map.md` is the authority on that mapping and on what each subject starts from and ends with.

The row with no chapter number is `labs/cluster/`, which builds the lab environment the cluster subjects assume rather than a chapter's project.
It is the book's Bridge to the Cluster interlude, which is unnumbered, so it carries no chapter number of its own.
Run it before `labs/kubernetes/`.

"Offline" means plain POSIX tools plus git and python3.
"Needs a tool" means at least one locally installable tool from the chapter's prerequisites.
"Needs a cluster" means a Kubernetes cluster or a cloud account is required for at least one block.

Each numbered file is a separate script, so a `cd` inside one does not carry to the next; where the launch directory matters, the lab's README states it.
Each `labs/<subject>/README.md` maps its files to the book section they came from and names any printed block that is not shipped as a file.
The book's **Configuration** blocks ship too, under `labs/<subject>/config/`, one file per printed block in book order, body verbatim, so a reader copies a document rather than retypes it.
Where a live version of the same file ships elsewhere in this repository, the lab's README table names it; the live file is canonical per `docs/subject-map.md`, and the config copy is what the page prints.
