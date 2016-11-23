#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./build
mkdir -p ./build
cp ./../02-console/update-ssh-keys ./build/
cp ./../02-console/rancheros-install ./build/
