#!/bin/bash

# deploy Apache Kafka, Mongo DB, and the other tools
if [ ! -d kafka-streams-pipeline/ ]; then
    git clone https://github.com/ogi-iii/kafka-streams-pipeline.git
fi
cd kafka-streams-pipeline/
git pull
docker compose -f ./demo/docker-compose.yml up -d
./demo/scripts/create-topic.sh
cd ..

# install KEDA to Kubernetes cluster
./scripts/keda/install-keda.sh

# deploy the scalable pipeline app with auto-scaler
docker image build -t streams-pipeline-app .
kubectl create namespace pipeline
kubectl apply -f pipeline-deployment.yaml
kubectl apply -f scaled-object.yaml
