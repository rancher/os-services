# Nvidia-driver
Support Nvidia-docker (Currently only support Ubuntu Console)

## Building

### Switch console
ros console switch ubuntu

### Enable nvidia service
ros service enable nvidia-driver

ros service up nvidia-driver

### Manual execution of build.sh scripts (Ignoring CC version mismatch)
/var/lib/rancher/nvidia/build.sh


## Verification
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi


```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 390.48                 Driver Version: 390.48                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla K80           Off  | 00000000:00:1E.0 Off |                    0 |
| N/A   35C    P0    72W / 149W |      0MiB / 11441MiB |     98%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```