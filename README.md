# NGINX Plus + NGINX Instance Manager 2.x Agent - Docker image

## Description

This repository can be used to build a docker image with NGINX Plus and NGINX Instance Manager 2 Agent (https://docs.nginx.com/nginx-instance-manager/).

## Tested releases

This repository has been tested with NGINX agent for:

- NGINX Instance Manager 2.4.0, 2.5.0, 2.5.1, 2.6.0, 2.7.0

## Prerequisites

- Linux host running Docker to build the image
- NGINX Plus license
- A running [NGINX Instance Manager](https://docs.nginx.com/nginx-instance-manager/) instance
- Openshift/Kubernetes cluster

## Building the docker image

The install script can be used to build the Docker image using automated or manual agent install:

```
$ ./scripts/build.sh 
NGINX Plus & NGINX Instance Manager agent Docker image builder

 This tool builds a Docker image to run NGINX Plus and NGINX Instance Manager agent

 === Usage:

 ./scripts/build.sh [options]

 === Options:

 -h                     - This help
 -t [target image]      - The Docker image to be created
 -C [file.crt]          - Certificate to pull packages from the official NGINX repository
 -K [file.key]          - Key to pull packages from the official NGINX repository
 -n [URL]               - NGINX Instance Manager URL to fetch the agent
 -d                     - Build support for NGINX API Gateway Developer Portal

 === Examples:

 NGINX Plus and NGINX Agent image:
 ./scripts/build.sh -C nginx-repo.crt -K nginx-repo.key -t registry.ff.lan:31005/nginx-with-nim2-agent:2.7.0 -n https://nim.f5.ff.lan

 NGINX Plus with Developer Portal support and NGINX Agent image:
 ./scripts/build.sh -C nginx-repo.crt -K nginx-repo.key -t registry.ff.lan:31005/nginx-with-nim2-agent:2.7.0-devportal -d -n https://nim.f5.ff.lan
```

1. Clone this repository
2. Get your license certificate and key to fetch NGINX Management Suite packages from NGINX repository
3. [Install](https://docs.nginx.com/nginx-management-suite/) and start NGINX Management Suite / NGINX Instance Manager
4. Build the Docker image using:

```
$ ./scripts/build.sh -C nginx-repo.crt -K nginx-repo.key -t registry.ff.lan:31005/nginx-with-nim2-agent:automated -n https://ubuntu.ff.lan
```

the build script will push the image to your private registry once build is complete. The `-d` flag can be used to build a Docker image to run NGINX Plus in [Developer Portal](https://docs.nginx.com/nginx-management-suite/admin-guides/installation/on-prem/install-guide/#install-developer-portal) mode for [API Connectivity Manager](https://docs.nginx.com/nginx-management-suite/acm/about/architecture/)

### Running the docker image

1. Edit `manifests/1.nginx-nim.yaml` and specify the correct image by modifying the `image:` line, and set the following environment variables. Default values for `NIM_HOST` and `NIM_GRPC_PORT` can be used if NGINX Instance Manager is deployed using https://github.com/fabriziofiorucci/NGINX-NIM2-Docker
  - `NIM_HOST` - NGINX Instance Manager hostname/IP address
  - `NIM_GRPC_PORT` - NGINX Instance Manager gRPC port.
  - `NIM_INSTANCEGROUP` - instance group for the NGINX Kubernetes Deployment
  - `NIM_TAGS` - comma separated list of tags for the NGINX Kubernetes Deployment

2. Start and stop using

```
$ ./scripts/nginxWithAgentStart.sh start
$ ./scripts/nginxWithAgentStart.sh stop
```

3. After startup NGINX Plus instances will register to NGINX Instance Manager and will be displayed on the "instances" dashboard
