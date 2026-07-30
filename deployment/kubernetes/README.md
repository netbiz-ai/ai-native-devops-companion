# Kubernetes exercise

The base declares two non-root replicas, health and readiness probes, bounded
resources, a read-only root filesystem, no service-account token, and a
default-deny policy permitting only the labeled test client.

Before applying, replace the all-zero teaching digest in
`base/kustomization.yaml` with the digest produced for the reviewed source
revision. Validate and inspect the rendered YAML:

```bash
kubectl kustomize deployment/kubernetes/base
kubectl apply --dry-run=server -k deployment/kubernetes/base
kubectl diff -k deployment/kubernetes/base
```

Apply only to an approved disposable cluster. Record policy behavior, the
controlled probe failure, Git-based restoration, workload identity, and
cleanup. A successful API admission is not runtime evidence.
