#!/usr/bin/env bash

CLUSTER_NAME=$1

kubectl delete secret nats-server-tls \
   --namespace default \
   --context kind-$CLUSTER_NAME

helm uninstall nats \
   --namespace default \
   --kube-context kind-$CLUSTER_NAME
