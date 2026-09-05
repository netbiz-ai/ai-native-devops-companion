#!/usr/bin/env bash
# The security lab, Troubleshooting "secret gate passes despite the committed fixture" - diagnose depth and fixture history
#
# Label: Runnable
# --- command as printed, verbatim ---
git rev-list --count HEAD
git log --all -- testdata/security/fake.env
