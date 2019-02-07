#!/bin/bash
set -ex

VERSION=$1
ARCH=$2
if [ "$ARCH" == "amd64" ]; then
    DOCKERARCH="x86_64"
    URL="https://download.docker.com/linux/static/stable/${DOCKERARCH}/docker-${VERSION}-ce.tgz"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
mv $DEST/docker $DEST/engine
mv $DEST/engine/completion $DEST || true
