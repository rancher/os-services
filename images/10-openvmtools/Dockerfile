FROM ubuntu:16.10
# FROM arm=skip arm64=skip

# net-tools for ifconfig, iproute for ip
RUN apt-get update \
    && apt-get install -y open-vm-tools net-tools iproute \
    && rm -rf /var/lib/apt/*

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
