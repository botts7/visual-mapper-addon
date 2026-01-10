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

# Cache bust: changing this value forces fresh git clone
ARG CACHEBUST=0.0.73

# Clone the main Visual Mapper repository (fresh copy)
RUN echo "Cloning version: $CACHEBUST" && \
    git clone --depth 1 https://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@github.com/botts7/visual-mapper.git /tmp/visual-mapper

# Copy application files from cloned repo
RUN cp -r /tmp/visual-mapper/backend/* /app/ && \
    cp -r /tmp/visual-mapper/frontend /app/ && \
    cp -r /tmp/visual-mapper/config /app/ && \
    rm -rf /tmp/visual-mapper

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements-addon.txt

# Copy run script to root
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Expose port
EXPOSE 8080

CMD [ "/run.sh" ]
