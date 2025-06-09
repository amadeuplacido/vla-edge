#!/usr/bin/env python3
import os

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import paho.mqtt.client as mqtt

class RosToMqttNode(Node):
    def __init__(self, mqtt_broker_hostname):
        super().__init__('ros_to_mqtt_node')

        self.mqtt_broker_hostname = mqtt_broker_hostname
        
        # Create ROS subscriber to topic_C
        self.subscription = self.create_subscription(
            String,
            'topic_C',
            self.ros_callback,
            10
        )
        
        # Set up MQTT client
        self.mqtt_client = mqtt.Client()
        
        # Connect to MQTT broker
        self.mqtt_client.connect(self.mqtt_broker_hostname, 1883, 60)
        self.mqtt_client.loop_start()
        
        self.get_logger().info('ROS to MQTT bridge initialized')
    
    def ros_callback(self, msg):
        self.get_logger().info(f'Received on ROS topic_C: {msg.data}')
        
        # Publish to MQTT topic
        self.mqtt_client.publish("topic_A", msg.data)

def main(args=None):
    mqtt_broker_hostname = os.environ.get("MQTT_BROKER_HOSTNAME", "localhost")
    rclpy.init(args=args)
    node = RosToMqttNode(mqtt_broker_hostname)
    
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