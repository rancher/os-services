FROM ubuntu:bionic
# FROM arm64=arm64v8/ubuntu:bionic

RUN apt-get update && \
    apt-get install -y curl git wget unzip

ENV DAPPER_ENV VERSION DEV_BUILD
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_SOURCE /go/src/github.com/rancher/os-images
ENV DAPPER_OUTPUT ./dist
ENV DAPPER_RUN_ARGS --privileged
ENV SHELL /bin/bash
WORKDIR ${DAPPER_SOURCE}

########## General Configuration #####################
ARG DAPPER_HOST_ARCH=amd64
ARG HOST_ARCH=${DAPPER_HOST_ARCH}
ARG ARCH=${HOST_ARCH}

ARG OS_REPO=rancher
ARG DOCKER_VERSION=1.10.3
ARG DOCKER_PATCH_VERSION=v${DOCKER_VERSION}-ros1

ARG DOCKER_URL_amd64=https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}
ARG DOCKER_URL_arm=https://github.com/rancher/docker/releases/download/${DOCKER_PATCH_VERSION}/docker-${DOCKER_VERSION}_arm
ARG DOCKER_URL_arm64=https://github.com/rancher/docker/releases/download/${DOCKER_PATCH_VERSION}/docker-${DOCKER_VERSION}_arm64

ARG IMAGE_BUILD_NAME=[1-9]*

######################################################

# Set up environment
ENV DOCKER_URL DOCKER_URL_${ARCH}

# Export all ARGS as ENV
ENV ARCH=${ARCH} 
ENV DISTRIB_ID=${DISTRIB_ID}
ENV DOCKER_PATCH_VERSION=${DOCKER_PATCH_VERSION}
ENV DOCKER_URL=${DOCKER_URL}
ENV DOCKER_URL_amd64=${DOCKER_URL_amd64}
ENV DOCKER_URL_arm64=${DOCKER_URL_arm64}
ENV DOCKER_URL_arm=${DOCKER_URL_arm}
ENV DOCKER_VERSION=${DOCKER_VERSION}
ENV HOST_ARCH=${HOST_ARCH}
ENV OS_REPO=${OS_REPO}

# Meaningful ENV
ENV IMAGE_BUILD_NAME=${IMAGE_BUILD_NAME}

RUN rm /bin/sh && \
    ln -s /bin/bash /bin/sh

# Install Docker
RUN curl -fL ${!DOCKER_URL} > /usr/bin/docker && \
    chmod +x /usr/bin/docker

# Install dapper
RUN curl -sL https://releases.rancher.com/dapper/latest/dapper-`uname -s`-`uname -m | sed 's/arm.*/arm/'` > /usr/bin/dapper && \
    chmod +x /usr/bin/dapper

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
