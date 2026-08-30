---
service: checkout-api
owner: commerce-platform
reviewed: 2026-07-01
sensitivity: internal
---

# Checkout API high error rate

Confirm the alert window and compare it with recent deployment events.
Check request error rate by endpoint and dependency timeout rate.
If failures began after a release, prepare the documented rollback for human approval.
Do not restart all replicas before capturing logs and deployment state.
