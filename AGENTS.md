# Instructions for coding agents

This file is for any AI coding agent operating in this repository on a reader's behalf.
The repository is the companion project for *AI-Native DevOps*; the reader works through the book chapter by chapter, and your job is to execute the chapter's labs under their supervision, not to improve the repository.

## Where truth lives

- [docs/subject-map.md](docs/subject-map.md) is the canonical contract: what each chapter starts from, carries in, produces, and the single command that validates it.
  Where anything else disagrees with the map, the map is correct.
- `labs/<subject>/README.md` lists that chapter's script files in printed order, mapped to the book section each came from, and names any printed block that is not shipped as a file.
- [labs/README.md](labs/README.md) says what each chapter needs to run: offline, a named local tool, or a disposable cluster.
- [docs/getting-started.md](docs/getting-started.md) is the reader's walkthrough, including first-time setup and the things the reader creates or supplies themselves.

## How to execute a chapter

1. Read `labs/<subject>/README.md` and the chapter's entry in `docs/subject-map.md` first.
2. Confirm the prerequisites for the chapter's tier are present before running anything; if a tool or cluster is missing, say so and stop rather than improvising a substitute.
3. Enter the chapter's starting state.
   Chapters 10 to 13 use `make <subject>-start`; every other chapter continues from where the previous chapter left the clone.
4. Run the numbered `labs/<subject>/*.sh` files in order, showing the reader each result.
   Copy the chapter's Configuration documents from `labs/<subject>/config/` to the destination the chapter README names.
   Some numbered files are not commands but the body of a script the chapter has you create; the chapter README's Purpose column says which, and those are written to the destination the chapter names, like a Configuration block, rather than executed where they sit.
5. Finish with the chapter's validation entry from `docs/subject-map.md` and report the result.
   Where that entry is a command, the chapter is done when it passes, not before.
   Where it is prose (some chapters validate through their own success and failure runs), re-run the checks it describes and report each outcome; do not treat a single exit code as proof.

## Hard rules

- **Never run a script whose header label is `Destructive` without the reader's explicit confirmation for that specific script.**
  These create or change real things: containers, cluster objects, workflow runs.
- **Pause for confirmation before anything that creates a cluster or could bear cost**: `scripts/lab-environment/create-cluster.sh`, any Terraform `apply`, and anything that talks to a cloud account or a hosted service on the reader's credentials.
- **Do not edit the bodies of `labs/<subject>/*.sh` or `labs/<subject>/config/*`.**
  They are verbatim copies of what the book prints; that fidelity is the point.
  If one appears defective, report it to the reader and to [GitHub Issues](https://github.com/netbiz-ai/ai-native-devops-companion/issues), the errata channel, instead of patching it.
- A script whose header label is `Partial` keeps the book's placeholders and fails until the reader substitutes their own values.
  Ask the reader for the values; do not invent them.
- `make <subject>-start` exiting 3 with a plain message means that chapter's snapshot tag has not been cut.
  That is by design, not a defect: continue from the clone's current state and tell the reader.
- Some paths the book names are deliberately absent because the reader creates them (`ai-native-workspace/`, `devops-prompt-library/`, and others listed in `docs/subject-map.md` under "What the reader writes, and when").
  Creating them by following the chapter is the lab; do not scaffold them ahead of the reader.
- Nothing here is evidence that a cloud, cluster, alert, or promotion succeeded until the applicable path has actually been run.
  Report only what you observed.

## What the reader supplies

From the kubernetes lab onward the labs need three things that are the reader's, not the repository's: a disposable cluster, a registry holding their image digest, and a Git source their Argo CD can reach.
Templates for all three are in [scripts/lab-environment/](scripts/lab-environment/README.md).
When a cluster chapter appears not to work, check these three before anything else.
