FROM python:3.11-slim

WORKDIR /app

# Install system dependencies including build tools for compiling Python packages
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    g++ \
    make \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt requirements-test.txt ./
RUN pip install --no-cache-dir -r requirements.txt -r requirements-test.txt

# Remove build tools to reduce image size
RUN apt-get purge -y \
    gcc \
    g++ \
    make \
    python3-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=150s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run the backend service
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
