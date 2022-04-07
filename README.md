# NGINX Plus + NGINX Instance Manager 2.x Agent - Docker image

## Description

This repository can be used to build a docker image with NGINX Plus and NGINX Instance Manager 2 Agent (https://docs.nginx.com/nginx-instance-manager/).
To run NGINX Instance Manager on Kubernetes see https://github.com/fabriziofiorucci/NGINX-NIM2-Docker

## Prerequisites

- Linux host running Docker to build the image
- NGINX Plus license
- One running instance of NGINX Instance Manager 2.1.0 (https://docs.nginx.com/nginx-instance-manager/)
- Openshift/Kubernetes cluster

## How to build

1. Clone this repository
2. Copy NGINX Plus license files `nginx-repo.crt` and `nginx-repo.key` into `container/`
3. Get NGINX Instance Manager 2.x agent .deb package for `linux_amd64` (ie. `nginx-agent_2.14.0_linux_amd64.deb`) and copy it into `nim-files/`. The agent's .deb package can be found on NGINX Instance Manager instance under `/var/www/nms/packages-repository/deb/debian/pool/agent/n/nginx-agent/` as of release 2.1.0
4. Optionally edit `container/nginx-agent.conf` and set `host:` and `grpcPort:` to point to your NGINX Instance Manager instance. Default values `host: nginx-nim2.nginx-nim2` and `grpcPort: 443` work with https://github.com/fabriziofiorucci/NGINX-NIM2-Docker
5. Build the Docker image using:

```
$ ./scripts/build.sh [nginx-agent debfile] [image name]

for instance:

$ ./scripts/build.sh container/nginx-agent_2.14.0_linux_amd64.deb registry.ff.lan:31005/nginx-with-nim2-agent:2.14.0
```

the build script pushes the image to your private registry

6. Edit `manifests/1.nginx-nim.yaml` and specify the correct image by modifying the `image:` line

7. Start and stop using

```
$ ./scripts/nginxWithAgentStart.sh start
$ ./scripts/nginxWithAgentStart.sh stop
```

8. After startup NGINX Plus instances will register to NGINX Instance Manager and will be displayed on the "instances" dashboard


## Tested NGINX Instance Manager releases

This repository has been tested with NGINX Instance Manager 2.1.0
