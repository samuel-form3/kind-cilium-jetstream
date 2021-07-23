#!/usr/bin/env bash

# generate ca
cfssl gencert -initca ./common/certs/ca/ca-csr.json | cfssljson -bare ./common/certs/ca/ca

# generate clustermesh cert
cfssl gencert -ca ./common/certs/ca/ca.pem \
              -ca-key ./common/certs/ca/ca-key.pem \
              ./common/certs/server/csr.json | cfssljson -bare ./common/certs/server/cert


CA=$(base64 -w 0 ./common/certs/ca/ca.pem)
CA_KEY=$(base64 -w 0 ./common/certs/ca/ca-key.pem)
SERVER_CERT=$(base64 -w 0 ./common/certs/server/cert.pem)
SERVER_KEY=$(base64 -w 0 ./common/certs/server/cert-key.pem)


cat <<EOT > ./common/nats-server-tls-secret.yaml
apiVersion: v1
data:
  ca.crt: $CA
  tls.crt: $SERVER_CERT
  tls.key: $SERVER_KEY
kind: Secret
metadata:
  name: nats-server-tls
EOT

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
