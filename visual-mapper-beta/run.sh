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
    # Port is fixed at 18085 internally - users can map to different external port via HA Network settings
    export SERVER_PORT=18085
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
    export SERVER_PORT="18085"
    export MQTT_BROKER="core-mosquitto"
    export MQTT_PORT="1883"
    export LOG_LEVEL="debug"  # Default to debug for beta
    export ML_TRAINING_MODE="disabled"
fi

# Use /data for addon storage - this gets deleted when addon is uninstalled
# with "permanently delete data" option checked
export DATA_DIR="/data"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/flows"
mkdir -p "$DATA_DIR/sensors"
mkdir -p "$DATA_DIR/ml"
echo "Using data directory: $DATA_DIR (deleted on uninstall with 'delete data' option)"

# Use configurable port for beta (default 18085 to avoid conflict with stable on 8080)
# main.py reads PORT environment variable
export PORT=${SERVER_PORT:-18085}

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

# Kill any existing python processes (from previous run)
pkill -9 -f "python3 main.py" 2>/dev/null || true
pkill -9 -f "ml_training_server.py" 2>/dev/null || true

# Try multiple methods to free the port
if command -v fuser &> /dev/null; then
    echo "Killing processes on port ${PORT} with fuser..."
    fuser -k ${PORT}/tcp 2>/dev/null || true
fi

if command -v lsof &> /dev/null; then
    PIDS=$(lsof -ti:${PORT} 2>/dev/null || true)
    if [ -n "$PIDS" ]; then
        echo "Killing PIDs on port ${PORT}: $PIDS"
        echo "$PIDS" | xargs -r kill -9 2>/dev/null || true
    fi
fi

# Wait for port to be released (TIME_WAIT can take a few seconds)
echo "Waiting for port ${PORT} to be released..."
for i in 1 2 3 4 5; do
    if ! ss -tlnp 2>/dev/null | grep -q ":${PORT} " && \
       ! netstat -tlnp 2>/dev/null | grep -q ":${PORT} "; then
        echo "Port ${PORT} is free"
        break
    fi
    echo "  Port still in use, waiting... ($i/5)"
    sleep 2
done

cd /app

# Start ML Training Server if mode is "local"
if [ "$ML_TRAINING_MODE" = "local" ]; then
    echo "Starting ML Training Server in background..."

    ML_ARGS="--broker $MQTT_BROKER --port $MQTT_PORT --data-dir $DATA_DIR"

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
