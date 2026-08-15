#!/usr/bin/env bash
# Chapter 14, Step 4 - Test the assistant before a live model - run the deterministic unit test suite
#
# Label: Runnable (unlabeled in the chapter)
#
# Expected result, per the chapter:
#   test_safe_cited_answer ... ok
#   test_policy_denial_stops_before_retrieval ... ok
#   test_weak_evidence_refuses ... ok
#   test_each_item_requires_valid_citations ... ok
#   test_disallowed_operation_with_safe_text_is_rejected ... ok
#   test_all_other_failure_cases ... ok
#   OK
# --- command as printed, verbatim ---
python3 -m unittest discover -s tests -v
