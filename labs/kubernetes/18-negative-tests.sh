#!/usr/bin/env bash
# The kubernetes lab - CH06, Negative Tests
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Error from server (Forbidden): the Pod violates the Restricted policy.
# --- command as printed, verbatim ---
kubectl apply --dry-run=server --validate=strict -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: restricted-negative
  namespace: reference-dev
spec:
  containers:
    - name: test
      image: invalid.invalid/test:never
      securityContext:
        allowPrivilegeEscalation: true
EOF
