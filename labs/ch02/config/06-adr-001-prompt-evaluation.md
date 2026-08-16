# ADR-001: Store prompts with evaluation evidence

## Context

Reusable operational prompts need traceable requirements, tests, and review decisions.

## Options

- Personal chat history
- Shared document
- Version-controlled library

## Decision

Use a version-controlled library with linked cases, immutable raw responses, and separate human reviews.

## Consequences

Prompt changes require evaluation, review evidence, and a clean Git history.

## Reconsider when

An approved prompt registry provides stronger access control and equivalent traceability.
