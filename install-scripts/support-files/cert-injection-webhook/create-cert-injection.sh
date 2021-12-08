#!/bin/bash

#POD_WEBHOOK_IMAGE_PATH="10.0.100.46.nip.io/sidecar/pod-webhook-image"              # POD WEBHOOK IMAGE를 올린 경로(Docker Hub나 Harbor 등 Registry 주소)
#SETUP_CA_CERTS_IMAGE_PATH="10.0.100.46.nip.io/sidecar/setup-ca-certs-image"        # SETUP CA CERTS IMAGE를 올린 경로(Docker Hub나 Harbor 등 Registry 주소)
#CA_CERT_FILE_PATH="../private-registry.ca"                                             # Private Registry 배포 시 사용된 CA 파일



source ../../variables.yml

if [[ ${app_registry_kind} = "dockerhub" ]]; then
  REGISTRY_PATH=${app_registry_id}
elif [[ ${app_registry_kind} = "private" ]]; then
  REGISTRY_PATH=${app_registry_address}/${app_registry_repository}
fi


ytt -f ./deployments/k8s \
    -v pod_webhook_image=${REGISTRY_PATH}/pod-webhook-image \
    -v setup_ca_certs_image=${REGISTRY_PATH}/setup-ca-certs-image \
    --data-value-file ca_cert_data=${CA_CERT_FILE_PATH} \
    --data-value-yaml labels="[kpack.io/build, app]" > manifest.yaml

cat << EOF >> manifest.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cert-injection-webhook
EOF

kapp deploy -a cert-injection-webhook -f ./manifest.yaml -y
