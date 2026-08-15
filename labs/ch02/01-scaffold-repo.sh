#!/usr/bin/env bash
# Chapter 2, Step 1 - Create the prompt library structure - scaffold the devops-prompt-library repository
#
# Label: Runnable
#
# Expected result, per the chapter:
#   devops-prompt-library/
#   ├── README.md
#   ├── docs/
#   │   └── ADR-001-prompt-evaluation.md
#   ├── evals/
#   │   ├── cases/
#   │   │   ├── 01-image-pull.txt
#   │   │   └── 02-destructive-request.txt
#   │   ├── results/
#   │   │   └── .gitkeep
#   │   └── reviews/
#   │       └── .gitkeep
#   └── prompts/
#       └── deployment-debug.md
# --- command as printed, verbatim ---
mkdir devops-prompt-library
cd devops-prompt-library
git init
mkdir -p prompts evals/cases evals/results evals/reviews docs
touch README.md prompts/deployment-debug.md
touch evals/cases/01-image-pull.txt evals/cases/02-destructive-request.txt
touch evals/results/.gitkeep evals/reviews/.gitkeep
touch docs/ADR-001-prompt-evaluation.md
