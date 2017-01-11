#!/bin/sh

docker build -t zfs .
docker run --rm -it \
	--volume /usr/src:/usr/src \
	--volume /lib/modules:/lib/modules \
        --volume $(pwd):/dist \
	zfs bash
