#!/usr/bin/env bash
# The kubernetes lab - CH06, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.uid}{" owner="}{.metadata.annotations.ai-native-devops\.dev/owner-token}{"\n"}'
kubectl get all,networkpolicy \
  --namespace reference-dev
