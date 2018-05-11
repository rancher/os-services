#!/bin/sh
set -ex

BUILD_DIR=/var/lib/rancher/nvidia
KERNEL_VERSION=$(uname -r)

NVIDIA_VERSION=390.48
NVIDIA_DRIVER=NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
CUDA_PKG=cuda-repo-ubuntu1604_9.1.85-1_amd64.deb

apt-get update && apt-get upgrade -y
apt install gcc make curl -y
curl -sL http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/${NVIDIA_DRIVER} -o ${BUILD_DIR}/${NVIDIA_DRIVER}
ros service enable kernel-headers
ros service up kernel-headers

sh ${BUILD_DIR}/${NVIDIA_DRIVER} --no-drm

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

curl -sL http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_PKG} -o ${BUILD_DIR}/${CUDA_PKG}
dpkg -i ${BUILD_DIR}/${CUDA_PKG}
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
apt-get update
apt-get install -y cuda

echo "Cleaning kernel headers && cache"
ros service disable kernel-headers
rm -rf /lib/modules/${KERNEL_VERSION}/build/ && rm -f /lib/modules/${KERNEL_VERSION}/.headers-done
rm -rf ${BUILD_DIR}/${NVIDIA_DRIVER}
rm -rf ${BUILD_DIR}/${CUDA_PKG}

system-docker restart docker