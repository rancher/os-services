FROM debian:stable-slim

RUN apt-get update && apt-get install -yq --no-install-recommends \
        ifupdown2 \
        ca-certificates \
        openssl \
        sudo \
        net-tools \
        parted \
        iptables \
        eject \
        host \
        python-setuptools \
        openssh-server && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

ADD WALinuxAgent.tar.gz .

RUN cd WALinuxAgent-* && \
    sudo python setup.py install && \
    cd .. && \
    rm -rf WALinuxAgent-* && \
    rm -rf WALinuxAgent.tar.gz

RUN sed -i 's/^#\( AutoUpdate.Enabled=y\)/\1/' /etc/waagent.conf

ENTRYPOINT ["waagent"]

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