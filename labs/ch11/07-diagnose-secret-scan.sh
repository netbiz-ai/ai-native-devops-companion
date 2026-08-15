#!/usr/bin/env bash
# Chapter 11, Troubleshooting "secret gate passes despite the committed fixture" - diagnose depth and fixture history
#
# Label: Runnable
# --- command as printed, verbatim ---
git rev-list --count HEAD
git log --all -- testdata/security/fake.env
