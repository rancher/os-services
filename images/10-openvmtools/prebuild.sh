#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./bin ./lib ./etc

wget https://github.com/Jason-ZW/open-vm-tools/releases/download/stable-10.3.10/open-vm-tools.tar.gz \
	&& tar xvzf open-vm-tools.tar.gz \
	&& cp -r open-vm-tools-build/bin . \
	&& cp -r open-vm-tools-build/lib . \
	&& cp -r open-vm-tools-build/etc . \
	&& rm -rf open-vm-tools-build open-vm-tools.tar.gz 
