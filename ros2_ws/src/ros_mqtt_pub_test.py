#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from mqtt_bridge.msg import MqttMsg
import paho.mqtt.client as mqtt

class RosToMqttNode(Node):
    def __init__(self):
        super().__init__('ros_to_mqtt_node')
        
        # Create ROS subscriber to topic_C
        self.subscription = self.create_subscription(
            MqttMsg,
            'topic_C',
            self.ros_callback,
            10
        )
        
        # Set up MQTT client
        self.mqtt_client = mqtt.Client()
        
        # Connect to MQTT broker (host.docker.internal points to the host from Docker)
        self.mqtt_client.connect("host.docker.internal", 1883, 60)
        self.mqtt_client.loop_start()
        
        self.get_logger().info('ROS to MQTT bridge initialized')
    
    def ros_callback(self, msg):
        self.get_logger().info(f'Received on ROS topic_C: {msg.data}')
        
        # Publish to MQTT topic
        self.mqtt_client.publish("topic_A", msg.data)

def main(args=None):
    rclpy.init(args=args)
    node = RosToMqttNode()
    
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