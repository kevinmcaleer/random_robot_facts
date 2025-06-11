FROM python:3.13-slim

WORKDIR /app

# Install dependencies to download and unpack uv, then clean up
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl -Ls https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-unknown-linux-gnu.zip -o uv.zip && \
    unzip uv.zip && \
    mv uv /usr/local/bin/uv && \
    chmod +x /usr/local/bin/uv && \
    rm uv.zip && \
    apt-get purge -y curl unzip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt /app/

# Install Python dependencies using uv
RUN uv pip install -r requirements.txt

# Copy your application code
COPY . /app

EXPOSE 8000

CMD ["uvicorn", "random_fact:app", "--host", "0.0.0.0", "--port", "8000"]
