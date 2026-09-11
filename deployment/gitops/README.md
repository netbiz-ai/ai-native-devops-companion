# GitOps promotion path

Staging reconciles automatically; production deliberately omits automated sync.
Promote the exact reviewed image digest through a pull request, retain the
approval and controller result, then deliberately synchronize production.

Because the repository begins private, Argo CD also needs a scoped read-only
repository credential. Do not place that credential in these manifests.

An emergency containment action must be preapproved, recorded, bounded, and
followed by reconciliation back to reviewed Git state.
