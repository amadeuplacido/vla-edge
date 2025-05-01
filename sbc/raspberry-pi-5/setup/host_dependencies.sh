#!/bin/bash
# Script to check and install dependencies for the MQTT-ROS2 bridge

# Function to check if a package is installed
check_package() {
    if dpkg -s "$1" >/dev/null 2>&1; then
        echo "$1 is already installed"
        return 0
    else
        echo "$1 is not installed"
        return 1
    fi
}

# Function to check if a Python package is installed
check_pip_package() {
    if pip list | grep -F "$1" >/dev/null 2>&1; then
        echo "Python package $1 is already installed"
        return 0
    else
        echo "Python package $1 is not installed"
        return 1
    fi
}

echo "Checking system dependencies..."

# Check for mosquitto broker
if ! check_package "mosquitto"; then
    echo "Installing mosquitto broker..."
    sudo apt-get update
    sudo apt-get install -y mosquitto
    
    # Configure mosquitto to accept anonymous connections
    echo "Configuring mosquitto to accept anonymous connections..."
    sudo bash -c 'echo "listener 1883" > /etc/mosquitto/conf.d/local.conf'
    sudo bash -c 'echo "allow_anonymous true" >> /etc/mosquitto/conf.d/local.conf'
    
    # Restart mosquitto to apply changes
    sudo systemctl restart mosquitto
    echo "Mosquitto broker installed and configured"
fi

# Check for mosquitto clients
if ! check_package "mosquitto-clients"; then
    echo "Installing mosquitto clients..."
    sudo apt-get update
    sudo apt-get install -y mosquitto-clients
    echo "Mosquitto clients installed"
fi

# Check for pip
if ! command -v pip >/dev/null 2>&1; then
    echo "Installing pip..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
    echo "pip installed"
fi

# Check for paho-mqtt
if ! check_pip_package "paho-mqtt"; then
    echo "Installing paho-mqtt..."
    pip install paho-mqtt
    echo "paho-mqtt installed"
fi

echo "VLA-edge: All dependencies are installed and configured."