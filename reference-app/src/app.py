import json
import os
from dataclasses import dataclass
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any, cast
from urllib.parse import urlsplit


@dataclass(frozen=True)
class Settings:
    service_name: str
    environment: str
    host: str
    port: int

    @classmethod
    def from_environment(cls) -> "Settings":
        port_text = os.getenv("APP_PORT", "8080")
        try:
            port = int(port_text)
        except ValueError as exc:
            raise ValueError("APP_PORT must be an integer") from exc
        if not 1 <= port <= 65535:
            raise ValueError("APP_PORT must be between 1 and 65535")
        return cls(
            service_name=os.getenv("APP_NAME", "reference-app"),
            environment=os.getenv("APP_ENV", "local"),
            host=os.getenv("APP_HOST", "127.0.0.1"),
            port=port,
        )


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
        status, payload = route(path, server.settings)
        body = json.dumps(payload, sort_keys=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format: str, *args: Any) -> None:
        message = (format % args).encode("unicode_escape").decode("ascii")
        print(f"http_request: {message}")

    def version_string(self) -> str:
        return "reference-app"


def main() -> None:
    settings = Settings.from_environment()
    server = ApplicationServer((settings.host, settings.port), settings)
    print(
        f"service={settings.service_name} "
        f"environment={settings.environment} "
        f"listening=http://{settings.host}:{settings.port}"
    )
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("shutdown=requested")
    finally:
        server.server_close()
        print("shutdown=complete")


if __name__ == "__main__":
    main()
