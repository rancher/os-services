#!/bin/sh
set -ex


KERNEL_VERSION=$(uname -r)
echo "aws-ena for ${KERNEL_VERSION}"

STAMP=/lib/modules/${KERNEL_VERSION}/.aws-ena-done

if [ -e $STAMP ]; then
    modprobe ena

    echo "aws-ena for ${KERNEL_VERSION} already installed. Delete $STAMP to reinstall"
    exit 0
fi

ros service enable kernel-headers
ros service up kernel-headers

ENA_TAR=ena_linux_${ENA_VERSION}.tar.gz
ENA_URL=https://github.com/amzn/amzn-drivers/archive/${ENA_TAR}
ENA_BUILD_DIR=$(mktemp -d -p .)

echo "Downloading ${ENA_URL} to ${ENA_TAR}"
curl -sL ${ENA_URL} -o ${ENA_TAR}
echo "Extracting ${ENA_TAR} to ${ENA_BUILD_DIR}"
tar xf ${ENA_TAR} -C ${ENA_BUILD_DIR} --strip-components=1

echo "Compiling ena driver"
cd ${ENA_BUILD_DIR}/kernel/linux/ena/
make
cp ena.ko /lib/modules/${KERNEL_VERSION}/
depmod

cd /dist
touch $STAMP
echo "aws-ena for ${KERNEL_VERSION} installed. Delete $STAMP to reinstall"

echo "Cleaning ena code"
rm -rf ${ENA_TAR} && rm -rf ${ENA_BUILD_DIR}

echo "Cleaning kernel headers"
ros service disable kernel-headers
rm -rf /lib/modules/${KERNEL_VERSION}/build/ && rm -f /lib/modules/${KERNEL_VERSION}/.headers-done
