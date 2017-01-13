FROM rancher/os-fedoraconsole-base
# FROM amd64=fedora:24 arm64=skip arm=skip
RUN dnf install -y iptables openssh-server rsync sudo vim-minimal less ca-certificates psmisc htop procps-ng \
    && rm -rf /etc/ssh/*key* \
    && rm -fr /sbin/poweroff  /sbin/shutdown /sbin/reboot /sbin/halt /usr/sbin/poweroff  /usr/sbin/shutdown /usr/sbin/reboot /usr/sbin/halt \
    && ln -s /sbin/agetty /sbin/getty
RUN groupadd --gid 1100 rancher \
    && groupadd --gid 1101 docker \
    && useradd -u 1100 -g rancher -G docker,wheel -m -s /bin/bash rancher \
    && useradd -u 1101 -g docker -G docker,wheel -m -s /bin/bash docker \
    && echo ClientAliveInterval 180 >> /etc/ssh/sshd_config \
    && echo '## allow password less for rancher user' >> /etc/sudoers \
    && echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '## allow password less for docker user' >> /etc/sudoers \
    && echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && ln -sf /usr/bin/docker.dist /usr/bin/docker
COPY prompt.sh /etc/profile.d/

RUN dnf install -y git make gcc findutils selinux-policy-devel setools-console setools-devel \
    && git clone https://github.com/rancher/refpolicy.git /usr/src/refpolicy \
    && cd /usr/src/refpolicy && git submodule init && git submodule update \
    && sed -i '/MONOLITHIC = y/c\MONOLITHIC = n' build.conf \
    && make conf && make && make install-headers

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
