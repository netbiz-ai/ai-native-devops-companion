---
source_id: runbook-readiness
owner: platform-learning
environment: reference-staging
reviewed: 2026-07-30
---

# Readiness failure

Confirm the failing path is `/ready`, identify the exact image digest and
GitOps revision, then inspect deployment conditions, pod readiness, events,
and the application health contract. Compare the declared probe with the
application route.

Do not broaden permissions or restart the deployment from this assistant.
Record a proposed Git correction for human review when the declaration is
wrong.
