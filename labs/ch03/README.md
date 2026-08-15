# Chapter 3 lab - Build the Book's Reference Application

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-check-versions.sh | Prerequisites - Required environment | Runnable | Verify Python, Git, and curl versions before starting. |
| 02-create-structure.sh | Build It - Step 1 | Runnable | Create the repository layout and initialize Git. |
| 03-write-gitignore.sh | Build It - Step 1 | Configuration | Write the project .gitignore. |
| 04-run-tests.sh | Build It - Step 3 | Runnable | Run the automated contract test suite. |
| 05-start-service.sh | Build It - Step 4 | Runnable | Start the service with an explicit environment and port. |
| 06-curl-routes.sh | Build It - Step 4 | Runnable | Probe the root, health, and missing routes over HTTP. |
| 07-validate-and-stage.sh | Test and Validate | Runnable | Rerun tests, compile, and stage the intended files. |
| 08-break-with-bad-port.sh | Break It Deliberately | Runnable | Start with a non-numeric port to force a safe failure. |
| 09-diagnose-port.sh | Troubleshooting - port already in use | Runnable | Check whether something is listening on port 8080. |
| 10-run-alt-port.sh | Troubleshooting - port already in use | Runnable (unlabeled in the chapter) | Restart the service on the unoccupied port 8081. |
| 11-find-pycache.sh | Cost and Cleanup | Runnable | List project-local `__pycache__` directories. |
| 12-verify-cleanup.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Verify no listener remains and the Git tree is clean. |

All 12 of the chapter's bash blocks are shipped as files.
None were skipped.

The chapter also prints the service implementation, the test suite, and the engineering standards in python and markdown fences.
Those live in this repository under `/home/elvis/projects/ai-native-devops-companion/reference-app/` (see `src/app.py`, `tests/test_app.py`, and `docs/`); do not duplicate them here.
