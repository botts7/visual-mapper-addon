#!/usr/bin/with-contenv bashio

# Read configuration from Home Assistant
export MQTT_BROKER=$(bashio::config 'mqtt_broker')
export MQTT_PORT=$(bashio::config 'mqtt_port')
export MQTT_USERNAME=$(bashio::config 'mqtt_username')
export MQTT_PASSWORD=$(bashio::config 'mqtt_password')
export MQTT_DISCOVERY_PREFIX=$(bashio::config 'mqtt_discovery_prefix')
export LOG_LEVEL=$(bashio::config 'log_level')

bashio::log.info "Starting Visual Mapper..."
bashio::log.info "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"

# Start the server
cd /app
exec python3 main.py
