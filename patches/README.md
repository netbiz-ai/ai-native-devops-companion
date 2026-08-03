# Patch fixtures

Merge patches referenced by chapters, kept as files so the printed command
stays inside the page and the payload stays copy-exact.

| File | Used by | Command shape |
|---|---|---|
| `sync-policy.json` | Chapter 9 | `kubectl -n argocd patch application reference-app-staging --type merge --patch-file patches/sync-policy.json` |

Label: fixture. Applying one of these changes cluster state; read it first.
