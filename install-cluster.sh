#!/usr/bin/env bash

CLUSTER_NAME=$1

helm upgrade -i nats nats/nats \
   --namespace default \
   --kube-context kind-$CLUSTER_NAME \
   -f ./$CLUSTER_NAME/nats-cluster-values.yaml