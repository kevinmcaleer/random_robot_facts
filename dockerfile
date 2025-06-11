FROM python:3.13-slim

WORKDIR /app

# Install curl and CA certs, download uv prebuilt binary for ARM64, install it, then clean up
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    curl -L https://github.com/astral-sh/uv/releases/download/0.7.10/uv-aarch64-unknown-linux-gnu.tar.gz -o uv.tar.gz && \
    tar -xzf uv.tar.gz && \
    mv uv /usr/local/bin/uv && \
    chmod +x /usr/local/bin/uv && \
    rm uv.tar.gz && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies using uv
COPY requirements.txt /app/
RUN uv pip install -r requirements.txt

# Copy application code
COPY . /app

# Expose port 8000
EXPOSE 8000

# Start the app with uvicorn
CMD ["uvicorn", "random_fact:app", "--host", "0.0.0.0", "--port", "8000"]
