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

## Pre-existing (migrated) scripts

None - this directory was created for this extraction.

## Non-shipped blocks

None - all 17 bash blocks in the chapter are commands and are shipped as files.
