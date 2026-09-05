# ci lab commands - Build an AI-Assisted CI Pipeline

Second edition: chapter 4. That chapter covers `ci` and `delivery`. First edition and the full mapping: [docs/subject-map.md](../../docs/subject-map.md).

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-verify-repo-state.sh | Prerequisites | Runnable | Confirm the container lab files exist, tests pass, and the worktree is clean |
| 02-check-tool-versions.sh | Prerequisites | Runnable | Verify Git, Python, Docker, curl, rg, and actionlint are installed |
| 03-run-local-checks.sh | Build It, Step 1 | Runnable | Install pinned dev tools and run Ruff, unittest, and Bandit locally |
| 04-review-workflow.sh | Build It, Step 3 | Runnable | Stage the workflow and review it with git, actionlint, and rg |
| 05-commit-and-push.sh | Build It, Step 4 | Runnable | Commit the CI workflow and push the branch so the gates run |
| 06-validate-local-layer.sh | Test and Validate | Runnable | Run checks, build the image, start the container, and probe /health |
| 07-reproduce-failed-test.sh | Break It Deliberately, Failure 1 | Runnable | Inspect the test diff and reproduce the single failing test locally |
| 08-clean-up-lab-resources.sh | Cost and Cleanup | Runnable | Remove the labeled lab container, the lab image, and the virtualenv session |
| 09-confirm-cleanup.sh | Cost and Cleanup | Runnable | Confirm the ci lab container and image are absent |

All nine bash blocks in the chapter ship as files.
No block is printed but withheld.

## Referenced configuration files

The workflow the blocks reference lives in this repository at `.github/workflows/ci.yml`.
The chapter also prints a two-line `requirements-dev.txt` (ruff==0.16.0, bandit==1.9.4).
The live file is `reference-app/requirements-dev.txt`, which carries those two pins and a `-r requirements.txt` line the page does not print, because 03 builds its virtual environment from this file alone and then runs the test suite inside it.

## What does not behave as printed here

- **03 and 06 exit 0 even when their checks fail.** Neither sets `-e`, and each ends on a command that succeeds regardless: 03 on `bandit`, 06 on a `test` against a successful health probe. A reader following exit codes sees a green chapter whatever Ruff and unittest reported above. 02 has the same property: with `rg` absent it still exits 0, because `actionlint -version` runs last, and the missing tool surfaces only when 04 fails.
- **04 stages `requirements-dev.txt` from the repository root, where it does not exist.** The chapter assumes the application and `.github/` share one repository; here the app is under `reference-app/` and the workflow at the root, so `git add requirements-dev.txt .github/workflows/ci.yml` fails with `pathspec 'requirements-dev.txt' did not match any files`. The file is at `reference-app/requirements-dev.txt`, and 03 and 06 both expect to run from beside it.
- **07 names a test that does not exist.** `tests.test_app.RouteTests.test_health_returns_200` is absent; the shipped test is `RouteTests.test_health_contract`. The reference-app lab prints a third name for the same test, `test_health_is_live`, so one test carries three names across the book and the tree; `labs/reference-app/README.md` maps the reference-app lab names.
- **The printed workflow fails the chapter's own validation command.** Written to `.github/workflows/ci.yml` as Step 2 directs, `config/02-ci-workflow.yaml` exits 1 under actionlint with shellcheck installed: one `SC2034` (`for attempt in {1..15}` never uses `$attempt`) and four `SC2317` against the `cleanup` trap. The live `.github/workflows/ci.yml` passes clean, which is why the chapter map's validation entry passes. Note the result depends on shellcheck being present: actionlint skips the shell analysis without it, so two readers on the same actionlint version can see different outcomes.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/subject-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-tool-identities.txt` | Data Box - Tool and action identities | the pinned tool identities the chapter fixes | - |
| `config/02-ci-workflow.yaml` | Step 2 - Create the secure GitHub Actions workflow | `.github/workflows/ci.yml` | `.github/workflows/ci.yml` |
