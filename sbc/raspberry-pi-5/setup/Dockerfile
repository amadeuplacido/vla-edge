FROM ros:jazzy

# Install all required packages in a single layer
RUN apt-get update && apt-get install -y \
    ros-jazzy-rosidl-default-generators \
    ros-jazzy-rosidl-default-runtime \
    nano \
    && pip3 install --break-system-packages paho-mqtt \
    && rm -rf /var/lib/apt/lists/*

# Create workspace structure
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src/mqtt_bridge/mqtt_bridge \
    /ros2_ws/src/mqtt_bridge/resource

# Create required files
RUN touch /ros2_ws/src/mqtt_bridge/resource/mqtt_bridge
RUN touch /ros2_ws/src/mqtt_bridge/mqtt_bridge/__init__.py

# Copy ROS node source files
COPY ros2_ws/src/ /ros2_ws/src/mqtt_bridge/mqtt_bridge/

# Copy package configuration files
COPY ros2_ws/package.xml /ros2_ws/src/mqtt_bridge/
COPY ros2_ws/setup.py /ros2_ws/src/mqtt_bridge/

# Build the ROS package
RUN . /opt/ros/jazzy/setup.sh && \
    colcon build --symlink-install

# Entry script that runs both nodes
CMD ["bash", "-c", "source /opt/ros/jazzy/setup.bash && source /ros2_ws/install/setup.bash && (ros2 run mqtt_bridge ros_mqtt_sub & ros2 run mqtt_bridge ros_mqtt_pub)"]