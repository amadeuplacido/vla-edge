### This test creates 3 containers and tests message passing across them. The cotainers are:
- mqtt_broker: MQTT broker
- mqtt_pub_sub: simple container with MQTT publisher and subscriber applicaitons
- ros2: two ROS2 nodes for managing the interface between ROS and the MQTT broker

The broker should start first, and then the mqtt_pub_sub and ros2 start.
The mqtt publisher sends the current time to topic B on MQTT every 5 seconds. Then, the ros2 subscriber node should read from MQTT topic B and forward the message to ROS on topic C. The ros2 publisher node, that subscribes to that same ROS topic, reads the message and forwards it to MQTT on topic A. Finally, the MQTT subscriber application reads whatever is on topic A, compares to it's own current time, and prints the time difference.

When you run the test, the ROS nodes and MQTT applications should print on the screen whenever they receive and/or send messages. The only exception is the broker, that writes to a log that you should be able to inspect afterwards.

To run the test, simply navigate to this directory and run:
> docker compose up

Don't forget to to a `docker compose down` afterwards.