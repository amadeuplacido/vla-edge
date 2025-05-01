---
layout: default
title: VLA-edge
---

# VLA-edge Documentation

## Get Started

### Introduction

`VLA-edge` is an open-source portfolio to provide a standard framework for edge vision-language-action (VLA) inference engines. Generally, edge devices considered in this project are single-board computers (SBC) with a central processing unit (CPU) and an AI-acceleration hardware, typically a graphics processing unit (GPU), a neural processing unit (NPU) or a tensor processing unit (TPU). 

The motivation comes from the necessity to interconnect the great variety of edge devices and VLA models created for the *general-purpose robotics industry*. This framework aims to provide a SBC-agnostic interface and a suite of SBC-specific VLA models.

### Use case

There are many general-purpose robot plaforms under development by OEMs, with different price ranges, computational capacity and robot configuration. What has been identified is that the API of the vast majority of these robot platforms supports the Robot Operating System (ROS) maintained by [Open Robotics](https://www.openrobotics.org/). In addition to proprietary systems with APIs supporting ROS, there are a number of SBCs being developed to enable AI model inference computation. Many OEMs opt for utilising these devices, since they already support OS that are compatible with ROS. 

Here are the most popular and affordable AI-accelerated SBCs available as of April 2025:
- [Raspberry Pi 5 AI HAT+](https://www.raspberrypi.com/products/ai-hat/) (open-source)
- [Coral Dev Board](https://www.coral.ai/products/dev-board/) (open-source)
- [BeagleBoard BeagleY-AI](https://www.beagleboard.org/boards/beagley-ai) (open-source)
- [Libre Computer Alta](https://libre.computer/products/aml-a311d-cc/) (open-source)
- [NVIDIA Jetson Orin Nano](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/nano-super-developer-kit/)
- [Udoo Bolt](https://www.udoo.org/discover-the-udoo-bolt/)
- [Latte Panda Delta V3](https://www.lattepanda.com/lattepanda-3-delta)
- [UP Squared 7000](https://up-board.org/up-7000/?ADLN01Board)
- [Orange Pi 5 Ultra](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-5-Ultra.html)
- [Banana Pi BPI-M5 Pro](https://docs.banana-pi.org/en/BPI-M5/BananaPi_BPI-M5_Pro)

There are several reasons behind the wide-spread adoption of ROS by OEMs in the robotics industry. ROS is 100% open-source, has a global community with over a decade of activity, is designed as multi-domain and multi-platform (runs on Windows, Linux, MacOS and various embedded OSs), allows commercialisation, minimises time to market and has its own industry governance body: the [open-source robotics alliance](https://osralliance.org/).

VLA models, on the other hand, are developed for a smaller variety of computers. This makes sense as VLA model researchers and developers are focusing on the VLA model performance with the least overhead work on the robotic platform. They rely substantially on simulated general-purpose robot platforms and will typically use the top-performing physical robot platforms to evaluate their models.

In the robotics industry, there are several VLA models under development (feels like an arms race honestly), each with its specific theoretical approach and its performance in a given set of tasks. Here are a few as of April 2025:
- [OpenVLA](https://openvla-oft.github.io/) (open-source)
- [RDT-1B](https://rdt-robotics.github.io/rdt-robotics/) (open-source)
- [DexVLA](https://dex-vla.github.io/) (open-source)
- [Hugging Face LeRobot](https://github.com/huggingface/lerobot) (open-source)
- [Physical Intelligence PI0](https://www.physicalintelligence.company/blog/openpi) (open-source)
- [Octo](https://octo-models.github.io/) (open-source)
- [QUAR-VLA](https://quart-robot.github.io/) (open-source)
- [BI VLA](https://arxiv.org/abs/2405.06039)
- [DeepMind ALOHA](https://aloha-2.github.io/)
- [DeepMind RT-2](https://deepmind.google/discover/blog/rt-2-new-model-translates-vision-and-language-into-action/)
- [NVIDIA Groot N1](https://research.nvidia.com/publication/2025-03_nvidia-isaac-gr00t-n1-open-foundation-model-humanoid-robots)
- [Figure Helix AI](https://www.figure.ai/news/helix)

In this context, the two use cases identified are:
1. Integrators using a ROS-based framework to bridge a variety of VLA models ported for a variety of SBCs utilised by OEMs,
2. VLA model developers have a ROS-based framework to port their model to SBCs for edge applications.

### Architecture
To define the scope of the project, a few architectural decisions are made based on the use cases identified for this project:
- To bypass the lack of ROS support for different host OS distributions, the framework is built for a ROS container,
- Communication between the ROS container and the host OS processes (IPC) is done via MQTT (low latency, QoS, allow for a distributed edge computing).
- MQTT broker is launched in the host OS.

The general system architecture is depicted below. The components shaded in gray are part of the scope of the `VLA-edge` project.
![VLA-edge architecture](/assets/images/vla-edge-architecture-bdd.png)

The SBC has at least two processing components, a CPU and one or more NPU/GPU. The SBC has a host OS running on its CPU. Host OS can communicate with SBC's NPU/GPU. The host OS has a ROS container, the MQTT broker and the native VLA inference models. The ROS container has the VLA model launcher nodes. The VLA model launcher nodes communicate with the native VLA inference models over MQTT.

The process starts by the VLA model launcher node sending the prompt to the VLA inference model over MQTT. The inference model on the host OS is interfaced natively with the host peripherals, namely camera/image inputs, and the NPU/GPU for processing. It takes the prompt from its MQTT topic and triggers the inference. In general, VLA models will generate a discrete action tokens which are used to command the robot. These are also sent through a MQTT topic, which can be consumed either natively by another MQTT client on the host OS interfacing the robot controller or by a ROS node, depending on the application.

### Components
#### VLA-edge MQTT Broker

*This section will be filled later*

#### VLA-edge ROS 

### Setup

*This section will be filled later*

---
## Development

### Roadmap

The program is set to be developed incrementally with several projects -- each model-SBC pair consists of an individual project in the program -- where the pair models-SBC are evaluated for their feasibility in terms of computational capacity, performance and dependencies.

The first project will port the LeRobot VLA model for the Raspberry Pi 5 AI HAT+, and will be used as pathfinding for the subsequent projects.

|-----------------------------------------------------------------------------------|
|                                               **VLA models**                      |
|                          |-------------|-------------|------------|---------------|
|         **SBCs**         |  *LeRobot*  |  *OpenVLA*  |  *OpenPI*  |  *Octo-Tiny*  |
|--------------------------|-------------|-------------|------------|---------------|
| *Raspberry Pi 5 AI HAT+* |     2025    | TBD         | TBD        | TBD?          |
|--------------------------|-------------|-------------|------------|---------------|
| *Libre *Computer Alta*   | TBD         | TBD         | TBD        | TBD?          |
|--------------------------|-------------|-------------|------------|---------------|
| *Coral Dev Board*        | TBD         | TBD         | TBD        | TBD?          |
|--------------------------|-------------|-------------|------------|---------------|
| *BeagleBoard BeagleY-AI* | TBD         | TBD         | TBD        | TBD?          |
|--------------------------|-------------|-------------|------------|---------------|

### Version 0.1
#### Dependencies
[![](docs/assets/images/ROS-logo.png)](https://ros.org/)
[![](/assets/images/mosquitto-logo.png)](https://mosquitto.org/)
[![](/assets/images/paho-logo.png)](https://eclipse.dev/paho/)

#### Raspberry Pi 5 setup
The Pi I'm working with is booted with a Debian Bookworm distro for Raspberry Pi 5.
The first task then is to install ROS2 on the Pi. ROS2 current release is Jazzy, and it is available on Docker hub. I followed this tutorial to get the Docker running on Pi: https://docs.ros.org/en/rolling/How-To-Guides/Installing-on-Raspberry-Pi.html#raspberry-pi-os-with-ros-2-in-docker

To enable the AI hat, I first enabled the PCIe to use Gen 3.0 speeds (8 GT/s). The instructions are detailed here: https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0

I also installed the necessary packages to use the HAILO AI hat, as described in the instructions here: https://www.raspberrypi.com/documentation/computers/ai.html#hardware-setup

There are demo applications which use the HAILO AI hat here: https://github.com/hailo-ai/hailo-rpi5-examples

#### Minimal MQTT bridge implementation

To validate the IPC concept from the architecture, the following implementation is devised: 
1. Host OS (Python):
    - A Mosquitto MQTT broker script
    - A simple Python subscriber to MQTT topic A (calculates the message latency)
    - A simple Python publisher sending timestamps to MQTT topic B
2. ROS2 (Docker):
    - A ROS2 node that subscribes to MQTT topic B and publishes to ROS topic C
    - A ROS2 node that subscribes to ROS topic C and publishes to MQTT topic A
3. Detailed Setup Instructions:
    - Script to install all host dependencies
    - Dockerfile for ROS2 on RPI5
    - Script to run all components in order

**Data flow**
1. Host publishes timestamps → MQTT topic B
2. ROS2 node bridges → MQTT topic B → ROS topic C
3. ROS2 node bridges → ROS topic C → MQTT topic A
4. Host subscriber listens → MQTT topic A

![MQTT bridge data flow](/assets/images/MQTT_bridge.png)

The MQTT broker on the host OS will use `Mosquitto`. The host MQTT clients and ROS2 node clients will use `Paho`.