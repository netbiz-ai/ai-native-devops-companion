#!/usr/bin/env bash
# Interlude, Step 2 - prove the network plugin enforces NetworkPolicy
#
# Label: Runnable
# Destructive: creates the policy-check Namespace and three Pods in it on the
# current cluster. 04-delete-policy-check.sh removes them.
#
# Expected result, per the interlude:
#   NetworkPolicy enforcement confirmed.
# --- command as printed, verbatim ---
kubectl create namespace policy-check
kubectl --namespace policy-check run server \
  --image=nginx:1.27-alpine --port=80
kubectl --namespace policy-check wait --for=condition=Ready \
  pod/server --timeout=180s
server_ip=$(kubectl --namespace policy-check get pod server \
  -o jsonpath='{.status.podIP}')

probe() {
  kubectl --namespace policy-check run "$1" \
    --image=busybox:1.36 --restart=Never --command -- \
    wget -q -T 5 -O /dev/null "http://${server_ip}" >/dev/null
  for _ in $(seq 1 60); do
    phase=$(kubectl --namespace policy-check get pod "$1" \
      -o jsonpath='{.status.phase}')
    case "$phase" in
      Succeeded|Failed) echo "$phase"; return ;;
    esac
    sleep 2
  done
  echo Timeout
}

test "$(probe before-policy)" = Succeeded || {
  echo "STOP: the probe could not reach the server before any policy" >&2
  exit 1
}

kubectl --namespace policy-check apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
    - Ingress
EOF

test "$(probe after-policy)" = Failed || {
  echo "STOP: this cluster is not enforcing NetworkPolicy" >&2
  exit 1
}

echo "NetworkPolicy enforcement confirmed."
