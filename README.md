# NGINX Plus + NGINX Instance Manager 2.x Agent - Docker image

## Description

This repository can be used to build a docker image with NGINX Plus and NGINX Instance Manager 2 Agent (https://docs.nginx.com/nginx-instance-manager/).

## Prerequisites

- Linux host running Docker to build the image
- NGINX Plus license
- One running instance of NGINX Instance Manager 2.1.0+ (https://docs.nginx.com/nginx-instance-manager/)
- Openshift/Kubernetes cluster

## How to build

1. Clone this repository
2. Copy NGINX Plus license files `nginx-repo.crt` and `nginx-repo.key` into `container/`
3. Get NGINX Instance Manager 2.x agent .deb or .rpm package for `linux_amd64` (ie. `nginx-agent_2.14.0_linux_amd64.deb`) and copy it into `container/`.
   - The agent's package can be found on NGINX Instance Manager 
instance under `/var/www/nms/packages-repository/deb/debian/pool/agent/n/nginx-agent/` (.deb package) or `/var/www/nms/packages-repository/rpm/redhatenterprise/8/x86_64/RPMS/` (.rpm package) as of NGINX Instance 
Manager release 2.1.0+
   - If `.deb` is used the image will be based on Debian
   - If `.rpm` is used the image will be based on CentOS
4. Build the Docker image using:

```
$ ./scripts/build.sh [nginx-agent package file .deb or .rpm] [image name]

for instance:

$ ./scripts/build.sh container/nginx-agent_2.14.0_linux_amd64.deb registry.ff.lan:31005/nginx-with-nim2-agent:2.14.0
```

the build script pushes the image to your private registry

5. Edit `manifests/1.nginx-nim.yaml` and specify the correct image by modifying the `image:` line, and set the following environment variables. Default values for `NIM_HOST` and `NIM_GRPC_PORT` can be used if NGINX Instance Manager is deployed using https://github.com/fabriziofiorucci/NGINX-NIM2-Docker
  - `NIM_HOST` - NGINX Instance Manager hostname/IP address
  - `NIM_GRPC_PORT` - NGINX Instance Manager gRPC port.
  - `NIM_INSTANCEGROUP` - instance group for the NGINX Kubernetes Deployment
  - `NIM_TAGS` - comma separated list of tags for the NGINX Kubernetes Deployment

6. Start and stop using

```
$ ./scripts/nginxWithAgentStart.sh start
$ ./scripts/nginxWithAgentStart.sh stop
```

7. After startup NGINX Plus instances will register to NGINX Instance Manager and will be displayed on the "instances" dashboard


## Tested NGINX Instance Manager releases

This repository has been tested with NGINX Instance Manager 2.1.0 to 2.4.0
