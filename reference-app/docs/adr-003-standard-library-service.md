# ADR-003: Use a standard-library HTTP service

Status: accepted for the teaching baseline.

The service uses Python's standard library so its configuration, routing,
adapter, and lifecycle remain inspectable without framework behavior.

This is not a recommendation against frameworks in production. Revisit the
decision when authentication, schema generation, middleware, dependency
injection, or a broader API contract becomes an actual requirement.
