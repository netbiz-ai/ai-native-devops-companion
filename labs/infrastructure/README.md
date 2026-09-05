# infrastructure lab commands - Infrastructure as Code with AI

Second edition: chapter 5. First edition and the full mapping: [docs/subject-map.md](../../docs/subject-map.md).

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
| --- | --- | --- | --- |
| 01-setup-workspace.sh | Prerequisites | Runnable | Create the lab branch, record tool versions, and scaffold the directories. |
| 02-discover-zones.sh | Step 3 - Call the module from development | Runnable | Discover two available zones in the approved sandbox region. |
| 03-validate-config.sh | Step 4 - Format, initialize, and validate | Runnable | Run fmt, init, validate, and the Trivy misconfiguration scan. |
| 04-create-plan.sh | Step 5 - Create and review a saved plan | Runnable | Assert the approved sandbox account, then save and render the plan. |
| 05-apply-plan.sh | Test and Validate | Runnable | Apply the exact reviewed plan and check convergence (destructive). |
| 06-test-module.sh | Break It Deliberately | Runnable | Run the module's mock-provider Terraform tests. |
| 07-destroy-lab.sh | Cost and Cleanup | Runnable - destructive | Plan, review, and apply destruction, then verify empty state (destructive). |

All seven bash blocks in the chapter are shipped; none are output-only transcripts.

The chapter's HCL listings (the network module contract and resources, the dev environment root, and the validation test file) exist as real files in this repository under `/infrastructure/terraform/` (`modules/network/` and `environments/dev/`); do not duplicate them here.

## What does not behave as printed here

- **01 scaffolds empty directories at the book's paths.** Its final `mkdir -p` names `infrastructure/modules/network` and `infrastructure/environments/dev`, which are this repository's `infrastructure/terraform/modules/` and `infrastructure/terraform/environments/` under the book's names. `mkdir -p` creates them empty rather than resolving them, and every later `cd` in the chapter then finds the empty copy first.
- **03 reports the chapter's expected success against an empty directory.** After 01, `cd infrastructure/environments/dev` lands in the empty directory, where `terraform init` reports no configuration files and `terraform validate` prints `Success! The configuration is valid.` at exit 0. That is the chapter's expected result exactly, and the infrastructure lab's validation entry in `docs/subject-map.md` is this command, so a correct run and a meaningless one are indistinguishable from the output. Run it from `infrastructure/terraform/environments/dev`, where the configuration is real.
- **06 reports success having run no tests.** The module ships no `.tftest.hcl`, so `terraform test` prints `Success! 0 passed, 0 failed.` The chapter expects `Success! 2 passed, 0 failed.`, and only the count distinguishes them. Write `config/05-network.tftest.hcl` into `infrastructure/terraform/modules/network/` to run the chapter's test - it then fails against the shipped module, which the chapter map's Known gaps entry records and explains.
- **06 depends on 03 having run.** It copies `../../environments/dev/.terraform.lock.hcl`, which exists only after 03's `terraform init`. As printed it also `cd`s to the aliased `infrastructure/modules/network`, which 01 has just created empty.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/subject-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-variables.tf` | Step 1 - Create the module contract | `modules/network/variables.tf` of your module | `infrastructure/terraform/modules/network/variables.tf` (the printed interface diverges from the shipped module; see the chapter map's Known gaps) |
| `config/02-main.tf` | Step 2 - Create only the requested resources | `modules/network/main.tf` of your module | `infrastructure/terraform/modules/network/main.tf` (same divergence note as above) |
| `config/03-outputs.tf` | Step 2 - Create only the requested resources | `modules/network/outputs.tf` of your module | `infrastructure/terraform/modules/network/outputs.tf` (same divergence note as above) |
| `config/04-versions-example.tf` | Data Box - version-sensitive example | the version-sensitive example (Data Box) | - |
| `config/05-network.tftest.hcl` | Break It Deliberately | the module test (Break It Deliberately) | - |
