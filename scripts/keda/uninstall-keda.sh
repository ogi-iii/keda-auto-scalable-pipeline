#!/bin/bash
helm uninstall keda -n keda
kubectl delete namespace keda

docker image rmi -f $(docker image ls ghcr.io/kedacore/keda-admission-webhooks --format "{{.ID}}")
docker image rmi -f $(docker image ls ghcr.io/kedacore/keda-metrics-apiserver --format "{{.ID}}")
docker image rmi -f $(docker image ls ghcr.io/kedacore/keda --format "{{.ID}}")
