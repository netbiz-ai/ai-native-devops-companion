# Chapter 8 lab scripts - Kubernetes with AI as a Reviewer

These are the chapter's commands exactly as the book prints them, one file per bash block, in book order.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-check-prerequisites.sh | Prerequisites | Runnable | Verify required tools, cluster access, branch, directories, and namespace permissions. |
| 02-create-namespace.sh | Build It, Step 1 | Runnable | Refuse an existing namespace, dry-run, diff, then apply namespace.yaml and record its UID. |
| 03-validate-before-apply.sh | Build It, Step 3 | Runnable | Prove namespace ownership, check permissions, and server-dry-run the manifests. |
| 04-check-psa-rejection.sh | Build It, Step 3 | Runnable | Prove Restricted admission rejects a noncompliant server-dry-run Pod. |
| 05-diff-manifests.sh | Build It, Step 3 | Runnable | Run kubectl diff on the policy and workload manifests before approval. |
| 06-apply-and-observe.sh | Build It, Step 4 | Runnable | Apply policy then workload, watch the rollout, and inspect endpoints. |
| 07-run-client-positive-test.sh | Build It, Step 5 | Runnable | Deploy the labeled test client and prove it reaches /ready through the Service. |
| 08-test-unlabeled-denial.sh | Build It, Step 5 | Runnable | Remove the client label and prove the unlabeled client is denied. |
| 09-test-egress-denial.sh | Build It, Step 5 | Runnable | Prove the application Pod cannot open unapproved egress to the API Service. |
| 10-delete-client.sh | Build It, Step 5 | Runnable | Delete the test client Pod after retaining the result. |
| 11-break-readiness.sh | Break It Deliberately | Runnable | Change only the readiness path and confirm the rollout stalls. |
| 12-diagnose-rollout.sh | Break It Deliberately | Runnable | Inspect deployment state, events, and logs before restoring the file. |
| 13-restore-workload.sh | Break It Deliberately | Runnable | Restore the reviewed declaration and wait for recovery. |
| 14-inventory-namespace.sh | Cost and Cleanup | Runnable | Prove ownership and inventory every namespaced resource before deletion. |
| 15-delete-namespace.sh | Cost and Cleanup | Runnable | Delete the reference-dev Namespace after explicit confirmation. |

## Referenced configuration files

The chapter's blocks reference manifests that this repository already keeps under `deployment/kubernetes/` - `base/namespace.yaml`, `base/workload.yaml`, `base/network-policy.yaml`, and `tests/client.yaml`; do not duplicate them here.
The chapter also prints `deployment/kubernetes/tests/connect.py` as a Python block used by scripts 08 and 09; it ships here under that path.

## What does not behave as printed here

- **06 applies the Service with the policy and the workload.**
  The Service is a separate file from the Deployment, and the step
  that follows reaches `/ready` through it, so all three are applied
  together. The namespace is not: the step before this one proves
  namespace ownership by UID, and re-applying it would defeat that.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-namespace.yaml` | Step 1 - Establish ownership, then declare the workload | the namespace declaration | `deployment/kubernetes/base/namespace.yaml` |
| `config/02-workload.yaml` | Stop here until a named reviewer approves this exact Namespace diff. | the hardened workload | `deployment/kubernetes/base/workload.yaml` |
| `config/03-network-policy.yaml` | Step 2 - Restrict who may reach the application | the network policy | `deployment/kubernetes/base/network-policy.yaml` |
| `config/04-client.yaml` | Step 5 - Prove allowed and denied access | the access-test client | `deployment/kubernetes/tests/client.yaml` |
