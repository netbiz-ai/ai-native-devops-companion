"""OpenTelemetry instrumentation for the reference application.

The metric names this emits are not chosen freely. `observability/recording-rules.yaml`
and `observability/alerts/reference-app.yaml` already query
`http_server_request_duration_seconds_*` with the labels `environment` and
`http_response_status_code`, so the instrument name and its attributes are fixed
by what the rules read. Changing either without changing the rules produces a
dashboard that renders and reports nothing.

Attributes are deliberately bounded. `http.route` is the matched route template
and never the raw path, so a scan for `/wp-admin.php` cannot mint a new time
series per URL. Nothing derived from a request body, query string, or header
reaches an attribute.
"""

from __future__ import annotations

import os
import re
from typing import Any

from opentelemetry import metrics, trace
from opentelemetry.exporter.otlp.proto.http.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.trace import Span, SpanKind

# A W3C trace identifier is 32 lowercase hex characters. The header this module
# emits is checked against this pattern by the chapter's validation script, so
# the pattern is part of the contract rather than a convenience.
TRACE_ID_PATTERN = re.compile(r"^[0-9a-f]{32}$")

_INSTRUMENT_NAME = "http.server.request.duration"

_histogram: metrics.Histogram | None = None
_tracer: trace.Tracer | None = None


def _resource(service_name: str, environment: str) -> Resource:
    """Identity carried on every signal.

    `deployment.environment.name` is the current semantic-convention spelling;
    the Collector maps it to the `environment` label the recording rules group
    by. `service.namespace` distinguishes this app from anything else a reader
    may already run in the same cluster.
    """
    return Resource.create(
        {
            "service.name": service_name,
            "service.namespace": "ai-native-devops",
            "deployment.environment.name": environment,
        }
    )


def configure(service_name: str, environment: str) -> None:
    """Install the providers. Safe to call once per process.

    The OTLP endpoint is read from the standard `OTEL_EXPORTER_OTLP_ENDPOINT`.
    When it is unset the SDK still records spans and metrics in process but
    exports nowhere, which is what lets the unit tests assert on instrumentation
    without a Collector listening.
    """
    global _histogram, _tracer

    resource = _resource(service_name, environment)
    endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "").strip()

    tracer_provider = TracerProvider(resource=resource)
    if endpoint:
        tracer_provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter()))
    trace.set_tracer_provider(tracer_provider)

    readers = [PeriodicExportingMetricReader(OTLPMetricExporter())] if endpoint else []
    metrics.set_meter_provider(MeterProvider(resource=resource, metric_readers=readers))

    _tracer = trace.get_tracer("reference-app")
    _histogram = metrics.get_meter("reference-app").create_histogram(
        name=_INSTRUMENT_NAME,
        unit="s",
        description="Duration of inbound HTTP server requests.",
    )


def _ensure_configured() -> None:
    """Configure from the environment if nobody configured us explicitly.

    Instrumentation must never be the reason a request fails. `main()` calls
    `configure()` with the settings it already parsed; this covers every other
    entry point - a test that starts the server directly, or an embedding that
    forgets. Emitting no telemetry is a degraded service. Refusing to serve
    because telemetry was not set up is an outage caused by the observability
    layer, which is the failure this chapter spends its length arguing against.
    """
    if _tracer is None or _histogram is None:
        configure(os.getenv("APP_NAME", "reference-app"), os.getenv("APP_ENV", "local"))


def start_span(method: str, route: str) -> Span:
    """A server span for one request, named by route template rather than path."""
    _ensure_configured()
    assert _tracer is not None
    return _tracer.start_span(
        f"{method} {route}",
        kind=SpanKind.SERVER,
        attributes={"http.request.method": method, "http.route": route},
    )


def record_duration(seconds: float, route: str, status_code: int) -> None:
    """One observation on the histogram the recording rules read."""
    _ensure_configured()
    assert _histogram is not None
    _histogram.record(
        seconds,
        attributes={"http.route": route, "http.response.status_code": status_code},
    )


def trace_id_of(span: Span) -> str:
    """The span's trace identifier as 32 lowercase hex characters.

    Only the trace identifier is returned. Trace flags, trace state and baggage
    are deliberately excluded: the response header exists so a reader can
    correlate one request across three signals, and anything beyond the
    identifier widens that to carrying context off the cluster.
    """
    return format(span.get_span_context().trace_id, "032x")


def shutdown() -> None:
    """Flush exporters. Only meaningful when an endpoint is configured."""
    provider: Any = trace.get_tracer_provider()
    if hasattr(provider, "shutdown"):
        provider.shutdown()
