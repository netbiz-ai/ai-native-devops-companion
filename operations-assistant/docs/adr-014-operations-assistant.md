# ADR-014: Keep the operations assistant read-only

Status: accepted.

The baseline uses a deterministic local retriever over approved runbooks. It
requires source citations, states that no live system was inspected, refuses
state-changing requests and prompt-injection markers, and has no tool or
credential path.

A replaceable model client may later draft prose from the same bounded context,
but it must not weaken citation, refusal, output-validation, data-approval, or
human-ownership controls.
