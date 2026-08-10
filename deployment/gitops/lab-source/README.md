# A Git source for the lab

Argo CD reconciles from Git, not from your working tree.
Chapter 9 onward therefore needs a repository that the cluster can reach and
that you can push to, holding your edited copy of `deployment/`.
This directory supplies one, for readers who do not already have a Git host the
cluster can reach.

Use your own host if you have one.
A fork of this repository, or any Git URL Argo CD can resolve, is the better
answer, and a private one needs the scoped read-only credential Chapter 9
describes.
What follows is the fallback, and it is deliberately disposable.

## What it is

`git-server.yaml` declares a namespace `lab-source`, a single-replica
`lab-git` deployment running `git daemon`, and a service on port 9418.
Storage is an `emptyDir`, and the daemon is unauthenticated: anything that can
reach port 9418 can read and write it.
That is acceptable on a disposable lab cluster and nowhere else.
A restarted pod comes back empty, and `seed.sh` refills it.

```bash
kubectl apply -f deployment/gitops/lab-source/git-server.yaml
deployment/gitops/lab-source/seed.sh
```

`seed.sh` pushes the commit you have checked out - not your uncommitted edits -
through `kubectl port-forward`, then prints the two fields to set:

```yaml
repoURL: git://lab-git.lab-source.svc.cluster.local/repo.git
targetRevision: main
```

Set them in `../argocd/staging-application.yaml` and
`../argocd/production-application.yaml`, apply those, and Argo CD reconciles
from your copy.
Commit and re-run `seed.sh` for every later change you want reconciled;
promotion between environments is still the Chapter 9 exercise, and this server
changes nothing about it.

## What you supply either way

The Git source is one of three things this repository cannot contain for you.

| What | Where it goes | Where it comes from |
|---|---|---|
| A disposable cluster | `kubectl` context | Chapter 8; a local `kind` cluster is enough |
| A registry the cluster can pull from, and the image digest in it | `newName` and `digest` in `../../kubernetes/base/kustomization.yaml` | Chapter 4 builds the image, Chapter 6 promotes the digest |
| A Git source Argo CD can reach | `spec.source.repoURL` in `../argocd/*.yaml` | Your own host, or this directory |

The published `digest` is an all-zero placeholder, and an all-zero digest cannot
pull.
That is the intended behavior: an unreplaced value fails at admission rather
than quietly deploying something you never reviewed.

## Verified

On 2026-08-10, on a `kind` cluster running Kubernetes 1.34, this server was
applied, seeded with a commit whose base kustomization named a reachable
registry and digest, and read by an Argo CD `Application`:

```text
NAME               REPO                                                  SYNC     HEALTH
labsource-verify   git://lab-git.lab-source.svc.cluster.local/repo.git   Synced   Healthy

NAME                             STATUS    IMAGE
reference-app-77d864cbff-rbtkb   Running   <registry>/reference-app@sha256:398773f0...
reference-app-77d864cbff-vmfjv   Running   <registry>/reference-app@sha256:398773f0...
```
