#!/usr/bin/env bash

CLUSTER_NAME=$1

# provision cluster
kind create cluster --config=./$CLUSTER_NAME/kind-cluster.yaml --name=$CLUSTER_NAME

# setup metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml --context=kind-$CLUSTER_NAME
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" --context=kind-$CLUSTER_NAME
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml --context=kind-$CLUSTER_NAME
kubectl apply -f ./$CLUSTER_NAME/metallb-config-map.yaml --context=kind-$CLUSTER_NAME

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.4.0 \
  --set installCRDs=true \
  --set prometheus.enabled=false

# setup coredns
kubectl apply -f ./$CLUSTER_NAME/coredns-config.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./$CLUSTER_NAME/coredns-loadbalancer.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME

# setup cilium
helm upgrade -i cilium cilium/cilium --version 1.10.2 \
   --namespace kube-system \
   --kube-context kind-$CLUSTER_NAME \
   -f ./$CLUSTER_NAME/cilium-values.yaml

kubectl apply -f ./common/cilium-ca-secret.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/cilium-clustermesh-secret.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME

kubectl patch ds cilium --patch-file=./common/cilium-ds-patch.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME
