#!/bin/bash

docker run --rm --name nginx -p 80:80 -p 443:443 \
        -e "NIM_HOST=<NGINX_INSTANCE_MANAGER_FQDN>" \
        -e "NIM_GRPC_PORT=443" \
        -e "NIM_TOKEN=<OPTIONAL_AUTHENTICATION_TOKEN>" \
        -e "NIM_INSTANCEGROUP=<OPTIONAL_INSTANCE_GROUP_NAME>" \
        -e "NIM_TAGS=<OPTIONAL_COMMA_DELIMITED_TAG_LIST>" \
        -e "NIM_ADVANCED_METRICS=[true|false]" \
        -e NAP_WAF=[true|false] \
        -e NAP_WAF_PRECOMPILED_POLICIES=[true|false] \
	<NGINX_DOCKER_IMAGE_NAME:TAG>
