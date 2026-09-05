#!/usr/bin/env bash
# reference-app lab, Step 3 - run the automated contract test suite
#
# Label: Runnable
#
# Expected result, per the chapter:
#   test_health_is_live ... ok
#   test_ready_accepts_traffic ... ok
#   test_root_returns_service_information ... ok
#   test_unknown_path_returns_404 ... ok
#   test_defaults_are_loaded ... ok
#   test_non_numeric_port_is_rejected ... ok
#
# Against this repository's shipped tree expect `Ran 37 tests ... OK`: the clone
# also carries the observability lab and 12 suites. The chapter's count describes the
# app as you write it in this chapter.
#   test_out_of_range_port_is_rejected ... ok
#   test_query_string_preserves_root_response ... ok
#   test_server_settings_are_isolated ... ok
#   test_unknown_path_preserves_json_error_contract ... ok
#
#   Ran 10 tests
#
#   OK
#
# --- command as printed, verbatim ---
python3 -m unittest discover -v
