# docker-volume-netshare in container

You can enable the service using cloud-config (use corresponding volume type or enable all):
```
services_include:
  volume-efs: true
  volume-nfs: true
  volume-cifs: true
```

Additional options may be specified through environment:
* `VOLUME_CIFS_OPTIONS`
* `VOLUME_EFS_OPTIONS`
* `VOLUME_NFS_OPTIONS`

## AWS EFS

Add following settings to your cloud-config:
```
services_include:
  amazon-metadata: true
  volume-efs: true
```

Use Docker volumes:
```
my-application:
  image: me/my-application
  volume_driver: efs
  volumes:
    - fs-XXyyZZtt:/data
```
