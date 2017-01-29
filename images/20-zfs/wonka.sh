#!/bin/sh

exec system-docker run --rm -it --privileged \
                --pid host \
                --net host \
                --ipc host \
		-v /mnt:/mnt:shared \
		-v /dev:/host/dev \
		-v /run:/run \
		zfs-tools $(basename $0) $@
