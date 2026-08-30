# Chapter 9 lab commands - GitOps and Platform Automation

These are the chapter's commands exactly as the book prints them.

| File | Book section | Label | Purpose |
|---|---|---|---|
| 01-check-preflight.sh | Prerequisites | Runnable | Stop-or-proceed preflight for the cluster, Argo CD client, and repository access. |
| 02-apply-namespaces.sh | Build It, Step 1 | Runnable | Verify namespace owner tokens, dry-run, then create both owned namespaces. |
| 03-render-overlays.sh | Build It, Step 1 | Runnable | Render both overlays, assert the verified digests, and server dry-run the output. |
| 04-dryrun-project.sh | Build It, Step 2 | Runnable | Server dry-run the bounded AppProject. |
| 05-push-gitops-branch.sh | Build It, Step 3 | Runnable | Publish the GitOps declarations on a review branch. |
| 06-apply-controller.sh | Build It, Step 3 | Runnable | Create the AppProject and both Applications, then inspect controller state. |
| 07-push-promotion.sh | Build It, Step 4 | Runnable | Stage and push the production digest promotion for review. |
| 08-sync-production.sh | Build It, Step 4 | Runnable | Pin the approved revision, sync production, and verify rollout and image identity. |
| 09-validate-production.sh | Test and Validate | Runnable | Gather controller, scope, history, and runtime evidence. |
| 10-exercise-drift.sh | Break It Deliberately | Runnable | Inject replica drift in staging and watch self-heal restore the Git value. |
| 11-diagnose-outofsync.sh | Troubleshooting - remains OutOfSync | Runnable | Diagnose an application that stays OutOfSync. |
| 12-diagnose-unhealthy.sh | Troubleshooting - Synced but not Healthy | Runnable | Diagnose Pods that cannot become ready after a sync. |
| 13-diagnose-rejection.sh | Troubleshooting - controller rejects a resource | Runnable | Diagnose an AppProject scope rejection. |
| 14-inventory-resources.sh | Cost and Cleanup | Runnable | Inventory application finalizers, namespaces, and external resources. |
| 15-delete-applications.sh | Cost and Cleanup | Runnable | Non-cascading application deletion, then delete the owned namespaces. |
| 16-delete-project.sh | Cost and Cleanup | Runnable | Remove the AppProject once no application references it. |

The chapter prints several configuration fences (the base kustomization, overlay namespaces and kustomizations, the AppProject, and the Application manifests).
Those already exist as real files in this repository under `deployment/kubernetes/base/` and `deployment/gitops/` (overlays and `argocd/`); they are not duplicated here.

Several scripts reference placeholders the book tells you to replace before running: the repository URL `https://git.example/platform/ai-native-devops.git`, the registry `registry.example.invalid`, and the `REPLACE_ME` / `REPLACE_WITH` digest and owner tokens, plus the `STAGING_DIGEST` and `PRODUCTION_DIGEST` environment variables.

## What does not behave as printed here

- **The scripts name Argo CD objects that this repository does not define.**
  Six blocks - 06, 08, 09, 10, 13 and 15 - address `reference-app-staging`,
  `reference-app-production` and AppProject `reference-app`. The manifests under
  `deployment/gitops/argocd/` define `reference-staging`, `reference-production`
  and `ai-native-devops`. None of those blocks sets `-e`, so each prints an
  error and carries on, and the `kubectl` half of the same script succeeds -
  which reads as partial success rather than a wrong name. Note that a wrong
  Application name comes back as `PermissionDenied`, not `NotFound`, so it looks
  like an RBAC problem. Substitute the real names and every command works.

- **03 asserts a registry this tree does not use.** It greps the rendered
  overlays for `registry.example.invalid/reference-app@$DIGEST`. The image comes
  from `deployment/kubernetes/base/kustomization.yaml`, so the assertion cannot
  match and the block exits 1. Assert the digest against the registry you set
  there.

- **07 asserts a digest line the production overlay does not have, and there is
  no digest to promote.** `overlays/production/kustomization.yaml` carries no
  `images:` block; it inherits the image from the base, so staging and
  production render the *same* digest. The grep for `digest: $STAGING_DIGEST`
  fails, and the promotion the chapter is teaching has no difference to promote
  until you give the overlays their own digests. 07 also stages
  `docs/promotions/reference-app-production.md`, which does not exist.

- **08 requires a push even on the repository's own fallback.** It compares
  local `HEAD` with `git ls-remote origin refs/heads/main` and stops if they
  differ. `deployment/gitops/lab-source/` publishes through the API server
  rather than through a push, so a reader using it has no matching remote and
  the block refuses. Seed the source and sync against the revision `seed.sh`
  prints.

## Configuration blocks

The chapter's **Configuration** blocks ship in `config/`, one file per printed block, in book order, body verbatim - copy a file to its destination rather than retype it.
Where a live version of the same file ships in this repository, the table names it; the live file is canonical per `docs/chapter-map.md`, and the config copy is what the page prints.

| File | Book section | Goes to | Live file here |
|---|---|---|---|
| `config/01-base-kustomization.yaml` | Step 1 - Adapt the Chapter 8 base and create namespaces | the base kustomization | `deployment/kubernetes/base/kustomization.yaml` |
| `config/02-staging-namespace.yaml` | Step 1 - Adapt the Chapter 8 base and create namespaces | `overlays/staging/namespace.yaml` | - |
| `config/03-staging-kustomization.yaml` | Step 1 - Adapt the Chapter 8 base and create namespaces | `overlays/staging/kustomization.yaml` | `deployment/gitops/overlays/staging/kustomization.yaml` |
| `config/04-argocd-project.yaml` | Step 2 - Bound controller authority | the Argo CD project | `deployment/gitops/argocd/project.yaml` |
| `config/05-argocd-applications.yaml` | Step 3 - Declare staging and production applications | the staging and production applications | `deployment/gitops/argocd/staging-application.yaml` (the live tree splits this into staging- and production-application.yaml) |
