#!/bin/sh
set -ex

BUILD_DIR=/tmp
LOCAL_PATH=${BUILD_DIR}/usr/local
CONF_PATH=/etc/docker

TAR_URL=https://github.com/NVIDIA/libnvidia-container/releases/download/v1.0.0-beta.1
TAR_FILE=libnvidia-container_1.0.0-beta.1_x86_64.tar.xz

if [ ! -e $CONF_PATH ]; then
     mkdir -p ${CONF_PATH}

fi

sudo tee ${CONF_PATH}/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF

echo "Download ${TAR_FILE}"
curl -sL ${TAR_URL}/${TAR_FILE} -o ${TAR_FILE}

echo "Extracting ${TAR_FILE} to ${BUILD_DIR}"
tar -xvJf ${TAR_FILE} -C ${BUILD_DIR} --strip-components=1
rm -rf ${TAR_FILE}

echo "Copy file to ${LOCAL_PATH}"
cp /usr/bin/nvidia-* ${LOCAL_PATH}/bin/

cp /usr/lib64/libseccomp.so.2 ${LOCAL_PATH}/lib/libseccomp.so.2
cp /usr/lib64/libcap.so.2 ${LOCAL_PATH}/lib/libcap.so.2
cp /usr/lib64/libattr.so.1 ${LOCAL_PATH}/lib/libattr.so.1

grep "console: ubuntu" /var/lib/rancher/conf/cloud-config.yml > /dev/null
if [ $? -eq 0 ]; then
    cp ubuntu-build.sh ${LOCAL_PATH}/build.sh
    chmod 755 ${LOCAL_PATH}/build.sh
fi