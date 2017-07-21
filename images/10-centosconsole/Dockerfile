FROM rancher/os-centosconsole-base
# FROM amd64=centos:7 arm64=skip arm=skip
RUN yum install -y iptables openssh-server rsync sudo vim less ca-certificates psmisc htop procps-ng iproute \
    && rm -rf /etc/ssh/*key*
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
    && groupadd --gid 1100 rancher \
    && groupadd --gid 1101 docker \
    && useradd -u 1100 -g rancher -G docker,wheel -m -s /bin/bash rancher \
    && useradd -u 1101 -g docker -G docker,wheel -m -s /bin/bash docker \
    && echo ClientAliveInterval 180 >> /etc/ssh/sshd_config \
    && echo '## allow password less for rancher user' >> /etc/sudoers \
    && echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '## allow password less for docker user' >> /etc/sudoers \
    && echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
COPY prompt.sh /etc/profile.d/
ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
