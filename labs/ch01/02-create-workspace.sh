#!/usr/bin/env bash
# Chapter 1, Build It / Step 1 - create the workspace repository and sample artifact
#
# Label: Runnable
# --- command as printed, verbatim ---
mkdir -p ai-native-workspace/context
mkdir -p ai-native-workspace/drafts
mkdir -p ai-native-workspace/evidence
mkdir -p ai-native-workspace/decisions
mkdir -p ai-native-workspace/samples
mkdir -p ai-native-workspace/artifacts
cd ai-native-workspace
git init
touch context/task-brief.md
touch context/ai-usage-policy.md
touch drafts/model-response.md
touch evidence/verification-checklist.md
touch decisions/review-record.md
touch README.md
touch artifacts/release.tar
