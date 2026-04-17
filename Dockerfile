# -----------------------------------------------------------------------------
# RUNTIME (Python + yt-dlp + ffmpeg)
# -----------------------------------------------------------------------------
FROM python:3.12-slim

# Install ffmpeg and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install backend dependencies + yt-dlp
WORKDIR /app

COPY app/requirements.txt /app/requirements.txt

RUN pip install --upgrade pip setuptools wheel \
    && pip install --upgrade "yt-dlp[default,curl-cffi,mutagen,pycryptodomex]" \
    && pip install -r /app/requirements.txt

# Copy backend
COPY app /app

# Copy frontend
COPY web /app/web

# Create volumes for downloads and config
VOLUME /downloads /config

# Expose backend port
EXPOSE 5000

# Run the backend
ENTRYPOINT ["python", "/app/main.py"]
