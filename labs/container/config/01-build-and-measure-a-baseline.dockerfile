# syntax=docker/dockerfile:1
FROM python:3.12-slim
WORKDIR /app
COPY requirements.lock ./requirements.lock
RUN python3 -m pip install --no-cache-dir -r requirements.lock
COPY . .
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_HOST=0.0.0.0 \
    APP_PORT=8080
EXPOSE 8080
CMD ["python3", "src/app.py"]
