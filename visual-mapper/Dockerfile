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

# Clone the main Visual Mapper repository
RUN git clone --depth 1 https://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@github.com/botts7/visual-mapper.git /tmp/visual-mapper

# Copy application files from cloned repo
RUN cp -r /tmp/visual-mapper/backend/* /app/ && \
    cp -r /tmp/visual-mapper/frontend /app/ && \
    cp -r /tmp/visual-mapper/config /app/ && \
    rm -rf /tmp/visual-mapper

# Use add-on requirements (not the full requirements from repo)
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements-addon.txt

# Setup s6-overlay v3 service
RUN mkdir -p /etc/s6-overlay/s6-rc.d/visual-mapper && \
    mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d && \
    echo "longrun" > /etc/s6-overlay/s6-rc.d/visual-mapper/type && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/visual-mapper

# Copy run script
COPY run.sh /etc/s6-overlay/s6-rc.d/visual-mapper/run
RUN chmod a+x /etc/s6-overlay/s6-rc.d/visual-mapper/run

# Expose port
EXPOSE 8080
