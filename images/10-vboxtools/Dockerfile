FROM gcc:7.4.0 as build-essential
ENV KERNEL_VERSION 4.14.138-rancher

ENV KERNEL_HEADERS https://github.com/rancher/os-kernel/releases/download/v${KERNEL_VERSION}/build-linux-${KERNEL_VERSION}-x86.tar.gz
ENV KERNEL_BASE https://github.com/rancher/os-kernel/releases/download/v${KERNEL_VERSION}/linux-${KERNEL_VERSION}-x86.tar.gz
ENV VBOX_VERSION 5.2.26
ENV VBOX_SHA256 b927c5d0d4c97a9da2522daad41fe96b616ed06bfb0c883f9c42aad2244f7c38

RUN apt-get update; \
	apt-get install -y --no-install-recommends p7zip-full libelf-dev; \
	apt-get clean; \
	rm -rf /var/lib/apt/*
RUN mkdir -p /usr/src/v${KERNEL_VERSION}; \
	curl -sfL ${KERNEL_BASE} | tar zxf - -C /; \
	curl -sfL ${KERNEL_HEADERS} | tar zxf - -C /usr/src/v${KERNEL_VERSION}
RUN wget -O /vbox.iso "https://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso"; \
	echo "$VBOX_SHA256 */vbox.iso" | sha256sum -c -; \
	7z x -o/ /vbox.iso VBoxLinuxAdditions.run; \
	rm /vbox.iso; \
	sh /VBoxLinuxAdditions.run --noexec --target /usr/src/vbox; \
	mkdir /usr/src/vbox/amd64; \
	7z x -so /usr/src/vbox/VBoxGuestAdditions-amd64.tar.bz2 | tar --extract --directory /usr/src/vbox/amd64; \
	rm /usr/src/vbox/VBoxGuestAdditions-*.tar.bz2; \
	ln -sT "vboxguest-$VBOX_VERSION" /usr/src/vbox/amd64/src/vboxguest
RUN make -C /usr/src/vbox/amd64/src/vboxguest -j "$(nproc)" \
	KERN_DIR='/lib/modules/${KERNEL_VERSION}/build' \
	KERN_VER=${KERNEL_VERSION} \
	vboxguest vboxsf 

FROM debian:stable-slim
WORKDIR /dist
RUN apt-get update; \
        apt-get install -y --no-install-recommends kmod; \
        apt-get clean; \
        rm -rf /var/lib/apt/*
COPY run /usr/local/bin/
COPY --from=build-essential /usr/src/vbox/amd64/src/vboxguest/vboxguest.ko .
COPY --from=build-essential /usr/src/vbox/amd64/src/vboxguest/vboxsf.ko .
COPY --from=build-essential /usr/src/vbox/amd64/other/mount.vboxsf .
COPY --from=build-essential /usr/src/vbox/amd64/sbin/VBoxService /sbin/
COPY --from=build-essential /usr/src/vbox/amd64/bin/VBoxControl /bin/
RUN chmod +x /usr/local/bin/run

CMD ["/usr/local/bin/run"]

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
