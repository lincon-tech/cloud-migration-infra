#!/bin/bash 
#This script installs Grafana using Helm

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install grafana grafana/grafana \
-f monitoring/grafana-values.yaml \
-n monitoring 