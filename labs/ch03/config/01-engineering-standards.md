# Reference application engineering standards

## Contract

- Public routes return JSON with an accurate HTTP status.
- `/health` represents process liveness.
- `/ready` represents readiness for traffic.
- Unknown routes return HTTP 404.

## Configuration

- Runtime settings enter through documented environment variables.
- Secrets never appear in source, logs, tests, or public responses.
- Invalid `APP_PORT` values fail before binding with a useful message.
- An unusable `APP_HOST` fails when the server attempts to bind.

## Validation

- Contract changes require tests.
- AI-generated drafts require line-by-line review.
- A local HTTP check complements, but does not replace, automated tests.

## Scope

- New dependencies require a documented reason.
- Container behavior belongs to Chapter 4.
- Deployment behavior belongs to later delivery and platform chapters.
