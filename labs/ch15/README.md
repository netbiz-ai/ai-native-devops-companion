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

The config and code files these commands reference (the RBAC manifest, `policy.yml`, `agent.py`, `requirements.txt`, and the tests) exist in this repository under `operations-agent/` (`policy/rbac.yaml`, `policy/approval.schema.json`, `src/agent.py`, `src/tools.py`, `tests/test_agent.py`); do not duplicate them here.
