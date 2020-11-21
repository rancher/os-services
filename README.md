# os-images
Docker Images for RancherOS

## Building

Run `make`

## Details

### Multi-arch Dockerfiles

As a pre-cursor to native multi-arch support, we leverage some features of
[dapper](https://github.com/burmilla/dapper).

In the Dockerfiles, you'll see lines like:

```
FROM rancher/os-centosconsole-base
# FROM amd64=centos:7 arm64=skip arm=skip
```

The `rancher/os-centosconsole-base` does not actually exist. Dapper will download the
arch specific image listed in the commented out `# FROM` line, and tag that, so the
build can occur.

## Special Entrypoint and CMD

Console images also use special ENTRYPOINT and CMD settings, which are bind mounted
into the container at run time:

```
ENTRYPOINT ["/usr/bin/ros", "entrypoint"]
```

## Misc details

The sshd is configured to accept logins from users in the `docker` group, and `root` is denied.

## Contact
For bugs, questions, comments, corrections, suggestions, etc., open an issue in
 [rancher/os](//github.com/burmilla/os/issues) with a title starting with `[os-images] `.

Or just [click here](//github.com/burmilla/os/issues/new?title=%5Bos-images%5D%20) to create a new issue.

## License

Copyright (c) 2020 Project Burmilla

Copyright (c) 2014-2020 [Rancher Labs, Inc.](http://rancher.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
