FROM ubuntu:bionic
# FROM arm64=arm64v8/ubuntu:bionic

RUN apt-get update \
    && apt-get install -yq python \
    && rm -rf /var/lib/apt/lists/*

ADD entry.sh /usr/local/bin/
ADD sbin/* /sbin/
ADD usr/local/sbin/* /usr/local/sbin/
ADD usr/local/bin/* /usr/local/bin/
ADD usr/local/lib/* /usr/local/lib/
ADD usr/local/libexec/* /usr/local/libexec/
ADD setup_wonka.sh /setup_wonka.sh
ADD lib/udev/zvol_id /lib/udev/zvol_id
ADD lib/udev/vdev_id /lib/udev/vdev_id
ADD lib/udev/rules.d/60-zvol.rules /lib/udev/rules.d/60-zvol.rules
ADD lib/udev/rules.d/69-vdev.rules /lib/udev/rules.d/69-vdev.rules
ADD lib/udev/rules.d/90-zfs.rules /lib/udev/rules.d/90-zfs.rules

# fix build warnings
RUN mv /usr/local/lib/libnvpair.so.1 /usr/local/lib/libnvpair.so.1.file
RUN ln -s /usr/local/lib/libnvpair.so.1.file /usr/local/lib/libnvpair.so.1
RUN mv /usr/local/lib/libzfs_core.so.1 /usr/local/lib/libzfs_core.so.1.file
RUN ln -s /usr/local/lib/libzfs_core.so.1.file /usr/local/lib/libzfs_core.so.1
RUN mv /usr/local/lib/libuutil.so.1 /usr/local/lib/libuutil.so.1.file
RUN ln -s /usr/local/lib/libuutil.so.1.file /usr/local/lib/libuutil.so.1
RUN mv /usr/local/lib/libzfs.so.2 /usr/local/lib/libzfs.so.2.file
RUN ln -s /usr/local/lib/libzfs.so.2.file /usr/local/lib/libzfs.so.2
RUN mv /usr/local/lib/libzpool.so.2 /usr/local/lib/libzpool.so.2.file
RUN ln -s /usr/local/lib/libzpool.so.2.file /usr/local/lib/libzpool.so.2

ENV PATH=$PATH:/usr/local/lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

RUN ldconfig

ENTRYPOINT ["/usr/local/bin/entry.sh"]
