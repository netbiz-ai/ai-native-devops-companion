import json
import os
import time
from dataclasses import dataclass
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any, cast
from urllib.parse import urlsplit

import telemetry

# The fault gate accepts a delay from this range and nothing else. An unbounded
# delay is a denial of service the reader would be installing on themselves.
MAX_DELAY_MS = 1000

# Chapter 12's injected latency is allowed to exceed Chapter 10's per-request
# bound, because the incident it stages has to be bad enough to fail a
# readiness probe rather than merely slow. It is still bounded: an unbounded
# value would take the pod out and leave nothing to diagnose.
MAX_INJECTED_LATENCY_MS = 5000

# Environments where the fault gate may never be enabled, whatever the config
# says. The gate exists to break correlation on purpose; a production cluster
# is not a place to do that, and a misapplied overlay should fail closed.
PROTECTED_ENVIRONMENTS = frozenset({"production", "reference-production", "prod"})


def _flag(name: str) -> bool:
    return os.getenv(name, "false").strip().lower() in {"1", "true", "yes"}


def _injected_latency(environment: str) -> int:
    """Chapter 12's injected latency, in milliseconds.

    Refuses outright in a protected environment, and refuses a value it cannot
    read. Chapter 10's per-request header ignores a malformed value because a
    fat-fingered lab header should not fail a real request; this one is the
    opposite case. It arrives through a reviewed deployment change, so an
    unreadable value means the change under review is not the change being
    applied, and starting anyway would leave an operator restoring a fault
    whose size nobody knows.
    """
    raw = os.getenv("CH12_INJECTED_LATENCY_MS", "0").strip()
    if not raw:
        return 0
    try:
        latency = int(raw)
    except ValueError as exc:
        raise ValueError(
            f"CH12_INJECTED_LATENCY_MS must be an integer, got {raw!r}"
        ) from exc
    if latency == 0:
        return 0
    if environment in PROTECTED_ENVIRONMENTS:
        raise ValueError(
            f"CH12_INJECTED_LATENCY_MS must not be set in {environment}; "
            "the incident lab runs in a disposable namespace"
        )
    if not 0 <= latency <= MAX_INJECTED_LATENCY_MS:
        raise ValueError(
            f"CH12_INJECTED_LATENCY_MS must be between 0 and "
            f"{MAX_INJECTED_LATENCY_MS}, got {latency}"
        )
    return latency


@dataclass(frozen=True)
class Settings:
    service_name: str
    environment: str
    host: str
    port: int
    # Both default off. The lab is opt-in, and a Settings built without them -
    # as every test and every environment before Chapter 10 does - must be a
    # normally behaving service.
    omit_trace_id: bool = False
    fault_gate_enabled: bool = False
    # Chapter 12's incident. Unlike Chapter 10's gate, which delays only the
    # requests that ask for it, this delays every request - including the
    # readiness probe. That is the point: it is a deployment-level change that
    # degrades the service for everyone, which is what an incident looks like
    # and what makes restoring it a GitOps action rather than a client choice.
    injected_latency_ms: int = 0

    @classmethod
    def from_environment(cls) -> "Settings":
        port_text = os.getenv("APP_PORT", "8080")
        try:
            port = int(port_text)
        except ValueError as exc:
            raise ValueError("APP_PORT must be an integer") from exc
        if not 1 <= port <= 65535:
            raise ValueError("APP_PORT must be between 1 and 65535")
        environment = os.getenv("APP_ENV", "local")
        fault_gate = _flag("CH10_FAULT_GATE_ENABLED")
        if fault_gate and environment in PROTECTED_ENVIRONMENTS:
            raise ValueError(
                f"CH10_FAULT_GATE_ENABLED must not be set in {environment}; "
                "the gate is a staging-only teaching device"
            )
        return cls(
            service_name=os.getenv("APP_NAME", "reference-app"),
            environment=environment,
            host=os.getenv("APP_HOST", "127.0.0.1"),
            port=port,
            omit_trace_id=_flag("CH10_OMIT_TRACE_ID"),
            fault_gate_enabled=fault_gate,
            injected_latency_ms=_injected_latency(environment),
        )


def requested_delay_ms(header_value: str | None, settings: Settings) -> int:
    """Delay this request should serve, in milliseconds.

    Returns 0 whenever the gate is off, the header is absent, or the value is
    not an integer inside the bounded range. A malformed value is ignored
    rather than rejected: the header is a lab affordance, and failing a real
    request because someone fat-fingered a fault injection teaches nothing.
    """
    if not settings.fault_gate_enabled or header_value is None:
        return 0
    try:
        delay = int(header_value)
    except ValueError:
        return 0
    return delay if 0 <= delay <= MAX_DELAY_MS else 0


def route_template(path: str) -> str:
    """The matched route, or `/unmatched` for anything else.

    Never the raw path. `http.route` is a metric attribute, so returning the
    path would let any scanner mint one time series per URL it probes.
    """
    return path if path in {"/", "/health", "/ready"} else "/unmatched"


def route(path: str, settings: Settings) -> tuple[int, dict[str, Any]]:
    if path == "/":
        return 200, {
            "service": settings.service_name,
            "environment": settings.environment,
            "status": "ok",
        }
    if path == "/health":
        return 200, {"status": "healthy"}
    if path == "/ready":
        return 200, {"status": "ready"}
    return 404, {"error": "not_found", "path": path}


class ApplicationServer(ThreadingHTTPServer):
    def __init__(self, server_address: tuple[str, int], settings: Settings) -> None:
        self.settings = settings
        super().__init__(server_address, RequestHandler)


class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        path = urlsplit(self.path).path
        server = cast(ApplicationServer, self.server)
        settings = server.settings
        template = route_template(path)

        started = time.perf_counter()
        span = telemetry.start_span("GET", template)
        # Bound before the try so the histogram in `finally` still records a
        # value if the handler raises. A request that failed is exactly the one
        # the duration series must not silently omit.
        status = 500
        try:
            # The incident first: it applies to every request, including the
            # readiness probe, so the degradation is the service's and not the
            # caller's. Chapter 10's opt-in delay stacks on top of it, which is
            # what lets a reader keep probing a degraded service.
            if settings.injected_latency_ms:
                time.sleep(settings.injected_latency_ms / 1000)
            delay_ms = requested_delay_ms(self.headers.get("X-CH10-Delay-Ms"), settings)
            if delay_ms:
                time.sleep(delay_ms / 1000)
            status, payload = route(path, settings)
            span.set_attribute("http.response.status_code", status)
            body = json.dumps(payload, sort_keys=True).encode("utf-8")
            self.send_response(status)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            # The header the correlation check reads. CH10_OMIT_TRACE_ID removes
            # it so the reader can watch correlation break while the metric and
            # the log still look healthy - that break is the point of the lab.
            if not settings.omit_trace_id:
                self.send_header("X-Trace-Id", telemetry.trace_id_of(span))
            self.end_headers()
            self.wfile.write(body)
        finally:
            span.end()
            telemetry.record_duration(time.perf_counter() - started, template, status)

    def log_message(self, format: str, *args: Any) -> None:
        message = (format % args).encode("unicode_escape").decode("ascii")
        print(f"http_request: {message}")

    def version_string(self) -> str:
        return "reference-app"


def main() -> None:
    settings = Settings.from_environment()
    telemetry.configure(settings.service_name, settings.environment)
    server = ApplicationServer((settings.host, settings.port), settings)
    print(
        f"service={settings.service_name} "
        f"environment={settings.environment} "
        f"listening=http://{settings.host}:{settings.port} "
        f"fault_gate={'on' if settings.fault_gate_enabled else 'off'} "
        f"trace_header={'omitted' if settings.omit_trace_id else 'on'} "
        f"injected_latency_ms={settings.injected_latency_ms}"
    )
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("shutdown=requested")
    finally:
        server.server_close()
        telemetry.shutdown()
        print("shutdown=complete")


if __name__ == "__main__":
    main()
