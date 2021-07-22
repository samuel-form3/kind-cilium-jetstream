#!/usr/bin/env bash

CLUSTER_NAME=$1

helm uninstall nats \
   --namespace default \
   --kube-context kind-$CLUSTER_NAME