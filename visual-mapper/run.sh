#!/command/with-contenv bash
set -e

CONFIG_PATH=/data/options.json

# Read configuration from Home Assistant options
export MQTT_BROKER=$(jq -r '.mqtt_broker' $CONFIG_PATH)
export MQTT_PORT=$(jq -r '.mqtt_port' $CONFIG_PATH)
export MQTT_USERNAME=$(jq -r '.mqtt_username' $CONFIG_PATH)
export MQTT_PASSWORD=$(jq -r '.mqtt_password' $CONFIG_PATH)
export LOG_LEVEL=$(jq -r '.log_level' $CONFIG_PATH)

echo "Starting Visual Mapper..."
echo "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"

# Start the server
cd /app
exec python3 main.py
