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
    bash

# Set working directory
WORKDIR /app

# Copy add-on requirements first (minimal, no opencv)
COPY requirements.txt /tmp/requirements-addon.txt

# CACHE BUSTER: Copy version file - when this changes, all subsequent layers are rebuilt
COPY version.txt /tmp/version.txt

# Clone the main Visual Mapper repository (fresh copy every build)
# Note: Repo must be public for this to work without authentication
# GIT_TERMINAL_PROMPT=0 ensures no interactive prompts in CI
RUN VERSION=$(cat /tmp/version.txt) && \
    echo "Building Visual Mapper version: $VERSION" && \
    rm -rf /tmp/visual-mapper && \
    GIT_TERMINAL_PROMPT=0 git clone --depth 1 https://github.com/botts7/visual-mapper.git /tmp/visual-mapper

# Copy application files from cloned repo
RUN cp -r /tmp/visual-mapper/backend/* /app/ && \
    cp -r /tmp/visual-mapper/frontend /app/ && \
    cp -r /tmp/visual-mapper/config /app/ && \
    cp /tmp/visual-mapper/.build-version /app/ && \
    rm -rf /tmp/visual-mapper

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements-addon.txt

# Copy run script to root
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Expose port
EXPOSE 8080

CMD [ "/run.sh" ]
