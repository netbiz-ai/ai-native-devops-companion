# GitOps promotion path

Staging reconciles automatically; production deliberately omits automated sync.
Promote the exact reviewed image digest through a pull request, retain the
approval and controller result, then deliberately synchronize production.

Argo CD reconciles from Git, not from your working tree, so `spec.source.repoURL`
in `argocd/staging-application.yaml` and `argocd/production-application.yaml`
must name a repository the cluster can reach and you can push to. The published
value is the upstream companion, which is neither. Use your fork, or the
disposable in-cluster server in `lab-source/` if you have no Git host the
cluster can reach. That directory also lists the three things this repository
cannot supply for you: the cluster, the registry and image digest, and the Git
source.

Because the repository begins private, Argo CD also needs a scoped read-only
repository credential. Do not place that credential in these manifests.

An emergency containment action must be preapproved, recorded, bounded, and
followed by reconciliation back to reviewed Git state.
