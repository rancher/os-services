#!/bin/bash
set -ex

VERSION=$1
ARCH=$2
if [ "$ARCH" == "arm64" ]; then
  DOCKERARCH="aarch64"
  URL="https://download.docker.com/linux/static/stable/${DOCKERARCH}/docker-${VERSION}-ce.tgz"
  SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
mv $DEST/docker $DEST/engine
mv $DEST/engine/completion $DEST || true
