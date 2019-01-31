#!/bin/bash
set -ex

VERSION=$1
ARCH=$2

case $ARCH in
    "amd64" )
        DOCKERARCH="x86_64"
        ;;
    "arm64" )
        DOCKERARCH="aarch64"
        ;;
    *)
        echo "Unsupported ARCH $ARCH"
        exit 1
        ;;
esac

URL="https://download.docker.com/linux/static/stable/${DOCKERARCH}/docker-${VERSION}.tgz"
COMPLETION_URL="https://raw.githubusercontent.com/docker/cli/v${VERSION}/contrib/completion/bash/docker"

DEST="./images/10-docker-common"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
curl -sL -o $DEST/docker/completion ${COMPLETION_URL}
mv $DEST/docker $DEST/engine
