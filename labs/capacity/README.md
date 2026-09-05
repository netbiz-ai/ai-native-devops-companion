# capacity lab commands - Reliability, Performance, and Cost Optimization

Second edition: chapter 10. That chapter covers `incident` and `capacity`. First edition and the full mapping: [docs/subject-map.md](../../docs/subject-map.md).

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-capture-baseline.sh | Build It, Step 1 - Establish the accepted baseline | Runnable | Start the lab, run preflight, and capture baseline evidence |
| 02-run-experiments.sh | Build It, Step 3 - Compare two changes within one cost boundary | Runnable | Run candidate A and candidate B with a verified baseline restore between them |
| 03-estimate-cost.sh | Build It, Step 4 - Estimate cost and unit cost | Runnable | Build the dated cost model from the baseline and candidate evidence |
| 04-validate-candidates.sh | Test and Validate | Runnable | Validate both candidates against baseline and confirm the restored final state |
| 05-run-invalid-window.sh | Break It Deliberately | Runnable | Run a short-window candidate so the validator rejects the incomparable evidence |
| 06-cleanup-namespace.sh | Cost and Cleanup | Runnable | Restore the accepted configuration and delete the disposable namespace |

All six blocks are shipped; the chapter has no printed-only bash blocks.

## Migrated scripts

These scripts already lived in this directory before the extraction and are untouched:

- preflight.sh
- run-experiment.sh
- validate.sh

## Referenced configuration

The blocks reference an experiment definition whose printed shape lives in this repository at `optimization/baseline.yaml`; it is not duplicated here.
