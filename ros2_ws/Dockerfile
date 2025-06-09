FROM ros:jazzy

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    && pip3 install --break-system-packages paho-mqtt \
    && rm -rf /var/lib/apt/lists/*

# Create workspace structure (proper ROS2 structure)
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src/mqtt_bridge/mqtt_bridge \
    /ros2_ws/src/mqtt_bridge/resource

# Create required files
RUN touch /ros2_ws/src/mqtt_bridge/resource/mqtt_bridge
RUN touch /ros2_ws/src/mqtt_bridge/mqtt_bridge/__init__.py

# Copy ROS node source files
COPY src/ /ros2_ws/src/mqtt_bridge/mqtt_bridge/

# Copy package configuration files
COPY package.xml /ros2_ws/src/mqtt_bridge/
COPY setup.py /ros2_ws/src/mqtt_bridge/

# Build the ROS package
RUN . /opt/ros/jazzy/setup.sh && \
    colcon build --symlink-install

COPY docker_entrypoint.bash /docker_entrypoint.bash

RUN chmod +x /docker_entrypoint.bash

# Entry script with explicit sourcing and starting both nodes directly
ENTRYPOINT ["/docker_entrypoint.bash"]
CMD ["/bin/bash"]