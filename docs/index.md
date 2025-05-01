---
layout: default
title: VLA-edge
---

# VLA-edge Documentation

## Get Started

### Introduction

VLA-edge is an open-source project to provide a standard framework for vision-language-action (VLA) inference models on the edge. Generally, edge devices considered in this project are single-board computers (SBC) with a central processing unit (CPU) and an AI-acceleration processor, typically a graphics processing unit (GPU) or a neural processing unit (NPU). The motivation comes from the necessity to interconnect the great variety of edge devices and VLA models created for the *robotics industry*. This framework aims to provide a SBC-agnostic interface and a suite of SBC-specific VLA models.

### Use case
In the robotics industry, there are several VLA models under development, each with its specific theoretical approach and its performance in a given scenario. Here are a few as of April 2025:
- [Octo](https://octo-models.github.io/)
- [OpenVLA](https://openvla-oft.github.io/)
- [RDT-1B](https://arxiv.org/abs/2410.07864)
- [Pi0](https://www.physicalintelligence.company/blog/openpi)
- [QUAR-VLA](https://quart-robot.github.io/)
- [Hugging Face LeRobot](https://github.com/huggingface/lerobot)
- [BI VLA](https://arxiv.org/abs/2405.06039)
- [DeepMind ALOHA](https://aloha-2.github.io/)
- [DeepMind RT-2](https://deepmind.google/discover/blog/rt-2-new-model-translates-vision-and-language-into-action/)
- [NVIDIA Groot N1](https://research.nvidia.com/publication/2025-03_nvidia-isaac-gr00t-n1-open-foundation-model-humanoid-robots)
- [Figure Helix AI](https://www.figure.ai/news/helix)
- [DexVLA](https://arxiv.org/html/2502.05855v1)

There are also different robot plaforms under development by OEMs, with difference price ranges, computational capacity and robotic configuration. What has been identified is that the API of the vast majority of these robot platforms supports an open-source operation system for robotic applications, namely the Robot Operating System (ROS) maintained by [Open Robotics](https://www.openrobotics.org/). In addition to proprietary systems with APIs supporting ROS, there are a number of SBCs being developed to enable AI model inference computation. Many OEMs opt for utilising these devices, since they already support OS that are compatible with ROS. Here are the most popular and affordable available as of April 2025:
- [Raspberry Pi 5 AI HAT+](https://www.raspberrypi.com/products/ai-hat/)
- [NVIDIA Jetson Orin Nano](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/nano-super-developer-kit/)
- [Coral Dev Board](https://www.coral.ai/products/dev-board/)
- [BeagleBoard BeagleY-AI](https://www.beagleboard.org/boards/beagley-ai)
- [Libre Computer Alta](https://libre.computer/products/aml-a311d-cc/)

The VLA models, on the other hand, are developed for a smaller variety of computers. This makes sense as VLA model researchers and developers are focusing on the VLA model performance with the least overhead work on the robotic platform. They rely substantially on simulated robot platforms and will typically use the top-performing physical robot platforms to evaluate their policy.

There are several reasons behind the wide-spread adoption of ROS by OEMs in the robotics industry. ROS is 100% open-source, has a global community with over a decade of activity, is designed as multi-domain and multi-platform (runs on Windows, Linux, MacOS and various embedded OSs), allows commercialisation, minimises time to market and has its own industry governance body: the [open-source robotics alliance](https://osralliance.org/).

In this context, the two use cases identified are:
1. Integrators using a ROS-based framework to bridge a variety of VLA models ported for a variety of SBCs utilised by OEMs,
2. VLA model developers have a ROS-based framework to port their model to SBCs for edge applications.

### Architecture
To define the scope of the project, a few architectural decisions are made based on the use cases identified for this project:
- To bypass the lack of ROS support for different host OS distributions, the framework is built for a ROS container,
- Communication between the ROS container and the host OS processes (IPC) is done via MQTT (low latency, QoS, allow for a distributed edge computing).
- MQTT broker is launched in the host OS.

The general architecture of the system is the following:
![VLA-edge architecture in SysML block diagram](/assets/images/vla-edge-architecture-bdd.png "VLA-edge architecture")

The SBC has at least two processing components, a CPU and one or more NPU/GPU. The SBC has a host OS running on its CPU. Host OS can communicate with SBC's NPU/GPU. The host OS has a ROS container, the MQTT broker and the native VLA inference models. The ROS container has the VLA model launcher nodes. The VLA model launcher nodes communicate with the native VLA inference models over MQTT.

The process starts by the VLA model launcher node sending the prompt to the VLA inference model over MQTT. The inference model on the host OS is interfaced natively with the host peripherals, namely camera/image inputs, and the NPU/GPU for processing. It takes the prompt from its MQTT topic and triggers the inference. In general, VLA models will generate a discrete action tokens which are used to command the robot. These are also sent through a MQTT topic, which can be consumed either natively by another MQTT client on the host OS interfacing the robot controller or by a ROS node, depending on the application.

### Components

*This section will be filled later*

### Setup

*This section will be filled later*

---
## Development

### Roadmap

First VLA-edge version 0.1 will use LeRobot as VLA model and Raspberry Pi 5 AI HAT+ as SBC support for pathfinding.

Then, once feasibility is validated, I will query the community to develop it further for other platforms.

### Version 0.1
#### Dependencies
<a href="https://ros.org/"><img src="/assets/images/ROS-logo.png" width="100" height="auto"></a>
<a href="https://mosquitto.org/"><img src="/assets/images/mosquitto-logo.png" width="100" height="auto"></a>
<a href="https://eclipse.dev/paho/"><img src="/assets/images/paho-logo.png" width="100" height="auto"></a>

#### Raspberry Pi 5 setup
The Pi I'm working with is booted with a Debian Bookworm distro for Raspberry Pi 5.
The first task then is to install ROS2 on the Pi. ROS2 current release is Jazzy, and it is available on Docker hub. I followed this tutorial to get the Docker running on Pi: https://docs.docker.com/engine/install/raspberry-pi-os/#install-using-the-convenience-script

To enable the AI hat, I first enabled the PCIe to use Gen 3.0 speeds (8 GT/s). The instructions are detailed here: https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0

I also installed the necessary packages to use the HAILO AI hat, as described in the instructions here: https://www.raspberrypi.com/documentation/computers/ai.html#hardware-setup

There are demo applications which use the HAILO AI hat here: https://github.com/hailo-ai/hailo-rpi5-examples

#### Minimal MQTT implementation

To validate the IPC concept from the architecture, the following implementation is devised: 
1. Host OS (Python):
    - A Mosquitto MQTT broker setup script
    - A simple Python subscriber to MQTT topic A
    - A simple Python publisher sending timestamps to MQTT topic B
2. ROS2 (Docker):
    - A ROS2 node that subscribes to MQTT topic B and publishes to ROS topic C
    - A ROS2 node that subscribes to ROS topic C and publishes to MQTT topic A
    - Complete Docker and ROS2 package setup files
3. Detailed Setup Instructions:
    - Steps to set up the MQTT broker
    - Commands to run all components

*Flow of Data*
1. Host publishes timestamps → MQTT topic B
2. ROS2 node bridges → MQTT topic B → ROS topic C
3. ROS2 node bridges → ROS topic C → MQTT topic A
4. Host subscriber listens → MQTT topic A

The MQTT broker on the host OS will use Mosquitto. The host MQTT clients will use Paho. ROS2 nodes will use the `mqtt_client` package (maintained by IKA RWTH).