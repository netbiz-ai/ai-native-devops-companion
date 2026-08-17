#!/usr/bin/env bash
# Chapter 14, Step 4 - Test the assistant before a live model - run the fake-client command-line demonstration
#
# Label: Runnable (unlabeled in the chapter)
#
# Expected result, per the chapter:
#   Fact: The runbook says to compare the alert window with deployment events. [checkout-api.md:2]
#   Hypothesis: A recent release may align with the error window. [checkout-api.md:2]
#   Check: inspect_deployment_event target=checkout-api [checkout-api.md:2]
#   Uncertainty: The evidence does not establish a root cause.
#   Human decision required: verify the cited runbook before acting.
#
# The safe answer appears only after Step 1's knowledge doc exists at
# operations-assistant/knowledge/checkout-api.md (copy it from
# labs/ch14/config/01-knowledge-doc-frontmatter.md). Before that, and for any
# unrelated or unsafe question, the demo prints
# "REFUSE: Approved current evidence is insufficient." - by design.
# --- command as printed, verbatim ---
python3 -m src.demo "What should I check after checkout errors began?"
