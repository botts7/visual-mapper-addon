# Base image (replaces build.yaml, which Supervisor has deprecated).
# Supervisor passes BUILD_ARCH; CI may still pass BUILD_FROM explicitly.
ARG BUILD_ARCH=amd64
ARG BUILD_FROM=ghcr.io/home-assistant/${BUILD_ARCH}-base:3.18
FROM ${BUILD_FROM}

LABEL \
    org.opencontainers.image.title="Visual Mapper" \
    org.opencontainers.image.description="Android device control and sensor creation for Home Assistant" \
    org.opencontainers.image.source="https://github.com/botts7/visual-mapper-addon" \
    org.opencontainers.image.documentation="https://github.com/botts7/visual-mapper" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.vendor="botts7"

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    android-tools \
    wget \
    jq \
    bash \
    libusb \
    udev \
    lsof

# NOTE: Coral Edge TPU is NOT supported in the HA addon for two reasons:
# 1. Alpine Linux uses musl libc, but libedgetpu/pycoral require glibc (Debian/Ubuntu)
# 2. USB Coral can only be used by one container at a time (e.g., Frigate)
# For Coral TPU support, run the ML Training Server standalone on a Debian-based system

# Set working directory
WORKDIR /app

# Copy add-on requirements
COPY requirements.txt /tmp/requirements-addon.txt

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements-addon.txt

# Cache buster - change this value to force rebuild of all subsequent layers
ARG CACHE_BUST=20261116092232
RUN echo "Cache bust: $CACHE_BUST"

# Copy application files directly (no more git clone - files are embedded in addon repo)
# This ensures what you push is exactly what gets deployed
COPY backend/ /app/
COPY frontend/ /app/frontend/
COPY config/ /app/config/
COPY .build-version /app/

# Copy run script to root
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Expose port
EXPOSE 8080

CMD [ "/run.sh" ]
