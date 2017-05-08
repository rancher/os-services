#!/bin/sh
mount --rbind /host/dev /dev > /dev/null 2>&1
mkdir -p /run/lock
exec "$@"
