#!/bin/bash
# patch version 1, CVE-2019-5736
set -e

#RUN curl -sfL https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz | tar xzf - -C /assets && \
#    mv /assets/docker /assets/docker-1.11.2

VERSION=$1
ARCH=$2
if [ "$ARCH" == "arm64" ]; then
    URL="https://github.com/rancher/docker-package/releases/download/docker-v${VERSION}/docker-v${VERSION}_${ARCH}.tgz"
    SUFFIX="_${ARCH}"
fi

DEST="./images/10-docker-${VERSION}${SUFFIX}"

mkdir -p $DEST
curl -sL ${URL} | tar xzf - -C $DEST
mv $DEST/docker $DEST/engine
rm -rf $DEST/completion

curl -sL -o $DEST/engine/docker-runc https://github.com/rancher/runc-cve/releases/download/CVE-2019-5736-build2/runc-v${VERSION}-${ARCH}
