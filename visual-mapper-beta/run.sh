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
    echo "=== Config file contents ==="
    cat $CONFIG_PATH
    echo ""
    echo "=============================="
    # Port is fixed at 8082 internally - users can map to different external port via HA Network settings
    export SERVER_PORT=8082
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
    export SERVER_PORT="8082"
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

# Use configurable port for beta (default 8082 to avoid conflict with stable on 8080)
# main.py reads PORT environment variable
export PORT=${SERVER_PORT:-8082}

echo "Starting Visual Mapper BETA..."
echo "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"
echo "ML Training Mode: ${ML_TRAINING_MODE}"
echo "Server Port: ${PORT}"

# Debug: Show all listening ports
echo "=== Debug: All listening ports ==="
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || echo "  (ss/netstat not available)"
echo "==================================="

# Kill any orphaned Python processes that might be holding the port
echo "Checking for port ${PORT}..."

# Check with multiple tools
if command -v ss &> /dev/null; then
    echo "ss check for port ${PORT}:"
    ss -tlnp | grep ":${PORT}" || echo "  (none found)"
fi

if command -v lsof &> /dev/null; then
    echo "lsof check for port ${PORT}:"
    lsof -i:${PORT} 2>/dev/null || echo "  (none found)"

    # Try to kill any process holding the port
    PIDS=$(lsof -ti:${PORT} 2>/dev/null || true)
    if [ -n "$PIDS" ]; then
        echo "Killing PIDs: $PIDS"
        echo "$PIDS" | xargs -r kill -9 2>/dev/null || true
        sleep 2
    fi
fi

# Wait a moment for any cleanup
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
