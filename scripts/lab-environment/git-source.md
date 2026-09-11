# The Git source Argo CD reconciles from

The GitOps chapter's Argo CD pulls manifests from a Git URL.
The URL shipped in this repository's manifests is the in-cluster lab server of option B, so option A is the one that needs edits: you supply your own URL and change it in exactly two files:

- `spec.source.repoURL` in both `deployment/gitops/argocd/staging-application.yaml` and `deployment/gitops/argocd/production-application.yaml`
- the same URL in `spec.sourceRepos` in `deployment/gitops/argocd/project.yaml`

All three lines must carry the same URL, or the Argo CD project refuses the source.

## Option A: fork on GitHub (recommended)

```bash
gh repo fork netbiz-ai/ai-native-devops-companion --clone
cd ai-native-devops-companion
```

Then put your fork's URL in the three lines above, commit, and push.
Every later change you want reconciled is a commit and a push - the ordinary GitOps loop, and the closest match to what the book describes.

## Option B: an in-cluster Git server

If your cluster cannot reach GitHub, `deployment/gitops/lab-source/` supplies a disposable Git server that runs inside the cluster; its [README](../../deployment/gitops/lab-source/README.md) states the trade-offs.

```bash
kubectl apply -f deployment/gitops/lab-source/git-server.yaml
deployment/gitops/lab-source/seed.sh
```

`seed.sh` publishes the commit you have checked out - not your uncommitted edits - and a restarted server pod needs seeding again.
