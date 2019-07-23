#!/bin/sh
set -ex


KERNEL_VERSION=$(uname -r)
echo "open-iscsi for ${KERNEL_VERSION}"

DIR=/lib/modules/${KERNEL_VERSION}/build
STAMP=/lib/modules/${KERNEL_VERSION}/.open-iscsi-done

if [ -e $STAMP ]; then
    modprobe iscsi_tcp
    system-docker run --rm iscsi-tools cat /setup_wonka.sh > /setup_wonka.sh
    chmod 755 /setup_wonka.sh
    # setup wonka in the console container
    /setup_wonka.sh console

    echo open-iscsi for ${KERNEL_VERSION} already installed. Delete $STAMP to reinstall
    exit 0
fi

#TODO: test that the headers are there
#TODO: or, if we continue to be able to use the docker daemon, can we use ros to enable and up it?
ros service enable kernel-headers-system-docker
ros service up kernel-headers-system-docker


VERSION="0.98"
curl -sL https://github.com/open-iscsi/open-isns/archive/v${VERSION}.tar.gz > open-isns${VERSION}.tar.gz
tar zxvf open-isns${VERSION}.tar.gz
rm -rf /dist/isns
mv open-isns-${VERSION}/ /dist/isns/

VERSION="2.0.873"
curl -sL https://github.com/open-iscsi/open-iscsi/archive/${VERSION}.tar.gz > open-iscsi${VERSION}.tar.gz
tar zxvf open-iscsi${VERSION}.tar.gz
rm -rf /dist/iscsi
mv open-iscsi-${VERSION}/ /dist/iscsi/

cd /dist/isns
./configure
make -s -j$(nproc)
#make install
#make install_hdrs
#make install_lib

cd /dist/iscsi
make -s -j$(nproc)
#make install

# last layer - we could use stratos :)
cd /dist/isns
make DESTDIR=/dist/arch install
make DESTDIR=/dist/arch install_hdrs
make DESTDIR=/dist/arch install_lib
cd /dist/iscsi
make DESTDIR=/dist/arch install
cd /dist

cp /dist/Dockerfile.iscsi-tools /dist/arch/Dockerfile
cp /dist/entry.sh /dist/arch/

# how do I export the commands to the console?
# in the future, it'd be nice to have some share /usr/local/bin, but that might interfere with other things.
# we do seem to have /opt mapped
echo "#!/bin/sh" > /dist/arch/setup_wonka.sh
echo "echo installing wonka bin links in \${1}" >> /dist/arch/setup_wonka.sh
chmod 755 /dist/arch/setup_wonka.sh
#for i in $(ls arch/usr/local/bin); do
#   echo "system-docker cp wonka.sh \${1}:/usr/bin/$i" >> /dist/arch/setup_wonka.sh
#done
for i in $(ls arch/usr/local/sbin); do
   echo "system-docker cp wonka.sh \${1}:usr/sbin/$i" >> /dist/arch/setup_wonka.sh
done
for i in $(ls arch/sbin); do
   echo "system-docker cp wonka.sh \${1}:/sbin/$i" >> /dist/arch/setup_wonka.sh
done
chmod 755 /dist/arch/setup_wonka.sh

if [ "XX$HTTP_PROXY" != "XX" ]; then
    BUILD_ARGS="--build-arg HTTP_PROXY --build-arg http_proxy="$HTTP_PROXY
fi

if [ "XX$HTTPS_PROXY" != "XX" ]; then
    BUILD_ARGS=$BUILD_ARGS" --build-arg HTTPS_PROXY --build-arg https_proxy="$HTTPS_PROXY
fi

if [ "XX$NO_PROXY" != "XX" ]; then
    BUILD_ARGS=$BUILD_ARGS" --build-arg NO_PROXY --build-arg no_proxy="$NO_PROXY
fi

system-docker build --network=host $BUILD_ARGS -t iscsi-tools arch/

modprobe iscsi_tcp

# setup wonka in the console container
/dist/arch/setup_wonka.sh console

touch $STAMP
echo open-iscsi for ${KERNEL_VERSION} installed. Delete $STAMP to reinstall
