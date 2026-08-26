#!/usr/bin/env bash
# Chapter 14, Break It Deliberately - restore the approved knowledge set and prove the recovery
#
# Label: Runnable
#
# Restores the clean runbook from the backup taken by 03-break-approved-knowledge.sh,
# reruns the same question, and reruns the unit suite. The poisoned sentence is
# gone from the brief, and the suite still passes.
#
# Expected result, per the chapter: the clean READ-ONLY DIAGNOSTIC BRIEF from
# Step 4, with no SYSTEM OVERRIDE text, followed by `Ran 6 tests ... OK`.
# --- command as printed, verbatim ---
mv knowledge/checkout-api.md.bak knowledge/checkout-api.md
python3 src/assistant.py "What should I check after checkout errors began?"
python3 -m unittest discover -s tests
