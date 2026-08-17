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
| 12-verify-cleanup.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Verify no listener remains and only intended files appear in `git status`. |

All 12 of the chapter's bash blocks are shipped as files.
None were skipped.

## How the files run

- Each numbered file is a separate script, so 02's `cd` does not carry: run 01 and 02 from where you keep your lab work, and 03 to 12 from inside the `reference-app/` directory.
- 05 and 10 start a server that blocks its terminal; run each in its own terminal and probe with 06 or 09 from another.
- Against this repository's shipped reference-app, the printed `python3 -m src.app` form in 05, 08, and 10 fails with `No module named 'telemetry'` (the shipped app carries the Chapter 10 refactor); use `python3 src/app.py` with the same environment variables. The printed form works against the app as this chapter has you write it.
- Before 07, write `evidence/ch03-validation.txt` as the chapter's Test and Validate section describes; 07 stages it.
- Before 12, stop the servers from 05/10 (a Ctrl-C in the book).
- 06's `curl --fail-with-body` needs curl 7.76 or newer, which 01 does not check for.

The chapter also prints the service implementation, the test suite, and the engineering standards in python and markdown fences.
The implementation and tests live in this repository under `reference-app/` (`src/app.py`, `tests/test_app.py`); do not duplicate them.
The engineering-standards document is yours to write: copy the config block below to `reference-app/docs/engineering-standards.md` - this repository does not carry a live copy.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-engineering-standards.md` | Step 5 - Record standards and operating instructions | `docs/engineering-standards.md` in the app repo | - |
