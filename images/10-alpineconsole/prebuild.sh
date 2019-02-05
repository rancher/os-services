#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./build
mkdir -p ./build
cp ./../02-console/sshd_config.append.tpl ./build/
