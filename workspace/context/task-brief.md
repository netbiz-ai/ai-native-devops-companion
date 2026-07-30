# Task brief

Outcome: stop a failed release gate before promotion.

Acceptance criteria:

- a success input returns zero;
- a failed check returns non-zero;
- missing input fails closed;
- no command changes a shared system;
- the reviewer records accepted, changed, rejected, and unresolved advice.

Unknown production context remains explicitly out of scope.
