# Changelog

## 0.5.4 - 2026-08-18

- Restore the four missing sections to `templates/verification-checklist.md`: it stated it was the full form of the Chapter 1 checklist but ended after `## Intent`, so a reader copying it as instructed filled in a form carrying neither Information safety, Technical correctness and Engineering quality, nor the Evidence and decision section that holds the chapter's own "a named human owns the final decision" requirement. Closes errata issue 46.

## 0.5.3 - 2026-08-18

- Insist on port 8080 in the quickstart port notes: the printed commands, the lab validators, and the `curl` checks all assume it, so free the port rather than move the app, and treat `APP_PORT` as unsuitable for the book's exercises.

## 0.5.2 - 2026-08-18

- Create the virtual environment unconditionally in the README and getting-started quickstarts: on Debian and Ubuntu the system interpreter is externally managed (PEP 668), so a bare `pip install` failed with `error: externally-managed-environment` before reading the requirements file.
- Name the venv creation step in the offline validator's missing-dependencies hint.
- State next to the run step that the application binds port 8080 and the port must be free, show the `Address already in use` error a taken port produces, and point at the `APP_PORT` override.

## 0.5.1 - 2026-08-17

- Extend the coding-agent guide with "Where the human gate lives": the agent's stop points, the harness's permission prompts, and the book's gate artifacts, in one place.
- Trace the gate chapter by chapter through the arc of Chapters 1, 8, and 16.

## 0.5.0 - 2026-08-17

- Add coding-agent support: `AGENTS.md` at the root, a `CLAUDE.md` pointer, and a reader guide with a step-by-step walkthrough for running the labs with a coding agent.
- Ship the Chapter 14 fake-client demo module (`operations-assistant/src/demo.py`) the chapter invokes.
- Make the Chapter 1, 2, 3, and 10 validation blocks fail honestly, in lockstep with the printed pages.
- State the two entry routes for the pre-solved Chapter 3 and the shipped-tree caveats for its printed run command and test counts.
- Document launch directories, config-block destinations, and carried-in artifacts across the Chapter 1 to 3 and 14 labs.
- Close errata issues 28 to 45, found by agent dry-runs of Chapters 1, 2, 3, and 14.

## 0.2.0 to 0.4.0

Working states that were never tagged.
Their changes - the `labs/` extraction of every printed command, the reader's getting-started guide, the per-chapter Configuration blocks, the lab-environment templates, and the ch10 to ch13 handoff tags - are on `main` and included in v0.5.0.

## 0.1.0 - 2026-07-30

- Add the standard-library reference service and tests.
- Add container, CI, delivery, rollback, Terraform, Kubernetes, and GitOps assets.
- Add observability, security, incident-response, and optimization artifacts.
- Add the grounded operations assistant and bounded diagnostics agent.
- Add capstone evidence contracts and offline verification.
