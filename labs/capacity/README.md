# capacity helpers - Reliability, Performance, and Cost Optimization

Chapter 10 of the book covers the `incident` and `capacity` subjects. The full subject map is [docs/subject-map.md](../../docs/subject-map.md).

This directory holds the capacity harness the chapter invokes by file name.
Unlike the mirror labs, these are not copies of printed blocks: the chapter's printed commands call these helpers directly, with the flags each `--help` documents.
The chapter's printed bash blocks themselves ship in [`labs/incident/`](../incident/README.md)'s subject family and in the chapter text.

| File | Called from | Purpose |
|---|---|---|
| preflight.sh | Prerequisites and Step 1 | Confirm the namespace, workload, and tooling before any experiment. |
| capture-baseline.sh | Step 1 | Record the accepted baseline the candidates are compared against. |
| run-experiment.sh | Step 3 | Run one candidate within the experiment definition's stop conditions. |
| estimate-cost.sh | Step 4 | Build the dated cost model from baseline and candidate evidence. |
| validate.sh | Test and Validate | Validate candidate evidence against the baseline; behind `make capacity-validate`. |
| restore.sh | Steps 3 and 5, and Cost and Cleanup | Restore the accepted configuration between and after experiments. |
| args.sh | (internal) | Shared flag parsing for the helpers above. |

The experiment definition and interpretation template live under [`optimization/`](../../optimization/): `baseline.yaml` and `scorecard-template.md`.

A compatibility note the book prints: these helpers still expose `CH12_` and `CH13_` environment variable names from an earlier chapter layout.
The printed invocations pass explicit flags, so the legacy names are visible only in `--help` output and defaults.
