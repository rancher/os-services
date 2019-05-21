FROM ubuntu:bionic
# FROM arm64=arm64v8/ubuntu:bionic

RUN apt-get update \
    && apt-get install -yq \
	libssl1.0.0 \
	libmount1

ADD entry.sh /usr/local/bin/
ADD sbin/* /sbin/
ADD etc/iscsi/ /etc/iscsi/
ADD etc/isns/ /etc/isns/
ADD usr/local/sbin/* /usr/local/sbin/
#ADD usr/local/bin/* /usr/local/bin/
ADD usr/local/lib/* /usr/local/lib/
#ADD usr/local/libexec/* /usr/local/libexec/
ADD setup_wonka.sh /setup_wonka.sh

RUN mkdir -p /run/lock

ENTRYPOINT ["/usr/local/bin/entry.sh"]
