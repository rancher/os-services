#!/bin/sh

exec system-docker run --rm --privileged \
                --pid host \
                --net host \
                --ipc host \
		-v /mnt:/mnt:shared \
		-v /media:/media:shared \
		-v /dev:/host/dev \
		-v /run:/run \
		zfs-tools $(basename $0) "$@"
