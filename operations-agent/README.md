# Diagnostics agent

The initial release is a runnable deterministic fixture, not a live cluster
agent. It proves the tool allowlist, namespace/resource scope, proposal schema,
sequential audit shape, and non-mutation boundary.

```bash
python3 src/agent.py deployment-status
python3 -m unittest discover -s tests -p 'test_*.py'
```

Every proposal is derived from the observation and cites it. Where an
observation does not support a conclusion the agent asks for the evidence that
would, rather than proposing anyway: `log-tail` returns
`collect-deployment-status`, because a log tail records what the application
answered and establishes neither replica state nor probe configuration. A
plausible sentence standing in for evidence is the failure this chapter is
about, and the tests fail if a proposal stops quoting what it read.

The proposal cannot execute. A live adapter requires separate credentials,
effective-permission tests, timeouts, audit retention, hostile-input
evaluation, and an approved disposable cluster. Do not grant mutation verbs to
the service account.
