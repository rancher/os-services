#!/bin/bash
set -e
set -x

OS_KERNEL_VERSION=4.14.63-rancher
OS_KERNEL_URL=https://github.com/rancher/os-kernel/releases/download/v${OS_KERNEL_VERSION}/build-linux-${OS_KERNEL_VERSION}-x86.tar.gz

wget -P ./images/10-hypervvmtools/ ${OS_KERNEL_URL}
mv ./images/10-hypervvmtools/build-linux-${OS_KERNEL_VERSION}-x86.tar.gz ./images/10-hypervvmtools/build.tar.gz
