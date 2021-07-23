#!/usr/bin/env bash

# generate ca
cfssl gencert -initca ./common/certs/ca/ca-csr.json | cfssljson -bare ./common/certs/ca/ca

CA=$(base64 -w 0 ./common/certs/ca/ca.pem)
CA_KEY=$(base64 -w 0 ./common/certs/ca/ca-key.pem)

cat <<EOT > ./common/ca-key-pair.yaml
apiVersion: v1
kind: Secret
metadata:
  name: ca-key-pair
  namespace: default
data:
  tls.crt: $CA
  tls.key: $CA_KEY
EOT
