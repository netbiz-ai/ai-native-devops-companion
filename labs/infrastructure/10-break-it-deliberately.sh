#!/usr/bin/env bash
# The infrastructure lab - CH05, Break It Deliberately
#
# Label: Runnable
#
# Expected result, per the chapter:
#   REJECT: coherent replacement action and destroy total detected
# --- command as printed, verbatim ---
awk '
  !header && /module.network.aws_subnet.this\["app_a"\] will be created/ {
    sub(/will be created/, "must be replaced")
    header = 1
  }
  header && !symbol && /^  \+ resource "aws_subnet"/ {
    sub(/^  \+/, "-/+")
    symbol = 1
  }
  /^Plan:/ {
    $0 = "Plan: 3 to add, 0 to change, 1 to destroy."
  }
  { print }
' infrastructure/terraform/fixtures/ch07-dev-plan.txt |
awk '
  /module.network.aws_subnet.this\["app_a"\] must be replaced/ { header = 1 }
  /^-\/\+ resource "aws_subnet"/ { symbol = 1 }
  /^Plan: 3 to add, 0 to change, 1 to destroy\.$/ { summary = 1 }
  END {
    if (header && symbol && summary) {
      print "REJECT: coherent replacement action and destroy total detected"
      exit 1
    }
    print "REJECT: body-summary evidence is incomplete or inconsistent"
    exit 1
  }'
