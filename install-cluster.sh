#!/usr/bin/env bash

CLUSTER_NAME=$1

kubectl apply -f ./common/nats-server-tls-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

helm upgrade -i nats nats/nats \
   --namespace default \
   --kube-context kind-$CLUSTER_NAME \
   -f ./$CLUSTER_NAME/nats-cluster-values.yaml