#!/bin/sh
mount --rbind /host/dev /dev
exec "$@"
