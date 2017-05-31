#!/bin/bash
set -ex

#cp -r /assets/docker-1.10.3_arm ./images/10-docker-1.10.3_arm/engine
#curl -sL https://github.com/rancher/docker/releases/download/v1.10.3-arm/docker-1.10.3_arm > /assets/docker-1.10.3_arm/docker && \

VERSION=$1
ARCH=$2
if [ "$ARCH" == "amd64" ]; then
  ARCH="x86_64"
  URL="https://get.docker.com/builds/Linux/${ARCH}/docker-${VERSION}"
else
  URL="https://github.com/rancher/docker/releases/download/v${VERSION}-${ARCH}/docker-${VERSION}_${ARCH}"
  SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}/engine"

mkdir -p $DEST
curl -sL ${URL} > $DEST/docker
chmod +x $DEST/docker