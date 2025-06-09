#!/bin/bash
# setup ros2
source /opt/ros/jazzy/setup.bash
source /ros2_ws/install/setup.bash
# start ros2 daemon
ros2 daemon start \
# execute commands that come afterwards
exec "$@"