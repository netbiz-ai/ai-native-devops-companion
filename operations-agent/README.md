# Diagnostics agent

The initial release is a runnable deterministic fixture, not a live cluster
agent. It proves the tool allowlist, namespace/resource scope, proposal schema,
sequential audit shape, and non-mutation boundary.

```bash
python3 src/agent.py deployment-status
python3 -m unittest discover -s tests -p 'test_*.py'
```

The proposal cannot execute. A live adapter requires separate credentials,
effective-permission tests, timeouts, audit retention, hostile-input
evaluation, and an approved disposable cluster. Do not grant mutation verbs to
the service account.
