ARG BUILD_FROM=python:3.11-alpine
FROM $BUILD_FROM

# Install system dependencies
RUN apk add --no-cache \
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

# Install Python dependencies
RUN pip install --no-cache-dir -r /tmp/requirements-addon.txt

# Copy run script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Expose port
EXPOSE 8080

ENTRYPOINT []
CMD [ "/run.sh" ]
