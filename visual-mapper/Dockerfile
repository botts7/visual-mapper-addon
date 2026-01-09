ARG BUILD_FROM
FROM $BUILD_FROM

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    android-tools \
    wget

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

# Copy run script to s6-overlay services directory
COPY run.sh /etc/services.d/visual-mapper/run
COPY finish.sh /etc/services.d/visual-mapper/finish
RUN chmod a+x /etc/services.d/visual-mapper/run /etc/services.d/visual-mapper/finish

# Expose port
EXPOSE 8080
