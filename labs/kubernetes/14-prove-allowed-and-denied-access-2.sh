#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 5 - Prove Allowed and Denied Access
#
# Label: Runnable
#
# Expected result, per the chapter:
#   {"status": "ready"}
# --- command as printed, verbatim ---
kubectl exec reference-client \
  --namespace reference-dev -- \
  python3 -c \
  'import urllib.request
body = urllib.request.urlopen("http://reference-app/ready", timeout=3).read().decode()
assert body == "{\"status\": \"ready\"}", body
print(body)'
