# Reference application

The reference app is a standard-library HTTP service with three routes:

- `GET /` returns its public service identity and status.
- `GET /health` reports process liveness.
- `GET /ready` reports startup readiness.
- Unknown routes return a JSON `404`.

Run:

```bash
python3 src/app.py
```

Test:

```bash
python3 -m unittest discover -s tests -p 'test_*.py'
```

Container:

```bash
docker build -t reference-app:local .
docker run --rm -p 8080:8080 reference-app:local
```

The image uses a numeric non-root identity. A local build is not a security or
production-readiness claim; retain the scanner, identity, filesystem, health,
and cleanup evidence from your own environment.
