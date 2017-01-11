#!/bin/sh

exec system-docker run --rm -it --privileged zfs-tools $(basename $0) $@
