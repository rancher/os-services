FROM alpine:latest
# FROM arm64=skip arm=skip

RUN apk -Uuv add bash jq ca-certificates groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

ADD ./entry.sh /entry.sh
ADD ./ec2-metadata /lib/ec2-metadata
RUN chmod +x /*.sh

ENV AWS_METADATA_LOAD "true"
ENV AWS_METADATA_TAG_PREFIXES "docker."
ENV AWS_METADATA_TAG_VARIABLES ""

ENTRYPOINT [ "/entry.sh" ]
