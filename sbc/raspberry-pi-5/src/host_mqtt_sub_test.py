#!/usr/bin/env python3
import paho.mqtt.client as mqtt
import datetime

# Function to parse timestamp string into datetime object
def parse_timestamp(timestamp_str):
    return datetime.datetime.strptime(timestamp_str, "%Y-%m-%d %H:%M:%S.%f")

# Callback when connected to MQTT broker
def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT broker")
    client.subscribe("topic_A")

# Callback when message is received
def on_message(client, userdata, msg):
    payload = msg.payload.decode()

    # Calculate time difference
    time_diff = calculate_time_diff_ms(payload)
    
    print(f"Received on topic_A: {payload}")
    print(f"Time difference: {time_diff:.2f} ms")
    print("-" * 50)

# Calculate time difference in milliseconds
def calculate_time_diff_ms(timestamp_str):
    sent_time = parse_timestamp(timestamp_str)
    current_time = datetime.datetime.now()
    
    # Calculate difference in milliseconds
    time_diff = (current_time - sent_time).total_seconds() * 1000
    return time_diff

# Create MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# Connect to broker running on localhost
client.connect("localhost", 1883, 60)

# Loop forever to receive messages
client.loop_forever()