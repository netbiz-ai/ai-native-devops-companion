# Telemetry contract

Bounded route: successful `GET /` requests in `reference-staging`.

Required correlation attributes:

- `service.name=reference-app`
- `service.namespace=ai-native-devops`
- `deployment.environment.name=staging`
- reviewed source revision
- immutable image digest
- GitOps revision
- request or trace identifier where applicable

The baseline Collector uses the debug exporter for local inspection. Replace
it only with reviewed, authenticated destinations and platform-managed
credentials. Do not commit exporter credentials.
