#!/usr/bin/env bash
set -u

echo '=== Context ==='
kubectl config current-context || true

echo '=== Nodes ==='
kubectl get nodes -o wide || true

echo '=== Workloads ==='
kubectl get deployment,rs,pods -o wide || true

echo '=== Networking ==='
kubectl get svc,endpoints,endpointslices || true

echo '=== Config ==='
kubectl get configmap,secret || true

echo '=== Storage ==='
kubectl get pv,pvc || true

echo '=== Autoscaling ==='
kubectl get hpa || true
kubectl top pods 2>/dev/null || echo 'Metrics unavailable yet'

echo '=== Ingress ==='
kubectl get ingress || true

echo '=== Recent Events ==='
kubectl get events --sort-by=.metadata.creationTimestamp | tail -n 30 || true
