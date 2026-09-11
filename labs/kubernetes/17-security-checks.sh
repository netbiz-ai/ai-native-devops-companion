#!/usr/bin/env bash
# The kubernetes lab - CH06, Security Checks
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl get pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app \
  -o jsonpath='{range .items[*]}{.metadata.name}{" image="}{.spec.containers[0].image}{" runAsNonRoot="}{.spec.securityContext.runAsNonRoot}{" seccomp="}{.spec.securityContext.seccompProfile.type}{" token="}{.spec.automountServiceAccountToken}{"\n"}{end}'
