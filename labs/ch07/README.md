# Chapter 7 lab commands - Infrastructure as Code with AI

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
