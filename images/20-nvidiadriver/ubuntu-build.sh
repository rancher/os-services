#!/bin/sh
set -ex

BUILD_DIR=/var/lib/rancher/nvidia
KERNEL_VERSION=$(uname -r)

apt-get update && apt-get upgrade -y
apt install gcc make curl -y
curl -sL http://us.download.nvidia.com/XFree86/Linux-x86_64/390.48/NVIDIA-Linux-x86_64-390.48.run -o NVIDIA-Linux-x86_64-390.48.run
ros service enable kernel-headers
ros service up kernel-headers

sh NVIDIA-Linux-x86_64-390.48.run --no-drm

if [ ! -e /usr/bin/nvidia-container-cli ]; then
     ln -s ${BUILD_DIR}/bin/nvidia-container-cli /usr/bin/nvidia-container-cli
fi
if [ ! -e /usr/bin/nvidia-container-runtime ]; then
     ln -s ${BUILD_DIR}/bin/nvidia-container-runtime /usr/bin/nvidia-container-runtime
fi
if [ ! -e /usr/bin/nvidia-container-runtime-hook ]; then
     ln -s ${BUILD_DIR}/bin/nvidia-container-runtime-hook /usr/bin/nvidia-container-runtime-hook
fi
if [ ! -e /usr/lib/libnvidia-container.so.1 ]; then
     ln -s ${BUILD_DIR}/lib/libnvidia-container.so.1 /usr/lib/libnvidia-container.so.1
fi

echo "Cleaning kernel headers"
ros service disable kernel-headers
rm -rf /lib/modules/${KERNEL_VERSION}/build/ && rm -f /lib/modules/${KERNEL_VERSION}/.headers-done
rm -rf /var/lib/rancher/nvidia/NVIDIA-Linux-x86_64-390.48.run

system-docker restart docker