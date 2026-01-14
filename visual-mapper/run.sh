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

# Kill any orphaned Python processes that might be holding the port
# This can happen if the container was not cleanly stopped
PORT=${PORT:-8080}
echo "Checking for orphaned processes on port ${PORT}..."

# First, show what's using the port (for debugging)
if command -v lsof &> /dev/null; then
    echo "Processes on port ${PORT}:"
    lsof -i:${PORT} 2>/dev/null || echo "  (none found)"

    # Try to kill any process holding the port
    PIDS=$(lsof -ti:${PORT} 2>/dev/null || true)
    if [ -n "$PIDS" ]; then
        echo "Killing PIDs: $PIDS"
        echo "$PIDS" | xargs -r kill -9 2>/dev/null || true
        sleep 2
    fi
elif command -v fuser &> /dev/null; then
    fuser -v ${PORT}/tcp 2>/dev/null || echo "  (none found)"
    fuser -k ${PORT}/tcp 2>/dev/null || true
    sleep 2
else
    echo "  Warning: Neither lsof nor fuser available"
fi

# Final check - if port is still in use, wait a bit more
if command -v lsof &> /dev/null; then
    if lsof -ti:${PORT} &>/dev/null; then
        echo "Port ${PORT} still in use, waiting 5 more seconds..."
        sleep 5
    fi
fi

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

# Start the main server
exec python3 main.py
