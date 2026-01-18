ARG BUILD_FROM
FROM $BUILD_FROM

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
ARG CACHE_BUST=20260118055656
RUN echo "Cache bust: $CACHE_BUST (BETA)"

# Copy application files directly (no more git clone - files are embedded in addon repo)
# This ensures what you push is exactly what gets deployed
COPY backend/ /app/
COPY frontend/ /app/frontend/
COPY config/ /app/config/
COPY .build-version /app/

# Copy run script to root
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Expose port (8082 for beta to avoid conflict with stable on 8080)
EXPOSE 8082

# Set environment variable to indicate beta build
ENV VISUAL_MAPPER_BETA=true

CMD [ "/run.sh" ]
