#!/usr/bin/env bash
set -u

kubectl delete ingress nginx-ingress --ignore-not-found
kubectl delete hpa nginx-hpa --ignore-not-found
kubectl delete svc nginx-service nginx-nodeport --ignore-not-found
kubectl delete deployment nginx-deployment --ignore-not-found
kubectl delete configmap nginx-config --ignore-not-found
kubectl delete secret nginx-secret --ignore-not-found
kubectl delete pvc app-pvc --ignore-not-found
kubectl delete pv app-pv --ignore-not-found
kubectl delete pod load-generator --ignore-not-found

for p in $(kubectl get pods -o name 2>/dev/null | grep '^pod/load-' | cut -d/ -f2); do
  kubectl delete pod "$p" --ignore-not-found
done

echo 'Lab objects removed. Minikube itself was not deleted.'
