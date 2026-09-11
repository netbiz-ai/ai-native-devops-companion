# Reference app high latency

Owner: platform-learning

This runbook supports the `reference-staging` learning environment only.

1. Confirm the alert labels, evaluation window, release identity, and traffic
   floor.
2. Compare the user-facing request with current pod readiness and rollout
   state.
3. Inspect latency buckets, errors, recent GitOps changes, resource pressure,
   and relevant logs/traces using approved read-only access.
4. Record competing hypotheses and the evidence that could distinguish them.
5. Escalate before restart, rollback, scaling, permission change, or any write.

Recovery requires an observed customer-facing check plus workload state over
the agreed window. Alert recovery alone is insufficient.
