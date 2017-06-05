#!/bin/bash
set -ex

VERSION=$1
ARCH=$2
if [ "$ARCH" == "amd64" ]; then
  ARCH="x86_64"
  URL="https://get.docker.com/builds/Linux/${ARCH}/docker-${VERSION}-ce.tgz"
fi
if [ "$ARCH" == "arm" ]; then
  DOCKERARCH="armel"
  URL="https://get.docker.com/builds/Linux/${DOCKERARCH}/docker-${VERSION}-ce.tgz"
  SUFFIX="_${ARCH}"
fi
if [ "$ARCH" == "arm64" ]; then
  URL="https://github.com/rancher/docker/releases/download/v${VERSION}-${ARCH}/docker-${VERSION}_${ARCH}.tgz"
  SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
mv $DEST/docker $DEST/engine
mv $DEST/engine/completion $DEST
