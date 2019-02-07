#!/bin/bash
set -ex

VERSION=$1
ARCH=$2
if [ "$ARCH" == "arm64" ]; then
    DOCKERARCH="aarch64"
    URL="https://download.docker.com/linux/static/stable/${DOCKERARCH}/docker-${VERSION}.tgz"
    COMPLETION_URL="https://raw.githubusercontent.com/docker/cli/v${VERSION}/contrib/completion/bash/docker"
    SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
curl -sL -o $DEST/docker/completion ${COMPLETION_URL}
mv $DEST/docker $DEST/engine
