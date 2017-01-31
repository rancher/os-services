#!/bin/sh
mount --rbind /host/dev /dev
zpool import -a
exec "$@"
