#!/bin/bash
kubectl get pods -n pipeline | awk '{if ($3 ~ /Error/) system ("kubectl delete pods " $1 " -n pipeline")}'
kubectl get pods -n pipeline | awk '{if ($3 ~ /Evicted/) system ("kubectl delete pods " $1 " -n pipeline")}'
