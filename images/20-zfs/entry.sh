#!/bin/sh
mount --rbind /host/dev /dev > /dev/null 2>&1
zpool import -a > /dev/null 2>&1
exec "$@"
