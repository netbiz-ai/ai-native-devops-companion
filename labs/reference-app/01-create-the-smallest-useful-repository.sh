#!/usr/bin/env bash
# The reference-app lab - CH02, Step 1 - Create the Smallest Useful Repository
#
# Label: Runnable
#
# Expected result, per the chapter:
#   .
#   ./.gitignore
#   ./src
#   ./src/__init__.py
#   ./tests
#   ./tests/__init__.py
# --- command as printed, verbatim ---
mkdir -p src tests
git init
touch src/__init__.py tests/__init__.py

cat > .gitignore <<'EOF'
__pycache__/
*.pyc
EOF

find . -path ./.git -prune -o -print | sort
