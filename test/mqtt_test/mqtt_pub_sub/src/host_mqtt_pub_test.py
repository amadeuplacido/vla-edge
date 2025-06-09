#!/usr/bin/env python3
import paho.mqtt.client as mqtt
import time
import datetime
import os

# Take broker hostname from environment variable
hostname = os.environ.get("MQTT_BROKER_HOSTNAME", "localhost")

# Create MQTT client
client = mqtt.Client()

# Connect to broker running on localhost
client.connect(hostname, 1883, 60)

# Start the loop in thread
client.loop_start()

try:
    while True:
        # Get current time
        current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
        
        # Publish to topic_B
        client.publish("topic_B", current_time)
        print(f"Published to topic_B: {current_time}")
        
        # Wait 5 seconds
        time.sleep(5)
except KeyboardInterrupt:
    print("Exiting...")
    client.loop_stop()