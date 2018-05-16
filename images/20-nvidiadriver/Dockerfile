FROM centos:7
# FROM amd64=centos:7.4.1708 arm64=arm64v8/centos:7

ENV distribution centos7

RUN yum install -y iptables openssh-server rsync sudo vim less ca-certificates psmisc htop procps-ng iproute curl\
    gcc kernel-devel kernel-headers \
    && yum clean all \
    && rm -rf /etc/ssh/*key*

RUN echo "KERNEL_VERSION" = ${distribution}

RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.repo | \
    sudo tee /etc/yum.repos.d/nvidia-container-runtime.repo

RUN yum install -y nvidia-container-runtime

WORKDIR /dist
COPY build.sh /dist/
COPY ubuntu-build.sh /dist/

RUN chmod 755 /dist/build.sh

CMD ["/dist/build.sh"]

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]