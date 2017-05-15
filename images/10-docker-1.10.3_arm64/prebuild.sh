#!/bin/bash
set -e

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