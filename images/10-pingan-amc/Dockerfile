FROM debian:stable-slim

RUN apt-get update && apt-get install -yq --no-install-recommends \
        curl \
        procps \
        iproute2 \
        net-tools && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/cloud
ADD Temp_Init/agent-manager-client-linux-amd64-0.0.6.tar /opt/cloud/
COPY amc-control /usr/bin/amc-control
RUN chmod +x /usr/bin/amc-control && \
    echo '#!/bin/bash' > /usr/local/bin/hostnamectl && \
    chmod a+x /usr/local/bin/hostnamectl

CMD ["/usr/bin/amc-control"]
ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
