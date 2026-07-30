# Read-only debugging prompt

## Business outcome

Identify the next evidence-gathering step without changing system state.

## Operating context

Use only the supplied sanitized symptoms, timestamps, recent changes, and
observed output.

## User request

Return ranked hypotheses and discriminating read-only checks.

## Non-negotiable constraints

Do not invent facts, commands, credentials, files, permissions, or results.
Stop before writes, restarts, rollback, deletion, or permission changes.

## Data supplied

{{SANITIZED_CASE}}

## Assumptions policy

Label every assumption and request missing evidence.

## Required response

For each hypothesis: supplied evidence, uncertainty, read-only check, expected
result, and stop condition.

## Inspection criteria

Every claim points to supplied evidence or is labeled unverified.

## Escalation and safety

Escalate when evidence is insufficient or a state change would be required.

## Sources and verification

Prefer direct observation and official documentation appropriate to the
installed version.
