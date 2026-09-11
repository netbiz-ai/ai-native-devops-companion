# Reconstructed from the exit-code contract that labs/kubernetes/08 and 09 require;
# the book prints this block but the repository does not ship it. Exit 42 means
# the connection was established; exit 0 with an EXPECTED_NETWORK_FAILURE line
# means the connection was refused, filtered, or timed out.
import socket
import sys

host = sys.argv[1]
port = int(sys.argv[2])

try:
    with socket.create_connection((host, port), 3):
        print(f"UNEXPECTED_CONNECTION_SUCCEEDED: {host}:{port}")
        sys.exit(42)
except OSError as exc:
    print(f"EXPECTED_NETWORK_FAILURE: {host}:{port}: {exc}")
    sys.exit(0)
