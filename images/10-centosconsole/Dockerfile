FROM rancher/os-centosconsole-base
# FROM amd64=centos:7.5.1804 arm64=arm64v8/centos:7

COPY prompt.sh /etc/profile.d/
COPY build/sshd_config.append.tpl /etc/ssh/

RUN yum install -y iptables openssh-server rsync sudo \
                    vim less ca-certificates psmisc htop \
                    procps-ng iproute openssh-clients bash-completion wget \
    && yum clean all \
    && rm -rf /etc/ssh/*key* \
    && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
    && groupadd --gid 1100 rancher \
    && groupadd --gid 1101 docker \
    && useradd -u 1100 -g rancher -G docker,wheel -m -s /bin/bash rancher \
    && useradd -u 1101 -g docker -G docker,wheel -m -s /bin/bash docker \
    && echo '## allow password less for rancher user' >> /etc/sudoers \
    && echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '## allow password less for docker user' >> /etc/sudoers \
    && echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && cat /etc/ssh/sshd_config > /etc/ssh/sshd_config.tpl \
    && cat /etc/ssh/sshd_config.append.tpl >> /etc/ssh/sshd_config.tpl \
    && rm -f /etc/ssh/sshd_config.append.tpl /etc/ssh/sshd_config
ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
