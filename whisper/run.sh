#!/usr/bin/env bash

# Start Whisper
python3 -m wyoming_faster_whisper \
    --uri 'tcp://0.0.0.0:10300' \
    --data-dir /data \
    --download-dir /data "$@" \
    > /var/log/whisper.log 2>&1 &

# Function to publish Whisper output to MQTT using environment variable
publish_whisper_to_mqtt() {
    local whisper_output
    while true; do
        # Read the latest Whisper output from the log file
        whisper_output=$(tail -n 1 /var/log/whisper.log)

        # Publish Whisper output to MQTT broker using environment variable
        mosquitto_pub -h "$MQTT_BROKER_HOST" -t "whisper/output" -m "$whisper_output"

        sleep 10  # Adjust the interval as needed
    done
}

# Call function to start publishing Whisper output to MQTT
publish_whisper_to_mqtt
