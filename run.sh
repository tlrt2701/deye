#!/usr/bin/with-contenv bashio

MQTT_BROKER=$(bashio::config 'mqtt_broker')
MQTT_TOPIC=$(bashio::config 'mqtt_topic_grid')
MODBUS_PORT=$(bashio::config 'modbus_port')

export MQTT_BROKER
export MQTT_TOPIC
export MODBUS_PORT

exec python3 /sdm630_emulator.py
