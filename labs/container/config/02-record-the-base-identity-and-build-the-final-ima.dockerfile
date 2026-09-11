# syntax=docker/dockerfile:1
ARG PYTHON_BASE=python:3.12-slim

FROM ${PYTHON_BASE} AS builder
WORKDIR /build
COPY requirements.lock ./requirements.lock
RUN python3 -m pip wheel \
    --no-cache-dir \
    --wheel-dir /build/wheels \
    -r requirements.lock
COPY src ./src

FROM ${PYTHON_BASE} AS runtime
ARG PYTHON_BASE
ARG VCS_REF=unknown
ARG SOURCE_URL=unknown

LABEL org.opencontainers.image.title="reference-app" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.source="${SOURCE_URL}" \
      org.opencontainers.image.base.name="${PYTHON_BASE}"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_HOST=0.0.0.0 \
    APP_PORT=8080

RUN groupadd --gid 10001 app \
    && useradd --uid 10001 --gid app --create-home app

WORKDIR /app
COPY --from=builder /build/wheels /tmp/wheels
RUN python3 -m pip install --no-cache-dir /tmp/wheels/* \
    && rm -rf /tmp/wheels
COPY --from=builder --chown=10001:10001 /build/src ./src

USER 10001:10001
EXPOSE 8080
CMD ["python3", "src/app.py"]
