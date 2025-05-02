#!/bin/bash
# Script to verify and start the MQTT broker if needed

# Function to check if something is listening on port 1883
check_mqtt_port() {
    if netstat -tuln | grep ":1883 " >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Check if netstat is available
if ! command -v netstat >/dev/null 2>&1; then
    echo "netstat not found, installing net-tools..."
    sudo apt-get update
    sudo apt-get install -y net-tools
fi

echo "Checking if MQTT broker is already running..."

if check_mqtt_port; then
    echo "MQTT broker is already running on port 1883"
else
    echo "No MQTT broker detected on port 1883"
    echo "Starting mosquitto broker..."
    
    # Check if mosquitto is running as a service
    if systemctl is-active --quiet mosquitto; then
        echo "Mosquitto service is active but not listening on port 1883."
        echo "Restarting mosquitto service..."
        sudo systemctl restart mosquitto
    else
        echo "Starting mosquitto service..."
        sudo systemctl start mosquitto
    fi
    
    # Wait a moment for the service to start
    sleep 2
    
    # Verify that mosquitto is now running
    if check_mqtt_port; then
        echo "MQTT broker started successfully"
    else
        echo "Failed to start MQTT broker. Check mosquitto status with:"
        echo "   sudo systemctl status mosquitto"
    fi
fi