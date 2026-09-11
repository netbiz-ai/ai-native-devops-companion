#!/usr/bin/env bash
# assistant lab, Step 4 - Test the assistant before a live model - run the deterministic unit test suite
#
# Label: Runnable (unlabeled in the chapter)
#
# Expected result, per the chapter:
#   test_a_single_shared_token_is_not_a_match ... ok
#   test_action_request_is_refused ... ok
#   test_high_latency_answer_is_cited_and_bounded ... ok
#   test_prompt_injection_is_refused ... ok
#   test_readiness_answer_uses_readiness_source ... ok
#   test_unsupported_question_is_refused ... ok
#   Ran 6 tests ... OK
# --- command as printed, verbatim ---
python3 -m unittest discover -s tests -v
