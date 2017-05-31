FROM alpine:latest
# FROM arm64=skip arm=skip

ARG netshare_plugin_version=0.19

RUN apk add --update wget nfs-utils ca-certificates &&\
    rm -rf /var/cache/apk/* &&\
    update-ca-certificates

RUN wget -O /usr/bin/docker-volume-netshare https://github.com/ContainX/docker-volume-netshare/releases/download/v${netshare_plugin_version}/docker-volume-netshare_${netshare_plugin_version}_linux_amd64-bin \
&& chmod +x /usr/bin/docker-volume-netshare

ENTRYPOINT ["/usr/bin/docker-volume-netshare"]
CMD ["efs"]
