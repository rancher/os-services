#!/bin/bash
set -e

VERSION="$1-rc1"
ARCH=$2
if [ "$ARCH" == "amd64" ]; then
  ARCH="x86_64"
  URL="https://get.docker.com/builds/Linux/${ARCH}/docker-${VERSION}-ce.tgz"
else
  URL="https://github.com/rancher/docker/releases/download/v${VERSION}-ce-${ARCH}/docker-${VERSION}_${ARCH}.tgz"
  SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
mv $DEST/docker $DEST/engine
rm -rf $DEST/completion
