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
    echo "=== Config options (values hidden) ==="
    jq -r 'keys | join(", ")' $CONFIG_PATH
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

    # Remaining add-on options (previously never reached the backend).
    # Booleans use an explicit null check: jq's // treats false as missing.
    export MQTT_DISCOVERY_PREFIX=$(jq -r '.mqtt_discovery_prefix // "homeassistant"' $CONFIG_PATH)
    export AUTO_START_UPDATES=$(jq -r 'if .auto_start_updates == null then true else .auto_start_updates end' $CONFIG_PATH)
    export LABS_FLOW_CONSOLIDATION=$(jq -r 'if .labs_flow_consolidation == null then false else .labs_flow_consolidation end' $CONFIG_PATH)
    export CONNECTION_CHECK_INTERVAL=$(jq -r '.connection_check_interval // 30' $CONFIG_PATH)
    export CONNECTION_RETRY_ENABLED=$(jq -r 'if .connection_retry_enabled == null then true else .connection_retry_enabled end' $CONFIG_PATH)
    export CONNECTION_MAX_RETRY_DELAY=$(jq -r '.connection_max_retry_delay // 300' $CONFIG_PATH)
    export ADB_DEVICE_IP=$(jq -r '.adb_device_ip // ""' $CONFIG_PATH)
    export ADB_DEVICE_PORT=$(jq -r '.adb_device_port // 5555' $CONFIG_PATH)

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

# Persist the ADB identity (adbkey + wireless pairing metadata) across
# add-on updates and rebuilds. Both the native adb binary and adb_shell
# use ~/.android, which otherwise lives in the replaceable container
# layer, so every update generated a new key and phones had to re-pair.
# /data is private to the add-on and survives updates (and is backed up).
ADB_HOME_PERSIST="/data/.android"
ADB_HOME_LINK="${HOME:-/root}/.android"
mkdir -p "$ADB_HOME_PERSIST"
chmod 700 "$ADB_HOME_PERSIST"
ADB_HOME_OK=1
if [ -d "$ADB_HOME_LINK" ] && [ ! -L "$ADB_HOME_LINK" ]; then
    # Move any key already in this container across, never overwriting a
    # saved one, and only remove the old folder if every copy worked.
    for f in "$ADB_HOME_LINK"/* "$ADB_HOME_LINK"/.[!.]*; do
        [ -e "$f" ] || continue
        [ -e "$ADB_HOME_PERSIST/${f##*/}" ] && continue
        cp -a "$f" "$ADB_HOME_PERSIST"/ || ADB_HOME_OK=0
    done
    if [ "$ADB_HOME_OK" = 1 ]; then
        rm -rf "$ADB_HOME_LINK"
    fi
fi
if [ "$ADB_HOME_OK" = 1 ]; then
    ln -sfn "$ADB_HOME_PERSIST" "$ADB_HOME_LINK"
    chmod 600 "$ADB_HOME_PERSIST"/adbkey 2>/dev/null || true
    echo "ADB identity directory: $ADB_HOME_LINK -> $ADB_HOME_PERSIST"
else
    echo "WARNING: could not move $ADB_HOME_LINK to $ADB_HOME_PERSIST; ADB identity will not persist"
fi

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
