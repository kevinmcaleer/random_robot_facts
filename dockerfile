# Use an official Python runtime as a parent image
# Updated to 3.13 on 11 Jun 2025
FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /app

# Install curl to download uv, then clean up
RUN apt-get update && \
    apt-get install -y curl && \
    curl -Ls https://astral.sh/uv/install.sh | bash && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Ensure ~/.cargo/bin is in PATH for uv
ENV PATH="/root/.cargo/bin:$PATH"

# Copy the requirements.txt file into the container at /app
COPY requirements.txt /app/

# Install packages using uv
RUN uv pip install -r requirements.txt

# Copy the rest of your application's code
COPY . /app

# Expose port 8000
EXPOSE 8000

# Run app.py using uvicorn
CMD ["uvicorn", "random_fact:app", "--host", "0.0.0.0", "--port", "8000"]
