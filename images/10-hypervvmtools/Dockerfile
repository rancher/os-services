FROM ubuntu:16.04 as build-essential
# FROM arm64=skip arm=skip
RUN apt-get update  && \
    apt-get install -y --no-install-recommends kmod bash git gcc make build-essential && \
    rm -rf /var/lib/apt/lists/*

ARG OS_KERNEL_VERSION
ENV KERNEL_VERSION=${OS_KERNEL_VERSION}

COPY headers.sh  /
COPY build.tar.gz /

RUN /headers.sh && \
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git && \
    cd linux-stable/tools/hv && \
    make && \
    apt-get remove -y --allow-remove-essential kmod bash git gcc make build-essential && \
    rm -rf /build.tar.gz && \
    cp hv_kvp_daemon /usr/bin && \
    cp hv_vss_daemon /usr/bin && \
    cp hv_fcopy_daemon /usr/bin && \
    mkdir -p /usr/libexec/hypervkvpd/ && \
    cp hv_get_dhcp_info.sh /usr/libexec/hypervkvpd/hv_get_dhcp_info && \
    cp hv_get_dns_info.sh /usr/libexec/hypervkvpd/hv_get_dns_info && \
    cp hv_set_ifconfig.sh /usr/libexec/hypervkvpd/hv_set_ifconfig && \
    chmod +x /usr/libexec/hypervkvpd/* && \
    cp lsvmbus /usr/bin && \
    cd / && \
    rm -rf linux-stable

FROM ubuntu:16.04
# FROM arm64=skip arm=skip

RUN apt-get update  && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/libexec/hypervkvpd/

COPY --from=build-essential /usr/bin/hv_* /usr/bin/
COPY --from=build-essential /usr/bin/lsvmbus /usr/bin/
COPY --from=build-essential /usr/libexec/hypervkvpd/* /usr/libexec/hypervkvpd/

RUN chmod +x /usr/bin/hv_* && \
    chmod +x /usr/bin/lsvmbus

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
