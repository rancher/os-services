#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./WALinuxAgent.tar.gz

wget https://github.com/Azure/WALinuxAgent/archive/v2.2.49.2.tar.gz -O WALinuxAgent.tar.gz