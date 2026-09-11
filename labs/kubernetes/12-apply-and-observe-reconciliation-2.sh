#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 4 - Apply and Observe Reconciliation
#
# Label: Runnable
#
# Expected result, per the chapter:
#   deployment "reference-app" successfully rolled out
#   Two application Pods report Running and Ready.
#   Each application endpoint address reports ready=true.
# --- command as printed, verbatim ---
kubectl apply -k deployment/kubernetes/base
kubectl rollout status deployment/reference-app \
  --namespace reference-dev \
  --timeout=120s
kubectl get deployment,pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app \
  --output=wide
kubectl get endpointslice \
  --namespace reference-dev \
  --selector kubernetes.io/service-name=reference-app \
  -o jsonpath='{range .items[*].endpoints[*]}{.addresses[0]}{" ready="}{.conditions.ready}{"\n"}{end}'
