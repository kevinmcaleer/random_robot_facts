FROM python:3.13-slim

WORKDIR /app

# Install curl and tar, then download and install uv for ARM64
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    curl -L https://github.com/astral-sh/uv/releases/latest/download/uv-aarch64-unknown-linux-gnu.tar.gz -o uv.tar.gz && \
    tar -xzf uv.tar.gz && \
    mv uv /usr/local/bin/uv && \
    chmod +x /usr/local/bin/uv && \
    rm uv.tar.gz && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN uv pip install -r requirements.txt

COPY . /app

EXPOSE 8000

CMD ["uvicorn", "random_fact:app", "--host", "0.0.0.0", "--port", "8000"]
