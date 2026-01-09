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

# Clone the main Visual Mapper repository
RUN git clone --depth 1 https://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@github.com/botts7/visual-mapper.git /tmp/visual-mapper

# Copy application files from cloned repo
RUN cp -r /tmp/visual-mapper/backend/* /app/ && \
    cp -r /tmp/visual-mapper/frontend /app/ && \
    cp -r /tmp/visual-mapper/config /app/ && \
    rm -rf /tmp/visual-mapper

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r /app/requirements.txt

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Expose port
EXPOSE 8080

CMD [ "/run.sh" ]
