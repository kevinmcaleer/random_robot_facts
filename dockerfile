FROM python:3.13-slim

WORKDIR /app

# Install curl and unzip, then install uv for aarch64 (Raspberry Pi 64-bit)
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl -Ls https://github.com/astral-sh/uv/releases/latest/download/uv-aarch64-unknown-linux-gnu.zip -o uv.zip && \
    unzip uv.zip && \
    mv uv /usr/local/bin/uv && \
    chmod +x /usr/local/bin/uv && \
    rm uv.zip && \
    apt-get purge -y curl unzip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN uv pip install -r requirements.txt

COPY . /app

EXPOSE 8000

CMD ["uvicorn", "random_fact:app", "--host", "0.0.0.0", "--port", "8000"]
