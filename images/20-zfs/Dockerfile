FROM ubuntu:16.04
# FROM arm64=aarch64/ubuntu:16.04 arm=armhf/ubuntu:16.04


RUN apt-get update \
    && apt-get install -yq build-essential autoconf libtool gawk alien fakeroot \
	zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev libdevmapper-dev \
	module-init-tools \
	parted lsscsi ksh curl git

WORKDIR /dist
COPY build.sh /dist/
COPY wonka.sh /dist/
COPY Dockerfile.zfs-tools /dist/

CMD ["/dist/build.sh"]

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
