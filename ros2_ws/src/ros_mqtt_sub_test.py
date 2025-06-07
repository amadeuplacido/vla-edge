#!/usr/bin/env python3
import os

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import paho.mqtt.client as mqtt

class MqttToRosNode(Node):
    def __init__(self, mqtt_broker_hostname):
        super().__init__('mqtt_to_ros_node')
        
        # Create ROS publisher to topic_C
        self.publisher = self.create_publisher(String, 'topic_C', 10)
        
        # Set up MQTT client
        self.mqtt_client = mqtt.Client()
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        
        # Connect to MQTT broker
        self.mqtt_client.connect(mqtt_broker_hostname, 1883, 60)
        print("CONNECTED")
        self.mqtt_client.loop_start()
        
        self.get_logger().info('MQTT to ROS bridge initialized')
    
    def on_connect(self, client, userdata, flags, rc):
        self.get_logger().info('Connected to MQTT broker')
        client.subscribe("topic_B")
    
    def on_message(self, client, userdata, msg):
        payload = msg.payload.decode()
        self.get_logger().info(f'Received on MQTT topic_B: {payload}')
        
        # Publish to ROS topic
        ros_msg = String()
        ros_msg.data = payload
        self.publisher.publish(ros_msg)

def main(args=None):
    rclpy.init(args=args)
    mqtt_broker_hostname = os.environ.get("MQTT_BROKER_HOSTNAME", "localhost")
    node = MqttToRosNode(mqtt_broker_hostname)
    
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.mqtt_client.loop_stop()
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()