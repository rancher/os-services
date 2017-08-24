#!/bin/bash
set -ex

VERSION=$1
ARCH=$2
if [ "$ARCH" == "amd64" ]; then
  ARCH="x86_64"
  URL="https://download.docker.com/linux/static/stable/${ARCH}/docker-${VERSION}-ce.tgz"
fi
if [ "$ARCH" == "arm" ]; then
  DOCKERARCH="armhf"
  URL="https://download.docker.com/linux/static/stable/${DOCKERARCH}/docker-${VERSION}-ce.tgz"
  #DOCKERARCH="armel"
  #URL="https://get.docker.com/builds/Linux/${DOCKERARCH}/docker-${VERSION}-ce.tgz"
  SUFFIX="_${ARCH}"
fi
if [ "$ARCH" == "arm64" ]; then
  URL="https://github.com/rancher/docker-package/releases/download/docker-v${VERSION}-ce/docker-${VERSION}-ce.tgz"
  SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
mv $DEST/docker $DEST/engine
mv $DEST/engine/completion $DEST || true
