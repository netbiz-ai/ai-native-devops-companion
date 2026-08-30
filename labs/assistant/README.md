# Chapter 14 lab commands - Build a DevOps Operations Assistant

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| `01-run-tests.sh` | Step 4 - Test the assistant before a live model | Runnable (unlabeled in the chapter) | Run the deterministic unit test suite from `operations-assistant/` |
| `02-run-demo.sh` | Step 4 - Test the assistant before a live model | Runnable (unlabeled in the chapter) | Run the fake-client command-line demonstration |
| `03-break-approved-knowledge.sh` | Break It Deliberately | Runnable | Poison the approved knowledge doc and watch the injected sentence surface, quoted, in the cited answer |
| `04-restore-knowledge.sh` | Break It Deliberately | Runnable | Restore the clean doc, rerun the question, and rerun the suite |
| `validate.sh` | Test and Validate | helper (not a printed block) | Chapter validator behind `make ch14-validate`; see below |

All commands must be run from the `operations-assistant/` directory of this repository, except `validate.sh`, which resolves the repository root itself.

This chapter's carried-in artifact is the sanitized `docs/incidents/ch12-controlled-failure.md` you wrote in Chapter 12: Step 1 has you distill it into the approved knowledge doc below.
No shipped script reads that record directly, so the labs run without it, but the knowledge doc you write from it is the chapter's actual work.
`validate.sh` (also `make ch14-validate`) checks that work: the knowledge doc exists with its governance frontmatter and no leftover Break It poison, the demo answers the known question from it, an action request is refused, and the six-test suite passes.
It fails on an untouched clone by design, so a pass is evidence of the reader's chapter work, not only of the shipped code.

The Python modules these commands invoke live in this repository under `operations-assistant/` (`src/assistant.py`, `src/retriever.py`, `src/demo.py`, `tests/test_assistant.py`); do not duplicate them here.
The shipped code is canonical per `docs/chapter-map.md` where its details differ from the chapter's listings; `src/demo.py` is the fake-client demonstration the chapter invokes, and it prints the chapter's safe answer only after your Step 1 knowledge doc exists (see the note in `02-run-demo.sh`).

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-knowledge-doc-frontmatter.md` | Step 1 - Create the approved knowledge set | `operations-assistant/knowledge/checkout-api.md` - a complete example knowledge document (frontmatter and body), the doc the chapter's demo cites | `operations-assistant/knowledge/` (the shipped knowledge docs use this form) |
