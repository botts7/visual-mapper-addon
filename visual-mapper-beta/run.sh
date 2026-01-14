#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

# Beta version indicator
echo "=========================================="
echo "  Visual Mapper BETA"
echo "  This is a pre-release version"
echo "=========================================="

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
    export LOG_LEVEL="debug"  # Default to debug for beta
    export ML_TRAINING_MODE="disabled"
fi

# IMPORTANT: Use separate data directory for beta to avoid conflicts with stable
# This allows running both stable and beta simultaneously
export DATA_DIR="/config/visual_mapper_beta"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/flows"
mkdir -p "$DATA_DIR/sensors"
mkdir -p "$DATA_DIR/ml"
echo "Using beta data directory: $DATA_DIR"

# Use port 8081 for beta (to allow running alongside stable on 8080)
# main.py reads PORT environment variable
export PORT=8081

echo "Starting Visual Mapper BETA..."
echo "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"
echo "ML Training Mode: ${ML_TRAINING_MODE}"
echo "Server Port: ${PORT}"

# Kill any orphaned Python processes that might be holding the port
# This can happen if the container was not cleanly stopped
echo "Checking for orphaned processes on port ${PORT}..."
if command -v fuser &> /dev/null; then
    fuser -k ${PORT}/tcp 2>/dev/null || true
elif command -v lsof &> /dev/null; then
    lsof -ti:${PORT} | xargs -r kill -9 2>/dev/null || true
fi
# Give time for port to be released
sleep 1

cd /app

# Start ML Training Server if mode is "local"
if [ "$ML_TRAINING_MODE" = "local" ]; then
    echo "Starting ML Training Server in background..."

    ML_ARGS="--broker $MQTT_BROKER --port $MQTT_PORT"

    if [ -n "$MQTT_USERNAME" ] && [ "$MQTT_USERNAME" != "null" ]; then
        ML_ARGS="$ML_ARGS --username $MQTT_USERNAME"
    fi
    if [ -n "$MQTT_PASSWORD" ] && [ "$MQTT_PASSWORD" != "null" ]; then
        ML_ARGS="$ML_ARGS --password $MQTT_PASSWORD"
    fi
    if [ "$ML_USE_DQN" = "true" ]; then
        ML_ARGS="$ML_ARGS --dqn"
    fi

    # Start ML server in background
    python3 ml_components/ml_training_server.py $ML_ARGS &
    ML_PID=$!
    echo "ML Training Server started with PID: $ML_PID"
fi

# Start the main server (PORT env var is already set to 8081)
exec python3 main.py
