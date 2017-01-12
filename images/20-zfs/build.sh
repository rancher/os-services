#!/bin/sh
set -ex

setupconsolecommands()
{
    # how do I export the commands to the console?
    # in the future, it'd be nice to have some share /usr/local/bin, but that might interfere with other things.
    # we do seem to have /opt mapped

    for i in $(ls arch/bin); do
       system-docker cp wonka.sh console:/usr/bin/$i
    done
    for i in $(ls arch/sbin); do
       system-docker cp wonka.sh console:/usr/sbin/$i
    done
}

KERNEL_VERSION=$(uname -r)
echo "zfs for ${KERNEL_VERSION}"

DIR=/lib/modules/${KERNEL_VERSION}/build
STAMP=/lib/modules/${KERNEL_VERSION}/.zfs-done

if [ -e $STAMP ]; then
    setupconsolecommands
    echo ZFS for ${KERNEL_VERSION} already installed. Delete $STAMP to reinstall
    exit 0
fi

#TODO: test that the headers are there
#TODO: or, if we continue to be able to use the docker daemon, can we use ros to enable and up it?
ros service enable kernel-headers-system-docker
ros service up kernel-headers-system-docker


# get the zfs source as per https://github.com/zfsonlinux/zfs/wiki/Building-ZFS
#ENV VERSION 0.6.5.8
# need 0.7.0 for linux 4.9
#ENV VERSION 0.7.0-rc2
#RUN curl -sL https://github.com/zfsonlinux/zfs/releases/download/zfs-${VERSION}/spl-${VERSION}.tar.gz > spl-${VERSION}.tar.gz \
#curl -sL https://github.com/zfsonlinux/zfs/releases/download/zfs-${VERSION}/zfs-${VERSION}.tar.gz > zfs-${VERSION}.tar.gz
#tar zxvf spl-${VERSION}.tar.gz
#tar zxvf zfs-${VERSION}.tar.gz
#ENV VERSION 0.7.0
# 0.7.0-rc2 not enough for 4.9
if [ -d "spl" ]; then
   cd spl
   git pull
   cd ..
else
   git clone https://github.com/zfsonlinux/spl
fi
if [ -d "zfs" ]; then
   cd zfs
   git pull
   cd ..
else
   git clone https://github.com/zfsonlinux/zfs
fi

# get headers for the kernel we're building for
#ENV LINUX 4.9.2-rancher
#RUN curl -sL https://github.com/rancher/os-kernel/releases/download/v${LINUX}/build-linux-${LINUX}-x86.tar.gz > build-linux-${LINUX}-x86.tar.gz
#
#RUN mkdir ${LINUX}
#RUN cd ${LINUX}
#tar zxvf ../build-linux-${LINUX}-x86.tar.gz


#   --prefix=/dist
cd /dist/spl
sh ./autogen.sh
./configure \
          --exec-prefix=/dist/arch \
          --with-linux=${DIR}
make -s -j$(nproc)

cd /dist/zfs
sh ./autogen.sh
./configure \
          --exec-prefix=/dist/arch \
          --with-linux=${DIR}
make -s -j$(nproc)

# last layer - we could use stratos :)
cd /dist/spl
make install
cd /dist/zfs
make install
cd /dist

depmod

cp /dist/Dockerfile.zfs-tools /dist/arch/Dockerfile
system-docker build -t zfs-tools arch/

setupconsolecommands

touch $STAMP
echo ZFS for ${KERNEL_VERSION} installed. Delete $STAMP to reinstall
