# Chapter 11 lab commands - Design an AI-Assisted DevSecOps Pipeline

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-run-preflight.sh | Prerequisites | Runnable | Verify required files, fixtures, and tool availability before starting |
| 02-start-chapter.sh | Prerequisites | Runnable | Enter the chapter starting state and create the workflow, docs, and evidence directories |
| 03-check-workflow-pins.sh | Build It, Step 1 | Runnable | Fail on unresolved pin placeholders in the security workflow, then lint it with actionlint |
| 04-apply-ruleset.sh | Build It, Step 4 | Runnable | Apply the security ruleset once, capture the effective rules, and verify them |
| 05-plant-fixture.sh | Break It Deliberately | Runnable | Commit the harmless secret fixture on a disposable branch and push it to trigger the secret gate |
| 06-rewrite-branch.sh | Break It Deliberately | Runnable | Reset the disposable branch to the safe ref and force-push to remove the unsafe commit from reachable history |
| 07-diagnose-secret-scan.sh | Troubleshooting - secret gate passes | Runnable | Check clone depth and the fixture's presence in history |
| 08-inspect-image.sh | Troubleshooting - image scan cannot find the image | Runnable | Confirm the commit-tagged image exists locally |
| 09-delete-branches.sh | Cost and Cleanup | Runnable | Delete the disposable remote branch and local safety refs, then confirm removal |

## Migrated scripts

- verify-security-ruleset.sh - pre-existing script migrated into this directory; it verifies an applied ruleset's target, required checks, enforcement, and bypass actors, and is invoked by 04-apply-ruleset.sh as labs/ch11/verify-security-ruleset.sh.

## Referenced configuration files

The workflow, Semgrep rules, and secret fixture that these commands reference already exist in this repository as /home/elvis/projects/ai-native-devops-companion/.github/workflows/security.yml, rules/semgrep.yml, and testdata/security/gitleaks-fixture.txt - do not duplicate them; docs/security/security-ruleset.json is authored by the reader per Step 4.
