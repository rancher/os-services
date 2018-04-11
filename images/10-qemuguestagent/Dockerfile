FROM alpine:3.7
# FROM amd64=skip arm64=skip

RUN apk add --no-cache qemu-guest-agent

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]