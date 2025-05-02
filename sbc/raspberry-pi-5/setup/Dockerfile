FROM ros:jazzy

# Install Python MQTT client
RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install paho-mqtt

# Create workspace structure
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src/mqtt_bridge/mqtt_bridge \
    /ros2_ws/src/mqtt_bridge/resource \
    /ros2_ws/src/msgs/msg

# Copy ROS2 workspace files
# Copy message definition
COPY ./../../../ros2_ws/msg/ /ros2_ws/src/msgs/msg/

# Copy ROS node source files
COPY ./../../../ros2_ws/src/ros_mqtt_pub_test.py /ros2_ws/src/mqtt_bridge/mqtt_bridge/
COPY ./../../../ros2_ws/src/ros_mqtt_sub_test.py /ros2_ws/src/mqtt_bridge/mqtt_bridge/

# Copy package configuration files
COPY ./../../../ros2_ws/package.xml /ros2_ws/src/mqtt_bridge/
COPY ./../../../ros2_ws/setup.py /ros2_ws/src/mqtt_bridge/

# Create required files
RUN touch /ros2_ws/src/mqtt_bridge/resource/mqtt_bridge
RUN touch /ros2_ws/src/mqtt_bridge/mqtt_bridge/__init__.py

# Install message generation dependencies
RUN apt-get update && apt-get install -y \
    ros-jazzy-rosidl-default-generators \
    ros-jazzy-rosidl-default-runtime \
    && rm -rf /var/lib/apt/lists/*

# Build the ROS package
RUN . /opt/ros/jazzy/setup.sh && \
    colcon build --symlink-install

# Entry script that runs both nodes
CMD ["bash", "-c", "source /opt/ros/jazzy/setup.bash && source /ros2_ws/install/setup.bash && (ros2 run mqtt_bridge ros_mqtt_sub & ros2 run mqtt_bridge ros_mqtt_pub)"]