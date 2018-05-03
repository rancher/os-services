FROM debian:testing-slim
# FROM arm=skip arm64=skip

# net-tools for ifconfig, iproute for ip
RUN apt-get update \
    && apt-get install -y open-vm-tools net-tools iproute2 sudo fuse \
    && rm -rf /var/lib/apt/*

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
