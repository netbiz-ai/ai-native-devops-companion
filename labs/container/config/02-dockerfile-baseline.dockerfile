# syntax=docker/dockerfile:1
FROM python:3.12-slim
WORKDIR /app
COPY . .
ENV APP_HOST=0.0.0.0 \
    APP_PORT=8080
EXPOSE 8080
CMD ["python3", "-m", "src.app"]
