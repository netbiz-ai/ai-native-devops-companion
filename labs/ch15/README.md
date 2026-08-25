# Chapter 15 lab commands - Design a Bounded AI Operations Agent

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
| --- | --- | --- | --- |
| 01-check-namespace.sh | Data Box - required environment | Runnable (unlabeled in the chapter) | Confirm the `reference-staging` namespace exists before applying chapter resources. |
| 02-apply-rbac.sh | Step 1 - Create a least-privilege diagnostic identity | Runnable (unlabeled in the chapter) | Dry-run and apply the RBAC manifest, then verify effective permissions by impersonation. |
| 03-run-agent.sh | Step 6 - Run the diagnostic agent | Runnable (unlabeled in the chapter) | Create a venv, install dependencies, and run one diagnosis of `reference-app`. |
| 04-run-tests.sh | Test and Validate | Runnable (unlabeled in the chapter) | Run the unit tests and list the agent identity's effective permissions. |
| 05-list-permissions.sh | Troubleshooting - the service account can read more resources than expected | Runnable (unlabeled in the chapter) | List effective permissions to diagnose over-broad access. |
| 06-delete-rbac.sh | Cost and Cleanup | Runnable (unlabeled in the chapter) | Delete the chapter's RBAC objects and confirm each `get` returns `NotFound`. |

All six blocks shipped; no block was printed without being shipped as a file.

## What does not behave as printed here

- **Every block addresses `agents/k8s-diagnostics/`, which is not a path here.**
  `docs/chapter-map.md` maps it to `operations-agent/`. The RBAC file has no
  alias entry and no matching name either: the blocks name
  `rbac/diagnostics-reader.yml`, and the file is `operations-agent/policy/rbac.yaml`.

- **02 and 06 also name objects the manifest does not create.** The manifest
  defines a Role and a RoleBinding both called `diagnostics-agent-read`; the
  blocks look for `diagnostics-reader` and `diagnostics-agent-reader`. So 06's
  three confirmations report `NotFound` for objects that never existed, whether
  or not the delete worked. Confirm against the real names:

      kubectl get serviceaccount diagnostics-agent -n reference-staging
      kubectl get role,rolebinding diagnostics-agent-read -n reference-staging

- **03's flags are not the agent's interface.** The block runs
  `python agent.py diagnose --incident INC-204 --namespace reference-staging
  --workload reference-app`. `agent.py` reads three positional arguments -
  tool, namespace, resource - so `diagnose` is taken as the tool name and
  refused, correctly, as not allowlisted. The allowlisted tools are
  `deployment-status`, `events` and `log-tail`:

      python3 src/agent.py events reference-staging reference-app

  03 also creates a venv from a `requirements.txt` that `operations-agent/`
  does not carry; the agent needs only the standard library.

Substituting the real paths, the chapter's claims hold: the Role grants
`get list` on pods, pod logs and events and `get` on one named Deployment,
with no write verb and no access to secrets or other namespaces, and the agent
refuses namespace escapes, resource escapes, unlisted tools and injected tool
names while recording `mutation_executed: false`.

The config and code files these commands reference (the RBAC manifest, `policy.yml`, `agent.py`, `requirements.txt`, and the tests) exist in this repository under `operations-agent/` (`policy/rbac.yaml`, `policy/approval.schema.json`, `src/agent.py`, `src/tools.py`, `tests/test_agent.py`); do not duplicate them here.
