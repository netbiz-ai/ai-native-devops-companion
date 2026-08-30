# Interlude lab scripts - Bridge to the Cluster

These are the interlude's commands exactly as the book prints them, one file per bash block, in book order.

The interlude is the unnumbered setup chapter of the second edition, and it has no chapter number of its own.
It stands between the infrastructure chapter and the cluster chapters, and it builds the lab environment every later chapter assumes.
Readers of the first edition reach the same environment through that edition's Bridge to the Cluster section; the scripts here work for both, because they describe the cluster rather than a chapter.

Run every file from the repository root, in order.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-check-prerequisites.sh | Prerequisites | Runnable | Verify the tools, the container runtime, and the launch directory. |
| 02-create-cluster.sh | Step 1 | Runnable | Create the cluster and registry, switch context, confirm the node is Ready. |
| 03-prove-policy-enforcement.sh | Step 2 | Runnable | Reach a server, deny the traffic, and fail to reach it again. |
| 04-delete-policy-check.sh | Step 2 | Runnable | Remove the probe namespace once enforcement is proved. |
| 05-push-image.sh | Step 3 | Runnable | Build and push the reference-app image and record its digest. |
| 06-verify-pull-by-digest.sh | Step 3 | Runnable | Prove the cluster can pull the recorded digest. |
| 07-inspect-git-source.sh | Step 4 | Runnable | Read the three lines that will carry the reader's Git source. Changes nothing. |
| 08-delete-cluster.sh | Step 5 | Runnable | Tear the lab down and confirm both the cluster and the registry are gone. |
| 09-recreate-cluster.sh | Step 5 | Runnable | Build the lab again and re-record the digest. |

## What these scripts wrap

The work is done by [`scripts/lab-environment/`](../../scripts/lab-environment/README.md), which is where the cluster definition, the registry wiring, the Calico install and the teardown live.
The files here are the reader's path through them, in the order the page prints, with the checks the page performs between the steps.
Change the cluster's shape there, not here.

Set `CLUSTER_NAME` if `ai-native-lab` collides with a cluster you already have, and set it for every file in this folder, not just the first: each numbered file is a separate script, so an environment variable exported in one does not carry to the next.

## Referenced configuration files

The NetworkPolicy in `03-prove-policy-enforcement.sh` is a heredoc inside the printed block rather than a separate **Configuration** block, so this folder has no `config/`.
It is a throwaway policy for the probe namespace, and it is deliberately not the one the Kubernetes chapter reviews, which ships at `deployment/kubernetes/base/network-policy.yaml`.

## What does not behave as printed here

- **08 lists other clusters too.**
  `kind get clusters` and `docker ps` list everything on the machine, so a
  reader with another cluster running sees it here. The claim the step makes
  is narrower than the output: `ai-native-lab` and its registry are absent.
- **The digest in 09 matches the one in 05 only if the source did not
  change.** The interlude says so; a differing digest is a finding, not a
  script defect.
