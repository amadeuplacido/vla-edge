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
- [BI VLA](https://arxiv.org/abs/2405.06039)
- [DeepMind RT-2](https://deepmind.google/discover/blog/rt-2-new-model-translates-vision-and-language-into-action/)
- [NVIDIA Groot N1](https://research.nvidia.com/publication/2025-03_nvidia-isaac-gr00t-n1-open-foundation-model-humanoid-robots)
- [Octo](https://octo-models.github.io/)
- [OpenVLA](https://openvla-oft.github.io/)
- [RDT-1B](https://arxiv.org/abs/2410.07864)
- [Pi0](https://www.physicalintelligence.company/blog/openpi)
- [DexVLA](https://arxiv.org/html/2502.05855v1)
 There are also different robot plaforms under development by OEMs, with difference price ranges, computational capacity and robotic configuration.
 
 What has been identified is that the API of the vast majority of these robot platforms supports an open-source operation system for robotic applications, namely the Robot Operating System (ROS) maintained by [Open Robotics](https://www.openrobotics.org/). The VLA models, on the other hand, are developed for a smaller variety of computers.

 There are several reasons behind the wide-spread adoption of ROS by OEMs in the robotics industry. ROS is 100% open-source, has a global community with over a decade of activity, is designed as multi-domain and multi-platform (runs on Windows, Linux, MacOS and various embedded OSs), allows commercialisation, minimises time to market and has its own industry governance body: the [open-source robotics alliance](https://osralliance.org/).

The use case identified is to provide a bridge between ROS and VLA models ported for a suite of SBCs.

### Architecture
To define the scope of the project, a few architectural decisions are made based on the main use case identified for this project:
- To bypass the lack of ROS support for different host OS distributions, the framework is built for a ROS container,
- Communication between the ROS container and the host OS processes (IPC) should be decoupled from the host OS implementation. MQTT has been chosen as it has lowest latency, QoS and would even allow for a distributed edge computing with the same framework.

The general architecture of the system is the following:

The SBC has at least two processing components, a CPU and a NPU/GPU. The SBC has a host OS running on its CPU. Host OS can communicate with SBC's NPU/GPU. The host OS has a ROS container and the VLA inference models. The ROS container has the VLA-edge package, with the launcher node for each VLA inference model ported on the host OS.



### Setup

*This section will be filled later*

---
## Development

### Entry 1: Initial Setup

*First development entry will go here*

### Entry 2: Feature Implementation

*Feature implementation details will go here*