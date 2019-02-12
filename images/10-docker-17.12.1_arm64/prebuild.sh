#!/bin/bash
# patch version 1, CVE-2019-5736
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

curl -sL -o $DEST/engine/docker-runc https://github.com/rancher/runc-cve/releases/download/CVE-2019-5736-build2/runc-v${VERSION}-${ARCH}
