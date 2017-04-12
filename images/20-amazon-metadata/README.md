Based on code from https://github.com/efim-a-efim/rancheros-ec2-metadata

# AWS EC2 Metadata provider for RancherOS

Intended to use with Autoscaling.
- Adds AWS EC2 metadata to RancherOS environment
- Adds instance tags (filtered) to Docker options

## How to use

You can enable the service using cloud-config:
```
services_include:
  amazon-metadata: true
```

OR you can start it manually like this:

```
#cloud-config
rancher:
  services:
    aws-metadata:
      image: rancher/os-amazon-metadata:v0.9.2${SUFFIX}
      command: -m -t 'com.' -l 'com.environment:ENVIRONMENT'
      privileged: true
      labels:
        io.rancher.os.after: network
        io.rancher.os.scope: system
        io.rancher.os.reloadconfig: 'true'
        io.rancher.os.createonly: 'false'
      volumes:
        - /usr/bin/ros:/bin/ros:ro
        - /var/lib/rancher/conf:/var/lib/rancher/conf:rw
```

### Options:
* `-m` - put AWS metadata to the Rancher environment vars. Metadata supported:
  * AWS_AVAILABILITY_ZONE
  * AWS_DEFAULT_REGION
  * AWS_IAM_ROLE
  * AWS_ACCESS_KEY_ID
  * AWS_SECRET_ACCESS_KEY
  * AWS_SECURITY_TOKEN
  * AWS_INSTANCE_ID
  * AWS_AMI_ID
  * AWS_AMI_LAUNCH_INDEX
  * AWS_AMI_MANIFEST_PATH
  * AWS_ANCESTOR_AMI_IDS
  * AWS_HOSTNAME
  * AWS_LOCAL_HOSTNAME
  * AWS_INSTANCE_ACTION
  * AWS_INSTANCE_TYPE
  * AWS_LOCAL_IPV4
  * AWS_PUBLIC_IPV4
  * AWS_SECURITY_GROUPS
* `-t [prefix]` - load EC2 instance tags starting with `prefix` and add them as labels to docker daemon options
* `-l label:variablename` - add `variablename` variable to RancherOS environment that contains value of `label` tag. May be used multiple times
* `-l label:config.path` - add value of `label` tag to `config.path` RancherOS config path. Works when `config.path` has `.` inside.

### Configuration environment variables
* `AWS_METADATA_LOAD` (`true`|`false`) - load metadata from AWS and add corresponding environment variables. See `-m` above.
* `AWS_METADATA_TAG_PREFIXES` (list, separated by `;`) - see `-t` above
* `AWS_METADATA_TAG_VARIABLES` (list, separated by `;`) - see `-l` for variables above