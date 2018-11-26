FROM debian:stable-slim

RUN apt-get update && apt-get install -yq --no-install-recommends \
        jq \
        dhcpcd5 \
        iproute2 \
        modemmanager \
        policykit-1 \
        dbus && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

COPY yq_linux_amd64 /usr/bin/yq

COPY modemmanager /usr/bin/modemmanager

RUN chmod +x /usr/bin/yq && \
    mkdir -p /var/run/dbus && chmod +x /usr/bin/modemmanager

CMD ["/usr/bin/modemmanager"]
