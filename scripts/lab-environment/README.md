# Lab environment: the three things you supply

From the cluster chapters onward the labs need three things that cannot ship in this repository, because they are yours.
`docs/subject-map.md` ("What you supply, and where it goes") defines them; this folder makes each one a copy-paste template.
The chapter numbers moved between editions and these three things did not, so they are named by subject here.
`labs/cluster/` is the reader's path through this folder, one numbered file per block the second edition's Bridge to the Cluster interlude prints.

| # | What | Template | First needed |
|---:|---|---|---|
| 1 | A disposable Kubernetes cluster | `kind-cluster.yaml` + `create-cluster.sh` | the Kubernetes chapter |
| 2 | A registry the cluster can pull from, holding your image digest | `push-image.sh` | the Kubernetes chapter |
| 3 | A Git source Argo CD can reach and you can push to | `git-source.md` | the GitOps chapter |

Create them in that order: the cluster first, then the image, then the Git source.
`delete-cluster.sh` removes everything the first two created, so the cluster stays genuinely disposable.

## 1. The cluster

```bash
./scripts/lab-environment/create-cluster.sh
```

This creates a local [kind](https://kind.sigs.k8s.io/) cluster with a private local registry wired to it, and installs the Calico network plugin.
Calico matters: kind's default network plugin does not enforce the `NetworkPolicy` in `deployment/kubernetes/base/`, so the Kubernetes chapter's policy observations would silently pass on an unenforced cluster.
The book's own reference environment was a kind cluster with Calico.

The cluster and registry names are variables at the top of the script, so a second lab never collides with one you already have.

## 2. The registry and digest

```bash
./scripts/lab-environment/push-image.sh
```

This builds the reference-app image (the container chapter's build), pushes it to the registry from step 1, and prints the exact `newName` and `digest` values to put in `deployment/kubernetes/base/kustomization.yaml`.
The digest shipped in that file is an all-zero placeholder that deliberately fails at admission, so nothing deploys until you replace it with a digest you built and reviewed.

## 3. The Git source

Argo CD reconciles from a Git URL, never from your working tree, and the URL shipped in the manifests is the in-cluster lab server, which is option B below.
`git-source.md` walks through the two options - a fork on GitHub (recommended), or the in-cluster Git server at `deployment/gitops/lab-source/` if your cluster cannot reach one - and names the two files where the URL changes.

## Cleaning up

```bash
./scripts/lab-environment/delete-cluster.sh
```

Deletes the kind cluster and its registry container.
Anything you created in a cloud account (the infrastructure chapter's optional apply route) is outside this script's reach; destroy it with the chapter's own teardown steps.
