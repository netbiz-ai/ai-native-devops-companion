# syntax=docker/dockerfile:1
FROM python:3.12-alpine AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_HOST=0.0.0.0 \
    APP_PORT=8080

# The base image lags the Alpine package repos between rebuilds, so pull the
# patched OS packages at build time; the Security workflow's image scan gates
# on fixed HIGH/CRITICAL CVEs (e.g. openssl CVE-2026-14456 in libcrypto3 and
# libssl3, fixed in 3.5.8-r0 while the base image still carried 3.5.7-r0).
RUN apk upgrade --no-cache

RUN addgroup -S -g 10001 app && adduser -S -D -H -u 10001 -G app app

WORKDIR /app

# Chapter 10 adds the first runtime dependencies this image has ever carried.
# Installed before the source is copied so a source edit does not invalidate
# the dependency layer, and with --no-cache-dir so the wheel cache does not
# ship to production inside the image.
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY --chown=10001:10001 src/ /app/

USER 10001:10001
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health', timeout=2)"]

ENTRYPOINT ["python", "app.py"]
