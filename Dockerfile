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

# Upgrade pip and install yt-dlp
RUN pip install --upgrade pip setuptools wheel \
    && pip install --upgrade "yt-dlp[default,curl-cffi,mutagen,pycryptodomex]"

# Create working directory
WORKDIR /app

# Copy the playlistdl script
COPY playlistdl.py /app/playlistdl.py

# Create volumes for downloads and config
VOLUME /downloads /config

# Default command: run the script
ENTRYPOINT ["python", "/app/playlistdl.py"]
