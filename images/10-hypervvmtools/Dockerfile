FROM gcc:7.4.0 as build-essential
# FROM arm64=skip arm=skip
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends kmod && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/* \

WORKDIR /dist
ENV KERNEL_VERSION 4.14.138-rancher
ENV KERNEL_SRC https://github.com/rancher/os-kernel/releases/download/v${KERNEL_VERSION}/linux-${KERNEL_VERSION}-x86-src.tgz

RUN wget -q $KERNEL_SRC && \
    tar xf linux-${KERNEL_VERSION}-x86-src.tgz -C . && \
    cd v${KERNEL_VERSION}/tools/hv && \
    make && \
    mkdir -p /dist/scripts /dist/bin && \
    cp hv*daemon /dist/bin/ && \
    cp -a hv_get_dhcp_info.sh /dist/scripts/hv_get_dhcp_info && \
    cp -a hv_get_dns_info.sh /dist/scripts/hv_get_dns_info && \
    cp -a hv_set_ifconfig.sh /dist/scripts/hv_set_ifconfig && \
    cp lsvmbus /dist/bin

FROM debian:stable-slim
# FROM arm64=skip arm=skip

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/* && \
    mkdir -p /usr/libexec/hypervkvpd/

COPY --from=build-essential /dist/bin/* /usr/bin/
COPY --from=build-essential /dist/scripts/* /usr/libexec/hypervkvpd/

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
