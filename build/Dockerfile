FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN uname -a \
    && apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir \
      fastapi uvicorn transformers torch \
      huggingface_hub[hf_xet]

COPY src/ /app
WORKDIR /app

EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
