#!/usr/bin/env bash
# infrastructure lab, Step 3 - Call the module from development - discover two available zones in the approved region
#
# Label: Runnable
#
# Expected result, per the chapter:
#   us-east-1a    us-east-1b
# --- command as printed, verbatim ---
: "${APPROVED_AWS_REGION:?Approved region is not set}"
aws ec2 describe-availability-zones \
  --region "$APPROVED_AWS_REGION" \
  --filters Name=state,Values=available \
  --query 'AvailabilityZones[0:2].ZoneName' \
  --output text
