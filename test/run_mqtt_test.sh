#!/bin/bash
# Script to run all components sequentially and capture logs

# Create a log directory
mkdir -p logs

# Function to check if something is listening on port 1883
check_mqtt_port() {
    if netstat -tuln | grep ":1883 " >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

echo "======== Starting MQTT Broker ========"
# Start MQTT broker in background and redirect logs
./mqtt_broker.sh > logs/mqtt_broker.log 2>&1 &
BROKER_PID=$!

# Wait for MQTT broker to start (check port 1883)
echo "Waiting for MQTT broker to start..."
while ! check_mqtt_port; do
    sleep 1
done
echo "MQTT broker started successfully!"

echo "======== Starting Host Publisher ========"
# Start host publisher in background and redirect logs
./host_mqtt_pub_test.py > logs/host_publisher.log 2>&1 &
PUBLISHER_PID=$!
echo "Host publisher started with PID $PUBLISHER_PID"

echo "======== Building and Starting Docker Container ========"
# Navigate to the Docker directory
cd ../../sbc/raspberry-pi-5/setup

# Run Docker container in background and capture logs
docker run --rm --network=host \
  --add-host=host.docker.internal:host-gateway \
  --name mqtt_ros_container \
  mqtt_ros_bridge > ../../../logs/docker.log 2>&1 &
DOCKER_PID=$!

echo "Docker container started with PID $DOCKER_PID"

# Navigate back to the original directory
cd -

echo "======== Starting Host Subscriber (foreground) ========"
echo "Running subscriber in foreground. Press Ctrl+C to stop all processes when done."
./host_mqtt_sub_test.py

# This part only runs after the user presses Ctrl+C to exit the subscriber
echo "======== Cleaning Up ========"
# Stop all background processes
kill $PUBLISHER_PID 2>/dev/null
docker stop mqtt_ros_container 2>/dev/null
kill $BROKER_PID 2>/dev/null

echo "All processes stopped. Logs are available in the logs directory:"
echo "- Broker log: logs/mqtt_broker.log"
echo "- Publisher log: logs/host_publisher.log" 
echo "- Docker/ROS2 log: logs/docker.log"