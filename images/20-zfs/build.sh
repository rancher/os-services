#!/bin/sh
set -ex


KERNEL_VERSION=$(uname -r)
echo "zfs for ${KERNEL_VERSION}"

DIR=/lib/modules/${KERNEL_VERSION}/build
STAMP=/lib/modules/${KERNEL_VERSION}/.zfs-done

if [ -e $STAMP ]; then
    modprobe zfs

    system-docker run --rm zfs-tools cat /setup_wonka.sh > /setup_wonka.sh
    chmod 755 /setup_wonka.sh
    # setup wonka in the console container
    /setup_wonka.sh console
    # setup wonka in this container so the import works
    /setup_wonka.sh zfs

    # re-init the zpool from disk
    zpool import -a
    echo ZFS for ${KERNEL_VERSION} already installed. Delete $STAMP to reinstall
    exit 0
fi

#TODO: test that the headers are there
#TODO: or, if we continue to be able to use the docker daemon, can we use ros to enable and up it?
ros service enable kernel-headers-system-docker
ros service up kernel-headers-system-docker


# get the zfs source as per https://github.com/zfsonlinux/zfs/wiki/Building-ZFS
VERSION="0.7.13"
curl -sL https://github.com/zfsonlinux/zfs/releases/download/zfs-${VERSION}/spl-${VERSION}.tar.gz > spl-${VERSION}.tar.gz
curl -sL https://github.com/zfsonlinux/zfs/releases/download/zfs-${VERSION}/zfs-${VERSION}.tar.gz > zfs-${VERSION}.tar.gz
mkdir -p spl
tar zxvf spl-${VERSION}.tar.gz --strip-components=1 -C spl
mkdir -p zfs
tar zxvf zfs-${VERSION}.tar.gz --strip-components=1 -C zfs

#if [ -d "spl" ]; then
#   cd spl
#   git pull
#   cd ..
#else
#   git clone https://github.com/zfsonlinux/spl
#fi
#if [ -d "zfs" ]; then
#   cd zfs
#   git pull
#   cd ..
#else
#   git clone https://github.com/zfsonlinux/zfs
#fi
#if [ "$(echo ${KERNEL_VERSION} | cut -c1-3)" = "4.9" ]; then
#    echo "Detected $KERNEL_VERSION, using zfs master for now"
#    cd spl
#    git checkout master
#    cd ..
#    cd zfs
#    git checkout master
#    cd ..
#else
#    cd spl
#    git checkout spl-0.6.5-release
#    cd ..
#    cd zfs
#    git checkout zfs-0.6.5-release
#    cd ..
#fi
#

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
          --with-linux=${DIR}
make -s -j$(nproc)

cd /dist/zfs
sh ./autogen.sh
./configure \
          --with-linux=${DIR}
make -s -j$(nproc)

# last layer - we could use stratos :)
cd /dist/spl
make DESTDIR=/dist/arch install
cd /dist/zfs
make DESTDIR=/dist/arch install
cd /dist

cp -r /dist/arch/lib/modules/${KERNEL_VERSION}/extra /lib/modules/${KERNEL_VERSION}/
depmod

cd /dist/zfs
LIB_DIR=/dist/arch/usr/local/lib scripts/zfs-helpers.sh -i
cd /dist

cp /dist/Dockerfile.zfs-tools /dist/arch/Dockerfile
cp /dist/entry.sh /dist/arch/

# how do I export the commands to the console?
# in the future, it'd be nice to have some share /usr/local/bin, but that might interfere with other things.
# we do seem to have /opt mapped
echo "#!/bin/sh" > /dist/arch/setup_wonka.sh
echo "echo installing wonka bin links in \${1}" >> /dist/arch/setup_wonka.sh
chmod 755 /dist/arch/setup_wonka.sh
for i in $(ls arch/usr/local/bin); do
    echo "system-docker cp wonka.sh \${1}:/usr/bin/$i" >> /dist/arch/setup_wonka.sh
done
for i in $(ls arch/usr/local/sbin); do
    echo "system-docker cp wonka.sh \${1}:usr/sbin/$i" >> /dist/arch/setup_wonka.sh
done
for i in $(ls arch/sbin); do
    echo "system-docker cp wonka.sh \${1}:/sbin/$i" >> /dist/arch/setup_wonka.sh
done
for i in $(ls arch/usr/local/lib); do
    echo "system-docker cp wonka.sh \${1}:usr/lib/$i" >> /dist/arch/setup_wonka.sh
done

system-docker cp arch/lib/udev/zvol_id udev:/lib/udev/zvol_id
system-docker cp arch/lib/udev/vdev_id udev:/lib/udev/vdev_id
system-docker cp arch/lib/udev/rules.d/60-zvol.rules udev:/etc/udev/rules.d/60-zvol.rules
system-docker cp arch/lib/udev/rules.d/69-vdev.rules udev:/etc/udev/rules.d/69-vdev.rules
system-docker cp arch/lib/udev/rules.d/90-zfs.rules udev:/etc/udev/rules.d/90-zfs.rules

if [ "XX$HTTP_PROXY" != "XX" ]; then
    BUILD_ARGS="--build-arg HTTP_PROXY --build-arg http_proxy="$HTTP_PROXY
fi

if [ "XX$HTTPS_PROXY" != "XX" ]; then
    BUILD_ARGS=$BUILD_ARGS" --build-arg HTTPS_PROXY --build-arg https_proxy="$HTTPS_PROXY
fi

if [ "XX$NO_PROXY" != "XX" ]; then
    BUILD_ARGS=$BUILD_ARGS" --build-arg NO_PROXY --build-arg no_proxy="$NO_PROXY
fi

system-docker build --network=host $BUILD_ARGS -t zfs-tools arch/

modprobe zfs

/dist/arch/setup_wonka.sh console
/dist/arch/setup_wonka.sh zfs
zpool import -a

touch $STAMP
echo ZFS for ${KERNEL_VERSION} installed. Delete $STAMP to reinstall
