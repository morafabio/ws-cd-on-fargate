FROM python:3.11-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

COPY src/requirements.txt /opt/requirements.txt

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /opt/requirements.txt

FROM python:3.11-slim AS app

COPY --from=builder /usr/local /usr/local
COPY src/ /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN adduser --disabled-password --gecos "" appuser && \
    chown -R appuser /app

USER appuser
EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
