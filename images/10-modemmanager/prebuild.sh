#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./yq_linux_amd64

wget --no-check-certificate https://github.com/mikefarah/yq/releases/download/2.2.0/yq_linux_amd64
