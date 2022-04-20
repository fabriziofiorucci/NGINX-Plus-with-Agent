#!/bin/bash

# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/#docker_plus

if [ "$2" = "" ]
then
	echo -e "$0 [nginx-agent package file .deb or .rpm] [image name]

Example:
\t$0 container/nginx-agent_2.14.0_linux_amd64.deb registry.ff.lan:31005/nginx-with-nim2-agent:2.14.0
"
	exit
fi

AGENTFILE=$1
IMAGENAME=$2

echo "Building with agent: $AGENTFILE"
echo "Creating image     : $IMAGENAME"


if [[ "$AGENTFILE" == *rpm ]]
then
	FILE=./Dockerfile.centos
elif [[ "$AGENTFILE" == *deb ]]
then
	FILE=./Dockerfile.debian
fi

DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE --build-arg NGINX_AGENT_PKG=$AGENTFILE -t $IMAGENAME .

echo "Build complete, docker image is $IMAGENAME"
docker push $IMAGENAME
