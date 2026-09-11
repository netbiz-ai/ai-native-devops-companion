#!/usr/bin/env bash
# The gitops lab - CH07, Security Checks
#
# Label: Runnable - changes only temporary files
# --- command as printed, verbatim ---
(
expect_authority_rejection() {
  if validate_authority "$1"; then
    echo "STOP: authority mutation passed: $1" >&2
    exit 1
  fi
  echo "EXPECTED FAILURE: $1"
}

cp "$project" /tmp/project-extra-source.yaml
sed -i '/sourceRepos:/a\    - https://example.invalid/extra.git' \
  /tmp/project-extra-source.yaml
expect_authority_rejection /tmp/project-extra-source.yaml

cp "$project" /tmp/project-extra-destination.yaml
sed -i '/destinations:/a\    - namespace: reference-extra\n      server: https://kubernetes.default.svc' \
  /tmp/project-extra-destination.yaml
expect_authority_rejection /tmp/project-extra-destination.yaml

cp "$project" /tmp/project-extra-kind.yaml
sed -i '/namespaceResourceWhitelist:/a\    - group: ""\n      kind: ConfigMap' \
  /tmp/project-extra-kind.yaml
expect_authority_rejection /tmp/project-extra-kind.yaml

rm -f /tmp/project-extra-source.yaml \
  /tmp/project-extra-destination.yaml \
  /tmp/project-extra-kind.yaml
)
