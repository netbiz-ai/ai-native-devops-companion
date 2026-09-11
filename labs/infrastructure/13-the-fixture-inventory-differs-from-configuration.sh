#!/usr/bin/env bash
# The infrastructure lab - CH05, Symptom: The Fixture Inventory Differs From Configuration
#
# Label: Runnable
# --- command as printed, verbatim ---
git diff -- infrastructure/terraform/
grep '^  # ' infrastructure/terraform/fixtures/ch07-dev-plan.txt
grep '^Plan:' infrastructure/terraform/fixtures/ch07-dev-plan.txt
