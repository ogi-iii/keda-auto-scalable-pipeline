#!/bin/bash

# stop and remove the scalable pipeline app with auto-scaler
kubectl delete -f ./kubernetes/scaled-object.yaml
kubectl delete -f ./kubernetes/pipeline-deployment.yaml
kubectl delete namespace pipeline
docker image rmi -f $(docker image ls streams-pipeline-app --format "{{.ID}}")

# uninstall KEDA from Kubernetes cluster
./scripts/keda/uninstall-keda.sh

# stop and remove Apache Kafka, Mongo DB, and the other tools
cd kafka-streams-pipeline/
docker compose -f ./demo/docker-compose.yml down -v --rmi all

echo "Shutdown process was finished."
