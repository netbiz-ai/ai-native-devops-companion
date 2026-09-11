#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 5 - Review the Sanitized Plan with AI
#
# Label: Runnable
#
# Expected result, per the chapter:
#     # module.network.aws_subnet.this["app_a"] will be created
#     # module.network.aws_subnet.this["app_b"] will be created
#     # module.network.aws_vpc.this will be created
#   Plan: 3 to add, 0 to change, 0 to destroy.
# --- command as printed, verbatim ---
sed -n '1,220p' infrastructure/terraform/fixtures/README.md
grep '^  # ' infrastructure/terraform/fixtures/ch07-dev-plan.txt
grep '^Plan:' infrastructure/terraform/fixtures/ch07-dev-plan.txt
