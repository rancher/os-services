#!/bin/bash
INSTANCE="${1}"
TAG_FILTER=''
[ "$2" ] && TAG_FILTER="| select(.Key|startswith(\"${2}\"))"

echo "#cloud-config"
echo "rancher:"
echo "  docker:"
echo "    args:"

ros config get rancher.docker.args | grep -v '\[\]' | grep -v '^\s*$' | sed 's/^/      /'

aws ec2 describe-tags --region "${AWS_DEFAULT_REGION}" --filters "Name=resource-id,Values=${INSTANCE}" 2>/dev/null \
  | jq -r ".Tags[] ${TAG_FILTER} | \"\(.Key)=\(.Value)\"" 2>/dev/null \
  | while read label; do
    echo "      - --label"
    echo "      - ${label}"
  done
