FROM rancher/os-ubuntuconsole
# FROM arm64=skip arm=skip
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 slim xfce4-terminal \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
COPY desktop.sh /usr/bin/desktop.sh
CMD ["desktop.sh"]
