# Chapter 4 lab scripts - Containerize and Optimize with AI

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-verify-prereqs.sh | Prerequisites | Runnable | Confirm the Chapter 3 files and start the service locally |
| 02-check-environment.sh | Prerequisites - Required publication environment | Runnable | Record Git state, Docker, Buildx, Trivy, OS, and architecture |
| 03-build-baseline.sh | Build It - Step 2 | Runnable | Build the baseline image and measure time, size, and file count |
| 04-record-digest.sh | Build It - Step 3 | Runnable | Pull the base tag and record its registry digest into python_base |
| 05-build-final.sh | Build It - Step 3 | Runnable | Build the final image with the recorded base and assert the label contract |
| 06-run-service.sh | Build It - Step 4 | Runnable | Run read-only, probe /health, check uid 10001, and stop the container |
| 07-inspect-image.sh | Test and Validate | Runnable | Inspect the image user, command, and layer history |
| 08-scan-secrets.sh | Test and Validate | Runnable | Run Trivy secret scanners against image files and configuration |
| 09-scan-vulns.sh | Test and Validate | Runnable | Scan for HIGH and CRITICAL findings under the learning policy |
| 10-record-id.sh | Test and Validate | Runnable | Record the local immutable image ID |
| 11-break-image.sh | Break It Deliberately | Runnable | Build a Dockerfile without the application copy and confirm the failure |
| 12-diff-dockerfiles.sh | Break It Deliberately | Runnable | Diff the broken and working Dockerfiles to verify the cause |
| 13-list-app-files.sh | Troubleshooting - application package missing | Runnable (unlabeled in the chapter) | List files under /app in the image |
| 14-check-permissions.sh | Troubleshooting - permission error | Runnable (unlabeled in the chapter) | Show container identity and /app and /tmp ownership |
| 15-check-ports.sh | Troubleshooting - health request cannot connect | Runnable (unlabeled in the chapter) | Read container logs and published ports |
| 16-remove-artifacts.sh | Cost and Cleanup | Runnable | Remove the lab container, baseline and broken images, and temporary Dockerfiles |
| 17-verify-cleanup.sh | Cost and Cleanup | Runnable | Confirm removals and print the retained image ID |

Note that 04-record-digest.sh and 05-build-final.sh share the `python_base` shell variable, so run them in one shell session (or source them) as the chapter does.

The chapter's `.dockerignore`, `Dockerfile.baseline`, and multi-stage `Dockerfile` are printed as Configuration fences, not bash blocks; the repository's container files live in `reference-app/`.

## The shipped Dockerfile is not this chapter's Dockerfile

`reference-app/Dockerfile` on `main` is the Chapter 10 evolution of the file, not the multi-stage build this chapter prints as `config/03-dockerfile-final.dockerfile`.
It is single-stage on `python:3.12-alpine`, installs `requirements.txt`, copies the contents of `src/` to `/app`, and carries no `ARG` and no `LABEL`.
Later chapters need that file, so it cannot be replaced here.

Two of the chapter's steps therefore cannot behave as printed against it.

- **05 asserts a label contract the shipped file does not carry.** The three `--build-arg` values are rejected as unconsumed, `title`, `revision` and `source` all come back empty, and every assertion fails. Chapter 4's validation entry in `docs/chapter-map.md` is these assertions, so the chapter cannot validate against the shipped file.
- **11 never breaks the image.** Its `awk` deletes the line `COPY --from=builder --chown=10001:10001 /build/src ./src`, which the shipped file does not contain, so `Dockerfile.broken` is identical to `Dockerfile`, the image starts normally, and the script reports `unexpected success: investigate before continuing`. That message points away from the cause, which is the file, not the build.

To run the chapter as printed, write `config/03-dockerfile-final.dockerfile` to `reference-app/Dockerfile` first and restore it afterwards with `git checkout -- reference-app/Dockerfile`.
The label assertions pass on that route, and the Break It step fails for the reason the chapter intends.

One step still cannot pass on it, and this is the Chapter 3 route choice reaching forward.
06 runs the image, and an image built from the chapter's Dockerfile cannot run the shipped application: the chapter copies `src` as a package and runs `python3 -m src.app`, while the shipped `src/app.py` does a flat `import telemetry` that only resolves when the module lands at `/app/telemetry.py` as the shipped Dockerfile places it.
The chapter's Dockerfile also has no `pip install`, so the `opentelemetry` packages `src/telemetry.py` imports are absent either way.
A reader who built their own Chapter 3 application outside the clone is unaffected, because that application is standard library only.

## Pre-existing (migrated) scripts

None - this directory was created for this extraction.

## Non-shipped blocks

None - all 17 bash blocks in the chapter are commands and are shipped as files.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-dockerignore.txt` | Step 1 - Control the build context | `.dockerignore` of the app | `reference-app/.dockerignore` |
| `config/02-dockerfile-baseline.dockerfile` | Step 2 - Build and measure a baseline | the single-stage baseline you measure against | - |
| `config/03-dockerfile-final.dockerfile` | Step 3 - Record the base identity and build the final image | the hardened multi-stage build | `reference-app/Dockerfile` |
