#!/usr/bin/env bash
# The agent lab - CH12, Test and Validate
#
# Label: Runnable:
#
# Expected result, per the chapter:
#   ...........
#   ----------------------------------------------------------------------
#   Ran 11 tests
#
#   OK
# --- command as printed, verbatim ---
python3 -m unittest discover -s operations-agent/tests -p 'test_*.py'
