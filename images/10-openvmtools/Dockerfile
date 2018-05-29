FROM debian:stable-slim
# FROM arm=skip arm64=skip

# net-tools for ifconfig, iproute for ip
RUN apt-get update && apt-get install -y \
	net-tools \
	iproute2 \
	sudo \
	fuse \
	libtirpc1 \
	libdumbnet1 \
	libfuse2 \
	libffi6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/*

COPY bin/ /usr/local/bin
COPY lib/ /usr/local/lib
COPY etc/ /etc

RUN mkdir -p /mnt/hgfs \
	&& ln -s /usr/local/bin/* /usr/bin/ \
	&& ldconfig

ENV LD_LIBRARY_PATH /lib:/usr/local/lib
ENV LIBRARY_PATH /lib:/usr/local/lib

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]

RUN addgroup --gid 1100 rancher && \
    addgroup --gid 1101 docker && \
    adduser -q -u 1100 --gid 1100 --shell /bin/bash rancher && \
    adduser -q -u 1101 --gid 1101 --shell /bin/bash docker && \
    adduser docker sudo && \
    sed -i 's/rancher:!/rancher:*/g' /etc/shadow && \
    sed -i 's/docker:!/docker:*/g' /etc/shadow && \
    echo '## allow password less for rancher user' >> /etc/sudoers && \
    echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo '## allow password less for docker user' >> /etc/sudoers && \
    echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo "docker:tcuser" | chpasswd
