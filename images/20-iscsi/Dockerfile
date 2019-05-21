FROM gcc:7.4.0
# FROM arm64=arm64v8/gcc:7.4.0

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        libssl-dev libmount-dev \
        kmod \
        parted lsscsi ksh curl git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /dist
COPY entry.sh /dist/
COPY build.sh /dist/
COPY wonka.sh /dist/
COPY Dockerfile.iscsi-tools /dist/

CMD ["/dist/build.sh"]

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
