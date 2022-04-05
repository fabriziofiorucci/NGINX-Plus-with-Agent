#!/bin/bash

# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/#docker_plus

if [ "$2" = "" ]
then
	echo -e "$0 [nginx-agent debfile] [image name]

Example:
\t$0 container/nginx-agent_2.13.0_linux_amd64.deb registry.ff.lan:31005/nginx-with-nim2-agent:2.13.0
"
	exit
fi

AGENTFILE=$1
IMAGENAME=$2

echo "Building with agent: $AGENTFILE"
echo "Creating image     : $IMAGENAME"

DOCKER_BUILDKIT=1 docker build --build-arg NGINX_AGENT_DEB=$AGENTFILE -t $IMAGENAME .

echo "Build complete, docker image is $IMAGENAME"
docker push $IMAGENAME
