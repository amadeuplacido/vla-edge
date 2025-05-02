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

# Function to check if Docker image exists
check_docker_image() {
    if docker image inspect "$1" >/dev/null 2>&1; then
        return 0  # Image exists
    else
        return 1  # Image does not exist
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

# Check for Python MQTT client (using system package manager)
if ! check_package "python3-paho-mqtt"; then
    echo "Installing python3-paho-mqtt using apt..."
    sudo apt-get update
    sudo apt-get install -y python3-paho-mqtt
    echo "python3-paho-mqtt installed"
else
    echo "python3-paho-mqtt is already installed"
fi

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed"
    echo "Please install Docker manually following the official instructions:"
    echo "https://docs.docker.com/engine/install/"
    exit 1
else
    echo "Docker is already installed"
fi

# Save the current directory
CURRENT_DIR=$(pwd)

# Navigate to the project root
cd ../../../

# Check for Docker image
if check_docker_image "mqtt_ros_bridge_simple"; then
    echo "Docker image 'mqtt_ros_bridge_simple' already exists"
    
    # Ask if user wants to rebuild the image
    read -p "Do you want to rebuild the Docker image? (y/N): " rebuild
    if [[ $rebuild != "y" && $rebuild != "Y" ]]; then
        echo "Skipping Docker image build."
    else
        # Build Docker image
        echo "Rebuilding Docker image for ROS2 MQTT bridge..."
        
        # Check if Dockerfile exists
        if [ ! -f "./sbc/raspberry-pi-5/setup/Dockerfile" ]; then
            echo "Dockerfile not found in current directory"
            echo "Please make sure you're running this script from the same directory as the Dockerfile."
            cd "$CURRENT_DIR"
            exit 1
        fi
        
        # Build the Docker image
        docker build -t mqtt_ros_bridge_simple -f sbc/raspberry-pi-5/setup/Dockerfile .
        if [ $? -eq 0 ]; then
            echo "Docker image rebuilt successfully"
        else
            echo "Docker image build failed"
            cd "$CURRENT_DIR"
            exit 1
        fi
    fi
else
    # Build Docker image
    echo "Building Docker image for ROS2 MQTT bridge..."
    
    # Build the Docker image
    docker build -t mqtt_ros_bridge_simple -f sbc/raspberry-pi-5/setup/Dockerfile .
    if [ $? -eq 0 ]; then
        echo "Docker image built successfully"
    else
        echo "Docker image build failed"
        cd "$CURRENT_DIR"
        exit 1
    fi
fi

cd "$CURRENT_DIR"
echo "VLA-edge: All dependencies are installed and configured."