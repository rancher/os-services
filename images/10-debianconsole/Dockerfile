FROM rancher/os-debianconsole-base
# FROM amd64=debian:stable arm64=arm64v8/debian:stable arm=arm32v7/debian:stable
RUN apt-get update \
    && apt-get install -y --no-install-recommends iptables openssh-server rsync locales \
                           sudo vim less curl ca-certificates psmisc htop kmod iproute2 \
                           net-tools \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ssh/*key*
RUN locale-gen en_US.UTF-8 \
    && addgroup --gid 1100 rancher \
    && addgroup --gid 1101 docker \
    && useradd -u 1100 -g rancher -G docker,sudo -m -s /bin/bash rancher \
    && useradd -u 1101 -g docker -G docker,sudo -m -s /bin/bash docker \
    && echo ClientAliveInterval 180 >> /etc/ssh/sshd_config \
    && echo '## allow password less for rancher user' >> /etc/sudoers \
    && echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '## allow password less for docker user' >> /etc/sudoers \
    && echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
