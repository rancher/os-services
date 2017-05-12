#!/bin/sh
echo "#cloud-config"
echo "rancher:"
echo "  environment:"

echo "    AWS_AVAILABILITY_ZONE: ${AWS_AVAILABILITY_ZONE}"
echo "    AWS_DEFAULT_REGION: ${AWS_DEFAULT_REGION}"

if [ "${AWS_IAM_ROLE}" ]; then
  echo "    AWS_IAM_ROLE: ${AWS_IAM_ROLE}"
  echo "    AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}"
  echo "    AWS_SECRET_ACCESS_KE: ${AWS_SECRET_ACCESS_KEY}"
  echo "    AWS_SECURITY_TOKEN: ${AWS_SECURITY_TOKEN}"
fi
echo "    AWS_INSTANCE_ID: ${AWS_INSTANCE_ID}"

echo "    AWS_AMI_ID: $(wget -O- -q "http://169.254.169.254/latest/meta-data/ami-id" 2>/dev/null)"
echo "    AWS_AMI_LAUNCH_INDEX: $(wget -O- -q "http://169.254.169.254/latest/meta-data/ami-launch-index" 2>/dev/null)"
echo "    AWS_AMI_MANIFEST_PATH: $(wget -O- -q "http://169.254.169.254/latest/meta-data/ami-manifest-path" 2>/dev/null)"
echo "    AWS_ANCESTOR_AMI_IDS: $(wget -O- -q "http://169.254.169.254/latest/meta-data/ancestor-ami-ids" 2>/dev/null)"
echo "    AWS_HOSTNAME: $(wget -O- -q "http://169.254.169.254/latest/meta-data/hostname" 2>/dev/null)"
echo "    AWS_LOCAL_HOSTNAME: $(wget -O- -q "http://169.254.169.254/latest/meta-data/local-hostname" 2>/dev/null)"
echo "    AWS_INSTANCE_ACTION: $(wget -O- -q "http://169.254.169.254/latest/meta-data/instance-action" 2>/dev/null)"

echo "    AWS_INSTANCE_TYPE: $(wget -O- -q "http://169.254.169.254/latest/meta-data/instance-type" 2>/dev/null)"
echo "    AWS_LOCAL_IPV4: $(wget -O- -q "http://169.254.169.254/latest/meta-data/local-ipv4" 2>/dev/null)"
echo "    AWS_PUBLIC_IPV4: $(wget -O- -q "http://169.254.169.254/latest/meta-data/public-ipv4" 2>/dev/null)"
echo "    AWS_SECURITY_GROUPS: $(wget -O- -q "http://169.254.169.254/latest/meta-data/security-groups" 2>/dev/null)"
