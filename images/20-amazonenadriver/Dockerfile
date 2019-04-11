FROM ubuntu:17.10
# FROM arm64=arm64v8/ubuntu:17.10 arm=arm32v7/ubuntu:17.10

ENV ENA_VERSION 1.5.0

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y curl \
    build-essential autoconf libtool \
    module-init-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /dist
COPY build.sh /dist/

CMD ["/dist/build.sh"]

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
