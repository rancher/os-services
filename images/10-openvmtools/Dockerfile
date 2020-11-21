## Build stage
# Borrowed from https://github.com/boot2docker/boot2docker/blob/17.03.x/Dockerfile#L222-L255
FROM debian:stretch-slim as build

RUN set -eux; \
        apt-get update; \
        apt-get -y install \
                automake \
                make \
                build-essential \
                curl \
                gcc \
                unzip \
        ; \
        rm -rf /var/lib/apt/lists/*

ENV ROOTFS /rootfs

RUN mkdir -p $ROOTFS

# Install build dependencies for VMware Tools
RUN apt-get update && apt-get install -y \
        autoconf \
        libdumbnet-dev \
        libdumbnet1 \
        libfuse-dev \
        libfuse2 \
        libglib2.0-0 \
        libglib2.0-dev \
        libmspack-dev \
        libssl-dev \
        libtirpc-dev \
        libtirpc1 \
        libtool \
    && rm -rf /var/lib/apt/lists/*

# Build VMware Tools
ENV OVT_VERSION stable-11.2.0

RUN curl --retry 10 -fsSL "https://github.com/vmware/open-vm-tools/archive/${OVT_VERSION}.tar.gz" | tar -xz --strip-components=1 -C /

# Compile user space components, we're no longer building kernel module as we're
# now bundling FUSE shared folders support.
RUN cd /open-vm-tools && \
    autoreconf -i && \
    ./configure --disable-multimon --disable-docs --disable-tests --with-gnu-ld \
                --without-kernel-modules --without-procps --without-gtk2 \
                --without-gtkmm --without-pam --without-x --without-icu \
                --without-xerces --without-xmlsecurity --without-ssl && \
    make LIBS="-ltirpc" CFLAGS="-Wno-implicit-function-declaration" && \
    make DESTDIR=$ROOTFS install &&\
    /open-vm-tools/libtool --finish $ROOTFS/usr/local/lib

# Building the Libdnet library for VMware Tools.
ENV LIBDNET libdnet-1.14
RUN curl -fL -o /tmp/${LIBDNET}.zip https://github.com/dugsong/libdnet/archive/${LIBDNET}.zip && \
    unzip /tmp/${LIBDNET}.zip -d /vmtoolsd && \
    cd /vmtoolsd/libdnet-${LIBDNET} && ./configure --build=i486-pc-linux-gnu && \
    make && \
    make install && make DESTDIR=$ROOTFS install

# Horrible hack again
RUN ln -sT libdnet.1 "$ROOTFS/usr/local/lib/libdumbnet.so.1" \
	&& readlink -f "$ROOTFS/usr/local/lib/libdumbnet.so.1"

# TCL 7 doesn't ship with libtirpc.so.1 Dummy it up so the VMware tools work again, taken from:
# https://github.com/boot2docker/boot2docker/issues/1157#issuecomment-211647607
RUN ln -sT libtirpc.so "$ROOTFS/usr/local/lib/libtirpc.so.1" \
	&& readlink -f "$ROOTFS/usr/local/lib/libtirpc.so.1"

# verify that all the above actually worked (at least producing a valid binary, so we don't repeat issue #1157)
RUN LD_LIBRARY_PATH='/lib:/usr/local/lib:/rootfs/usr/local/lib'


## Final stage
FROM debian:buster-slim as final
# FROM arm=skip arm64=skip

# net-tools for ifconfig, iproute for ip
RUN apt-get update && apt-get install -y \
	net-tools \
	iproute2 \
	sudo \
	fuse \
	libtirpc-common \
	libdumbnet1 \
	libfuse2 \
	libffi6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/*

COPY --from=build bin/ /usr/local/bin
COPY --from=build lib/ /usr/local/lib
COPY --from=build etc/ /etc

RUN mkdir -p /mnt/hgfs \
    && rm -f /usr/bin/touch \
    && rm -f /usr/bin/which \
	&& ln -s /usr/local/bin/* /usr/bin/ \
	&& ldconfig

ENV LD_LIBRARY_PATH /lib:/usr/local/lib
ENV LIBRARY_PATH /lib:/usr/local/lib

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]

RUN addgroup --gid 1100 rancher && \
    addgroup --gid 1101 docker && \
    adduser -q -u 1100 --gid 1100 --disabled-password --gecos "" --shell /bin/bash rancher && \
    adduser -q -u 1101 --gid 1101 --disabled-password --gecos "" --shell /bin/bash docker && \
    adduser docker sudo && \
    sed -i 's/rancher:!/rancher:*/g' /etc/shadow && \
    sed -i 's/docker:!/docker:*/g' /etc/shadow && \
    echo '## allow password less for rancher user' >> /etc/sudoers && \
    echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo '## allow password less for docker user' >> /etc/sudoers && \
    echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo "docker:tcuser" | chpasswd
