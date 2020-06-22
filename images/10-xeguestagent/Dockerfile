FROM alpine:latest

ADD xe-daemon /usr/local/sbin/
ADD xe-ros-version /usr/local/bin/
ADD xenstore /usr/local/bin/
ADD run /usr/local/bin/

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
