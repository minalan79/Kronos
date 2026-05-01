FROM python:3.11-slim

WORKDIR /app

# Copy application files
COPY app/requirements.txt .
COPY app/app.py .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Environment variables
ENV PYTHONUNBUFFERED=1 PORT=5000

EXPOSE 5000

# Run application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--access-logfile", "-", "--error-logfile", "-", "app:app"]