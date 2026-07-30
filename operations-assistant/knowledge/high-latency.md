---
source_id: runbook-high-latency
owner: platform-learning
environment: reference-staging
reviewed: 2026-07-30
---

# High latency

Confirm the alert labels, release identity, traffic floor, and evaluation
window. Compare user-facing behavior with pod readiness and rollout state.
Inspect latency buckets, error ratio, recent GitOps revisions, resource
pressure, and release-linked logs and traces using approved read-only access.

Escalate before restart, rollback, scaling, permission changes, or any write.
Alert recovery alone does not prove customer-facing recovery.
