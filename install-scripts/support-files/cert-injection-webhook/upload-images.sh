#!/bin/bash

source ../../variables.yml
#wget image~~~~~
#wget image~~~~~
if [[ ${app_registry_kind} = "dockerhub" ]]; then
	REGISTRY_PATH=${app_registry_id}
elif [[ ${app_registry_kind} = "private" ]]; then
	REGISTRY_PATH=${app_registry_address}/${app_registry_repository}
fi

sudo docker load -i images/pod-webhook-image.tar
sudo docker load -i images/setup-ca-certs-image.tar

sudo docker tag pod-webhook-image ${REGISTRY_PATH}/pod-webhook-image
sudo docker tag setup-ca-certs-image ${REGISTRY_PATH}/setup-ca-certs-image

sudo docker push ${REGISTRY_PATH}/pod-webhook-image
sudo docker push ${REGISTRY_PATH}/setup-ca-certs-image