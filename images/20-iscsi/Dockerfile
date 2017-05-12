FROM ubuntu:16.04
# FROM arm64=aarch64/ubuntu:16.04 arm=armhf/ubuntu:16.04

RUN apt-get update \
    && apt-get install -yq curl \
	build-essential autoconf libtool \
	module-init-tools \
	libssl-dev \
	libmount-dev

WORKDIR /dist
COPY entry.sh /dist/
COPY build.sh /dist/
COPY wonka.sh /dist/
COPY Dockerfile.iscsi-tools /dist/

CMD ["/dist/build.sh"]

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
