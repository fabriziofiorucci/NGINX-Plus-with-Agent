#!/bin/bash

NAMESPACE=nim-test

case $1 in
	'start')
		kubectl create namespace $NAMESPACE

		pushd manifests/
		kubectl create configmap nginx-default-conf -n $NAMESPACE --from-file=default.conf
		kubectl apply -n $NAMESPACE -f .
		popd
	;;
	'stop')
		kubectl delete namespace $NAMESPACE
	;;
	*)
		echo "$0 [start|stop]"
		exit
	;;
esac
