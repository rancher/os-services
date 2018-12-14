#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./WALinuxAgent.tar.gz

wget https://codeload.github.com/Azure/WALinuxAgent/tar.gz/v2.2.34 -O WALinuxAgent.tar.gz