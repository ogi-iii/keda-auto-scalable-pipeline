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
kubectl apply -f ./kubernetes/pipeline-deployment.yaml

STDOUT=$(kubectl apply -f ./kubernetes/scaled-object.yaml 3>&2 2>&1 1>&3)
ERR_STR="unable"
until [[ "$STDOUT" != *"$ERR_STR"* ]]
do
    kubectl delete -f ./kubernetes/scaled-object.yaml
    echo "retry to connect Kafka Broker..."
    sleep 5
    STDOUT=$(kubectl apply -f ./kubernetes/scaled-object.yaml 3>&2 2>&1 1>&3)
done

echo "Setup process was finished."
