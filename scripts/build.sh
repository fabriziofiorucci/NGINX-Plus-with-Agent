#!/bin/bash

# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/#docker_plus

BANNER="NGINX Plus & NGINX Instance Manager agent Docker image builder\n\n
This tool builds a Docker image to run NGINX Plus and NGINX Instance Manager agent\n\n
=== Usage:\n\n
$0 [options]\n\n
=== Options:\n\n
-h\t\t\t- This help\n
-t [target image]\t- The Docker image to be created\n
-C [file.crt]\t\t- Certificate to pull packages from the official NGINX repository\n
-K [file.key]\t\t- Key to pull packages from the official NGINX repository\n
-n [URL]\t\t- NGINX Instance Manager URL to fetch the agent\n\n
=== Examples:\n\n

$0 -C nginx-repo.crt -K nginx-repo.key -t registry.ff.lan:31005/nginx-with-nim2-agent:2.7.0 -n https://nim.f5.ff.lan\n
"

while getopts 'ht:C:K:a:n:' OPTION
do
	case "$OPTION" in
		h)
			echo -e $BANNER
			exit
		;;
		t)
			IMAGENAME=$OPTARG
		;;
		C)
			NGINX_CERT=$OPTARG
		;;
		K)
			NGINX_KEY=$OPTARG
		;;
		n)
			NMSURL=$OPTARG
		;;
	esac
done

if [ -z "$1" ]
then
	echo -e $BANNER
	exit
fi

if [ -z "${IMAGENAME}" ]
then
        echo "Docker image name is required"
        exit
fi

if [ -z "${NMSURL}" ]
then
        echo "NGINX Instance Manager URL is required"
        exit
fi

if ([ -z "${NGINX_CERT}" ] || [ -z "${NGINX_KEY}" ])
then
        echo "NGINX certificate and key are required for automated installation"
        exit
fi

echo "=> Target docker image is $IMAGENAME"

DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile --build-arg NGINX_CERT=$NGINX_CERT \
	--build-arg NGINX_KEY=$NGINX_KEY --build-arg NMS_URL=$NMSURL -t $IMAGENAME .

echo "=> Build complete for $IMAGENAME"
docker push $IMAGENAME
