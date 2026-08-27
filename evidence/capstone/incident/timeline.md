# CAP-05 incident timeline

Observed 2026-08-10T17:50:47Z on cluster kind-ch10-lab, namespace reference-incident.
Controlled fault, injected and recovered by the chapter's own scripts.

| Phase | Observation |
|---|---|
| Preflight | `incident_preflight=pass mode=runnable`, namespace disposable |
| Fault injected | 800ms latency applied, state recorded to pre-fault-state.txt |
| Detected under load | 46 requests, 0 failed, **p95 0.809s** against a 0.5s alert threshold |
| Evidence captured | evidence/ch12/fault-state.txt, 32 lines |
| Restored | latency 800ms to 0ms, ready_replicas 2/2, operator authoros |
| Recovered under load | 119 requests, 0 failed, **p95 0.008s** |
| Validated | no fault applied, 2/2 replicas ready, 3 evidence files |

The fault degraded latency by roughly a hundredfold while keeping every request
successful, which is what a safe failure looks like: detectable on latency, not
on errors. Recovery returned p95 to baseline.
