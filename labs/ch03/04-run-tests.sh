#!/usr/bin/env bash
# Chapter 3, Step 3 - run the automated contract test suite
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
