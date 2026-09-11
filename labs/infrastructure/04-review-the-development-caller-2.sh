#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 3 - Review the Development Caller
#
# Label: Runnable
#
# Expected result, per the chapter:
#   PASS: subnet CIDRs are distinct, non-overlapping, and inside the VPC CIDR
# --- command as printed, verbatim ---
python3 - <<'PY'
from ipaddress import ip_network

vpc = ip_network("10.42.0.0/16")
subnets = [ip_network("10.42.10.0/24"), ip_network("10.42.20.0/24")]

assert all(subnet.subnet_of(vpc) for subnet in subnets)
assert not subnets[0].overlaps(subnets[1])
print("PASS: subnet CIDRs are distinct, non-overlapping, and inside the VPC CIDR")
PY
