#!/usr/bin/env bash
# The gitops lab - CH07, Security Checks
#
# Label: Runnable
# --- command as printed, verbatim ---
project=deployment/gitops/argocd/project.yaml
staging=deployment/gitops/argocd/staging-application.yaml
production=deployment/gitops/argocd/production-application.yaml

jsonpath() {
  kubectl patch --local --type merge -p '{}' -f "$1" \
    -o "jsonpath=$2"
}

validate_authority() {
  local candidate_project=$1
  local sources destinations permissions source
  local staging_route production_route

  sources="$(jsonpath "$candidate_project" \
    '{range .spec.sourceRepos[*]}{@}{"\n"}{end}')"
  test "$(printf '%s\n' "$sources" | sed '/^$/d' | wc -l)" -eq 1 \
    || return 1
  source="$(printf '%s\n' "$sources" | sed '/^$/d')"

  destinations="$(jsonpath "$candidate_project" \
    '{range .spec.destinations[*]}{.server}{"\t"}{.namespace}{"\n"}{end}' \
    | sort)"
  test "$destinations" = "$(printf '%s\n' \
    $'https://kubernetes.default.svc\treference-production' \
    $'https://kubernetes.default.svc\treference-staging' | sort)" \
    || return 1

  permissions="$({
    jsonpath "$candidate_project" \
      '{range .spec.clusterResourceWhitelist[*]}cluster{"\t"}{.group}{"\t"}{.kind}{"\n"}{end}'
    jsonpath "$candidate_project" \
      '{range .spec.namespaceResourceWhitelist[*]}namespaced{"\t"}{.group}{"\t"}{.kind}{"\n"}{end}'
  } | sort)"
  test "$permissions" = "$(printf '%s\n' \
    $'cluster\t\tNamespace' \
    $'namespaced\t\tService' \
    $'namespaced\tapps\tDeployment' \
    $'namespaced\tnetworking.k8s.io\tNetworkPolicy' | sort)" \
    || return 1

  staging_route="$(jsonpath "$staging" \
    '{.spec.source.repoURL}{"\t"}{.spec.source.path}{"\t"}{.spec.destination.server}{"\t"}{.spec.destination.namespace}{"\t"}{.spec.project}')"
  production_route="$(jsonpath "$production" \
    '{.spec.source.repoURL}{"\t"}{.spec.source.path}{"\t"}{.spec.destination.server}{"\t"}{.spec.destination.namespace}{"\t"}{.spec.project}')"
  test "$staging_route" = "$source"$'\tdeployment/gitops/overlays/staging\thttps://kubernetes.default.svc\treference-staging\tai-native-devops' \
    || return 1
  test "$production_route" = "$source"$'\tdeployment/gitops/overlays/production\thttps://kubernetes.default.svc\treference-production\tai-native-devops' \
    || return 1

  test "$(jsonpath "$staging" \
    '{.spec.syncPolicy.automated.prune}{"\t"}{.spec.syncPolicy.automated.selfHeal}')" \
    = $'true\ttrue' || return 1
  test -z "$(jsonpath "$production" '{.spec.syncPolicy.automated}')" \
    || return 1
}

(
set -euo pipefail

validate_authority "$project"

if grep -R -nE '(^|[^-[:alnum:]])(password|token|privateKey):' \
  deployment/gitops/; then
  echo 'STOP: possible credential material in GitOps declarations' >&2
else
  echo 'PASS: routes, policies, and exact authority sets match the design'
fi
)
