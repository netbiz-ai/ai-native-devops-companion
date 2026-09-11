# Contributing

Keep changes small, reviewable, and tied to a chapter contract.

1. Create a branch from `main`.
2. Complete the first-time setup in
   [docs/getting-started.md](docs/getting-started.md#first-time-setup) once,
   then run `./scripts/validate-offline.sh`.
3. Do not commit credentials, Terraform state, kubeconfigs, raw incident data,
   model transcripts containing private data, or generated audit logs.
4. Label examples as runnable, fixture, partial, or design-only.
5. Record the deterministic evidence supporting a claim.

Cloud, cluster, registry, and live-model paths require an accountable owner
and an explicit disposable environment.
