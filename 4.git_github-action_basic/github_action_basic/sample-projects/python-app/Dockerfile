# Stage 1: Base Python image (slim = smaller download size)
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Copy dependency file first (Docker layer caching — faster rebuilds)
COPY requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Document the port the app listens on
EXPOSE 8000

# Run with Gunicorn (production-style WSGI server)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "app:app"]
