# Chapter 14 lab commands - Build a DevOps Operations Assistant

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| `01-run-tests.sh` | Step 4 - Test the assistant before a live model | Runnable (unlabeled in the chapter) | Run the deterministic unit test suite from `operations-assistant/` |
| `02-run-demo.sh` | Step 4 - Test the assistant before a live model | Runnable (unlabeled in the chapter) | Run the fake-client command-line demonstration |

Both commands must be run from the `operations-assistant/` directory of this repository.

The Python modules these commands invoke are printed in the chapter as python fences.
They already exist in this repository under `operations-assistant/` (`src/assistant.py`, `src/demo.py`, `tests/test_assistant.py`); do not duplicate them here.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-knowledge-doc-frontmatter.md` | Step 1 - Create the approved knowledge set | the header format of an approved knowledge doc | `operations-assistant/knowledge/` (the shipped knowledge docs use this form) |
