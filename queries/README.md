# Query fixtures

Long `jsonpath` and `--patch-file` payloads live here rather than inline in a
chapter. A line that does not fit a printed page is a line a reader retypes
wrongly, so the book prints the short command and points at the file.

| File | Used by | Command shape |
|---|---|---|
| `endpoint-ready.jsonpath` | Chapter 8 | `kubectl get endpointslice -o jsonpath="$(cat queries/endpoint-ready.jsonpath)"` |

Label: fixture. These are inputs to commands, not evidence of a run.
