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
    
    # ML Training options
    export ML_TRAINING_MODE=$(jq -r '.ml_training_mode // "disabled"' $CONFIG_PATH)
    export ML_REMOTE_HOST=$(jq -r '.ml_remote_host // ""' $CONFIG_PATH)
    export ML_REMOTE_PORT=$(jq -r '.ml_remote_port // 8099' $CONFIG_PATH)
    export ML_USE_DQN=$(jq -r '.ml_use_dqn // false' $CONFIG_PATH)
    export ML_BATCH_SIZE=$(jq -r '.ml_batch_size // 64' $CONFIG_PATH)
    export ML_SAVE_INTERVAL=$(jq -r '.ml_save_interval // 60' $CONFIG_PATH)
    
    echo "Loaded config from $CONFIG_PATH"
else
    echo "No config file found, using defaults"
    export MQTT_BROKER="core-mosquitto"
    export MQTT_PORT="1883"
    export LOG_LEVEL="info"
    export ML_TRAINING_MODE="disabled"
fi

# IMPORTANT: Use persistent storage directory (survives add-on updates/rebuilds)
# /config is mapped from Home Assistant and persists across container rebuilds
export DATA_DIR="/config/visual_mapper"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/flows"
mkdir -p "$DATA_DIR/sensors"
mkdir -p "$DATA_DIR/ml"
echo "Using persistent data directory: $DATA_DIR"

echo "Starting Visual Mapper..."
echo "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"
echo "ML Training Mode: ${ML_TRAINING_MODE}"

# Start the server
cd /app
exec python3 main.py
