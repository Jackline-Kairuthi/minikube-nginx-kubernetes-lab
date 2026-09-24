#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../11-final-lab"

kubectl apply -f configmap.yaml
kubectl apply -f secret.example.yaml
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
kubectl apply -f ingress.yaml

kubectl rollout status deployment/nginx-deployment
kubectl get deployment,rs,pods,svc,hpa,ingress
