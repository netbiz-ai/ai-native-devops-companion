# Instructions for coding agents

This file is for any AI coding agent operating in this repository on a reader's behalf.
The repository is the companion project for *AI-Native DevOps*; the reader works through the book chapter by chapter, and your job is to execute the chapter's labs under their supervision, not to improve the repository.

## Where truth lives

- [docs/subject-map.md](docs/subject-map.md) is the canonical contract: what each chapter starts from, carries in, produces, and the single command that validates it.
  Where anything else disagrees with the map, the map is correct.
- `labs/<subject>/README.md` lists that chapter's script files in printed order, mapped to the book section each came from, with the chapter's label for each file in its Label column.
- [labs/README.md](labs/README.md) says what each chapter needs to run: offline, a named local tool, or a disposable cluster.
- [docs/getting-started.md](docs/getting-started.md) is the reader's walkthrough, including first-time setup and the things the reader creates or supplies themselves.

## How to execute a chapter

1. Read `labs/<subject>/README.md` and the chapter's entry in `docs/subject-map.md` first.
2. Confirm the prerequisites for the chapter's tier are present before running anything; if a tool or cluster is missing, say so and stop rather than improvising a substitute.
3. Enter the chapter's starting state by running the chapter's printed starting command, exactly as printed.
   Chapters 4, 8, 9, and 10 print `make delivery-start`, `make observability-start`, `make security-start`, and `make capacity-start`; chapter 12 prints `make agent-complete` and chapter 13 `make capstone-start`; chapters 3, 5, 6, 7, and 11 print `git switch --detach v1.0.0`; chapters 1 and 2 start outside the clone with a printed `mkdir`.
4. Run the numbered `labs/<subject>/*.sh` files in order, showing the reader each result.
   Each file is one printed bash block, and the lab README's Label column carries the chapter's label for it: skip any file whose label says it is expected to fail or that it needs the reader's values filled in first, and treat those as teaching material rather than steps to force through.
   Copy the chapter's Configuration documents from `labs/<subject>/config/` to the destination the chapter README names.
5. Finish with the chapter's validation entry from `docs/subject-map.md` and report the result.
   Where that entry is a command, the chapter is done when it passes, not before.
   Where it is prose (some chapters validate through their own success and failure runs), re-run the checks it describes and report each outcome; do not treat a single exit code as proof.

## Hard rules

- **Never run a script whose label marks it destructive or disruptive without the reader's explicit confirmation for that specific script.**
  These create or change real things: containers, cluster objects, workflow runs.
- **Pause for confirmation before anything that creates a cluster or could bear cost**: `scripts/lab-environment/create-cluster.sh`, any Terraform `apply`, and anything that talks to a cloud account or a hosted service on the reader's credentials.
- **Do not edit the bodies of `labs/<subject>/*.sh` or `labs/<subject>/config/*`.**
  They are generated from the printed chapters by the book's `scripts/extract_labs.py` and verified verbatim by its `scripts/check_labs.py`, so a hand edit here is drift by definition and the next regeneration would erase it.
  If one appears defective, report it to the reader and to [GitHub Issues](https://github.com/netbiz-ai/ai-native-devops-companion/issues), the errata channel, instead of patching it.
- A script whose label says it needs the reader's values keeps the book's placeholders and fails until the reader substitutes their own.
  Ask the reader for the values; do not invent them.
- `make <subject>-start` exiting 3 with a plain message means that chapter's snapshot tag has not been cut.
  That is by design, not a defect: continue from the clone's current state and tell the reader.
- Some paths the book names are deliberately absent because the reader creates them (`workspace/` and `devops-prompt-library/` outside the clone, and others listed in `docs/subject-map.md` under "What the reader writes, and when").
  Creating them by following the chapter is the lab; do not scaffold them ahead of the reader.
- Nothing here is evidence that a cloud, cluster, alert, or promotion succeeded until the applicable path has actually been run.
  Report only what you observed.

## What the reader supplies

From the kubernetes lab onward the labs need three things that are the reader's, not the repository's: a disposable cluster, a registry holding their image digest, and a Git source their Argo CD can reach.
Templates for all three are in [scripts/lab-environment/](scripts/lab-environment/README.md).
When a cluster chapter appears not to work, check these three before anything else.
