from setuptools import setup
import os
from glob import glob

package_name = 'mqtt_bridge'

setup(
    name=package_name,
    version='0.1.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools', 'paho-mqtt'],
    zip_safe=True,
    maintainer='manumite',
    maintainer_email='support@manumite.com',
    description='Minimal MQTT-ROS2 bridge for Docker-Host IPC',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'ros_mqtt_pub = mqtt_bridge.ros_mqtt_pub_test:main',
            'ros_mqtt_sub = mqtt_bridge.ros_mqtt_sub_test:main',
        ],
    },
)