#!/usr/bin/env bash
# infrastructure lab, Step 5 - Create and review a saved plan - assert the sandbox account, then save and render the plan
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The summary should show one virtual network and two subnets to add, with no changes or deletions.
#   Exact output varies by provider version and account context.
# --- command as printed, verbatim ---
: "${APPROVED_AWS_ACCOUNT_ID:?Approved account is not set}"
: "${APPROVED_AWS_REGION:?Approved region is not set}"
export TF_VAR_region="$APPROVED_AWS_REGION"

actual_account="$(aws sts get-caller-identity --query Account --output text)"
if [ "$actual_account" != "$APPROVED_AWS_ACCOUNT_ID" ]; then
  echo "STOP: active AWS account is not the approved sandbox" >&2
  exit 1
fi
echo "Target account assertion passed for $TF_VAR_region."

terraform plan -out=tfplan
terraform show -no-color tfplan > plan.txt
