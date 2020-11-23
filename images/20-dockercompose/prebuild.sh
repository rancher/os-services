#!/bin/bash
set -ex

cd $(dirname $0)

VERSION=$1
ARCH=$2
if [ "$ARCH" == "amd64" ]; then
    DOCKERARCH="x86_64"
    COMPOSE_URL="https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-Linux-${DOCKERARCH}"
fi

mkdir -p compose
curl -sL -o compose/docker-compose ${COMPOSE_URL}
chmod 0755 compose/docker-compose
cp copy.sh compose/
