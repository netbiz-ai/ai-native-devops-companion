import json
import os
import sys
import threading
import unittest
from pathlib import Path
from unittest.mock import patch
from urllib.error import HTTPError
from urllib.request import urlopen

sys.path.insert(0, str(Path(__file__).parents[1] / "src"))

from app import ApplicationServer, Settings, route  # noqa: E402


class SettingsTests(unittest.TestCase):
    def test_defaults(self) -> None:
        with patch.dict(os.environ, {}, clear=True):
            settings = Settings.from_environment()
        self.assertEqual(settings.service_name, "reference-app")
        self.assertEqual(settings.environment, "local")
        self.assertEqual(settings.host, "127.0.0.1")
        self.assertEqual(settings.port, 8080)

    def test_environment_override(self) -> None:
        values = {
            "APP_NAME": "demo",
            "APP_ENV": "test",
            "APP_HOST": "0.0.0.0",
            "APP_PORT": "9090",
        }
        with patch.dict(os.environ, values, clear=True):
            settings = Settings.from_environment()
        self.assertEqual(settings, Settings("demo", "test", "0.0.0.0", 9090))

    def test_non_integer_port_fails(self) -> None:
        with patch.dict(os.environ, {"APP_PORT": "eight"}, clear=True):
            with self.assertRaisesRegex(ValueError, "integer"):
                Settings.from_environment()

    def test_out_of_range_port_fails(self) -> None:
        for value in ("0", "65536"):
            with self.subTest(value=value):
                with patch.dict(os.environ, {"APP_PORT": value}, clear=True):
                    with self.assertRaisesRegex(ValueError, "between"):
                        Settings.from_environment()


class RouteTests(unittest.TestCase):
    settings = Settings("reference-app", "test", "127.0.0.1", 8080)

    def test_root_contract(self) -> None:
        status, body = route("/", self.settings)
        self.assertEqual(status, 200)
        self.assertEqual(
            body,
            {"service": "reference-app", "environment": "test", "status": "ok"},
        )

    def test_health_contract(self) -> None:
        self.assertEqual(route("/health", self.settings), (200, {"status": "healthy"}))

    def test_ready_contract(self) -> None:
        self.assertEqual(route("/ready", self.settings), (200, {"status": "ready"}))

    def test_unknown_route_is_json_404(self) -> None:
        self.assertEqual(
            route("/missing", self.settings),
            (404, {"error": "not_found", "path": "/missing"}),
        )


class HTTPAdapterTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        settings = Settings("reference-app", "test", "127.0.0.1", 8080)
        cls.server = ApplicationServer(("127.0.0.1", 0), settings)
        cls.thread = threading.Thread(target=cls.server.serve_forever, daemon=True)
        cls.thread.start()
        cls.base_url = f"http://127.0.0.1:{cls.server.server_port}"

    @classmethod
    def tearDownClass(cls) -> None:
        cls.server.shutdown()
        cls.server.server_close()
        cls.thread.join(timeout=2)

    def get_json(self, path: str) -> tuple[int, dict]:
        try:
            with urlopen(self.base_url + path, timeout=2) as response:
                return response.status, json.load(response)
        except HTTPError as exc:
            return exc.code, json.load(exc)

    def test_real_http_root_and_query(self) -> None:
        status, body = self.get_json("/?probe=1")
        self.assertEqual(status, 200)
        self.assertEqual(body["status"], "ok")
        self.assertNotIn("host", body)

    def test_real_http_404_and_server_banner(self) -> None:
        status, body = self.get_json("/does-not-exist")
        self.assertEqual(status, 404)
        self.assertEqual(body["error"], "not_found")
        request = __import__("urllib.request", fromlist=["Request"]).Request(
            self.base_url + "/health"
        )
        with urlopen(request, timeout=2) as response:
            self.assertNotIn("Python", response.headers.get("Server", ""))


if __name__ == "__main__":
    unittest.main()
