#!/bin/sh

exec system-docker run --rm -it --privileged \
                --pid host \
                --net host \
                --ipc host \
		zfs-tools $(basename $0) $@
