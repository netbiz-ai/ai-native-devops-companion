# reference-app lab - Build the Book's Reference Application

Second edition: chapter 2. First edition and the full mapping: [docs/subject-map.md](../../docs/subject-map.md).

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

## Two ways to enter this chapter

This chapter has you build `reference-app`, but this repository already ships it finished on `main` (later chapters depend on it), so choose your route before running 02:

- **Build your own (the chapter as written).** Run 01 and 02 from a directory *outside* this clone (a sibling such as `~/labs/` works); 02 creates a fresh `reference-app/` repository there, and every printed command - including `python3 -m src.app` and the ten-test suite - behaves exactly as the page says. The clone's `reference-app/` is then your solution key.
- **Work against the shipped app.** Skip 02 entirely - inside the clone it would nest a second git repository - and run 03 to 12 against the clone's `reference-app/`, with the shipped-tree caveats below (`python3 src/app.py`, 37 tests).

Either way, from the container lab onward the labs run against the clone's `reference-app/`, which is canonical per `docs/subject-map.md`.

## How the files run

- Each numbered file is a separate script, so 02's `cd` does not carry: run 01 and 02 from where you keep your lab work, and 03 to 12 from inside the `reference-app/` directory your route uses.
- 05 and 10 start a server that blocks its terminal; run each in its own terminal and probe with 06 or 09 from another.
- Against this repository's shipped reference-app, the printed `python3 -m src.app` form in 05, 08, and 10 fails with `No module named 'telemetry'` (the shipped app carries the observability lab refactor); use `python3 src/app.py` with the same environment variables. The printed form works against the app as this chapter has you write it.
- On the shipped app, 05 and 10 print three fields the chapter's expected result does not show: `fault_gate`, `trace_header`, and `injected_latency_ms`, which the observability lab and 12 work added to the same banner. Their presence is correct here and is not a misconfiguration; the printed one-line form is what the app you write yourself produces.
- Before 07, write `evidence/ch03-validation.txt` as the chapter's Test and Validate section describes; 07 stages it.
- Before 12, stop the servers from 05/10 (a Ctrl-C in the book).
- 06's `curl --fail-with-body` needs curl 7.76 or newer, which 01 does not check for.

The chapter also prints the service implementation, the test suite, and the engineering standards in python and markdown fences.
The implementation and tests live in this repository under `reference-app/` (`src/app.py`, `tests/test_app.py`); do not duplicate them.
The engineering-standards document is yours to write: copy the config block below to `reference-app/docs/engineering-standards.md` - this repository does not carry a live copy.

## The chapter's ten tests, under their shipped names

`reference-app/tests/test_app.py` holds exactly the chapter's ten tests, renamed.
None of the printed names exists in the shipped tree, so grepping for one finds nothing and reads as a missing suite; the contracts are all covered.
The other 27 tests the shipped suite runs are the observability lab and 12 suites, per `docs/subject-map.md`.

| Printed in the chapter | Shipped in `tests/test_app.py` |
|---|---|
| `test_health_is_live` | `RouteTests.test_health_contract` |
| `test_ready_accepts_traffic` | `RouteTests.test_ready_contract` |
| `test_root_returns_service_information` | `RouteTests.test_root_contract` |
| `test_unknown_path_returns_404` | `RouteTests.test_unknown_route_is_json_404` |
| `test_defaults_are_loaded` | `SettingsTests.test_defaults` |
| `test_non_numeric_port_is_rejected` | `SettingsTests.test_non_integer_port_fails` |
| `test_out_of_range_port_is_rejected` | `SettingsTests.test_out_of_range_port_fails` |
| `test_query_string_preserves_root_response` | `HTTPAdapterTests.test_real_http_root_and_query` |
| `test_unknown_path_preserves_json_error_contract` | `HTTPAdapterTests.test_real_http_404_and_server_banner` |
| `test_server_settings_are_isolated` | `SettingsTests.test_environment_override`, by elimination |

The ci lab prints a third name for the first of these: `labs/ci/07-reproduce-failed-test.sh` runs `tests.test_app.RouteTests.test_health_returns_200`, which is absent for the same reason.

The last row is the least certain: `test_environment_override` asserts that four `APP_*` variables override the defaults, which is not obviously what "server settings are isolated" describes.
It is the only shipped test left unmatched once the other nine are placed.
Two shipped tests also assert more than their printed name suggests; `test_real_http_404_and_server_banner` additionally checks that the `Server` header does not leak `Python`.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/subject-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-engineering-standards.md` | Step 5 - Record standards and operating instructions | `docs/engineering-standards.md` in the app repo | - |
