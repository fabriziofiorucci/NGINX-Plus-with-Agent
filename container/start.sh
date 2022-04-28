#!/bin/bash

#nginx -g "daemon off;"
nginx
sleep 2
nginx-agent --server-grpcport $NIM_GRPC_PORT --server-host $NIM_HOST --instance-group $NIM_INSTANCEGROUP --tags $NIM_TAGS
