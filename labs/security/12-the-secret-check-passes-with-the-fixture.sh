#!/usr/bin/env bash
# The security lab - CH09, Symptom: The Secret Check Passes With the Fixture
#
# Label: Runnable
# --- command as printed, verbatim ---
git rev-list --count HEAD
git log --all -- testdata/security/gitleaks-fixture.txt
git show HEAD:testdata/security/gitleaks-fixture.txt | sed 's/=.*/=[REDACTED]/'
grep -n 'fetch-depth' .github/workflows/security.yml
