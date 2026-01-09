#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

# Read configuration from Home Assistant options
if [ -f "$CONFIG_PATH" ]; then
    export MQTT_BROKER=$(jq -r '.mqtt_broker' $CONFIG_PATH)
    export MQTT_PORT=$(jq -r '.mqtt_port' $CONFIG_PATH)
    export MQTT_USERNAME=$(jq -r '.mqtt_username' $CONFIG_PATH)
    export MQTT_PASSWORD=$(jq -r '.mqtt_password' $CONFIG_PATH)
    export LOG_LEVEL=$(jq -r '.log_level' $CONFIG_PATH)
    echo "Loaded config from $CONFIG_PATH"
else
    echo "No config file found, using defaults"
    export MQTT_BROKER="core-mosquitto"
    export MQTT_PORT="1883"
    export LOG_LEVEL="info"
fi

# IMPORTANT: Use persistent storage directory (survives add-on updates/rebuilds)
# /config is mapped from Home Assistant and persists across container rebuilds
export DATA_DIR="/config/visual_mapper"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/flows"
mkdir -p "$DATA_DIR/sensors"
echo "Using persistent data directory: $DATA_DIR"

echo "Starting Visual Mapper..."
echo "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"

# Start the server
cd /app
exec python3 main.py
