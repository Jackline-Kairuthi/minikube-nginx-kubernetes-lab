# 11 - Final Combined Minikube Nginx Lab

This folder combines the concepts practiced throughout the repository into one final state.

## Architecture

```text
Browser / curl
     |
     v
Ingress Controller
     |
     v
nginx-ingress
     |
     v
nginx-service
     |
     +-------------------+
     |                   |
     v                   v
nginx Pod            nginx Pod
     ^                   ^
     +---- Deployment ---+
             |
      +------+------+-------+---------+
      |             |       |         |
 ConfigMap        Secret  Probes   Resources
                              
Deployment -> PVC -> PV -> Minikube hostPath (/data mount inside container)
     ^
     |
    HPA (CPU target 60%, replicas 2..10)
```

## Enable addons

```bash
minikube addons enable metrics-server
minikube addons enable ingress
```

## Apply in order

```bash
kubectl apply -f configmap.yaml
kubectl apply -f secret.example.yaml
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
kubectl apply -f ingress.yaml
```

## Verify every layer

```bash
kubectl get deployment,rs,pods
kubectl get svc,endpoints,endpointslices
kubectl get configmap,secret
kubectl get pv,pvc
kubectl get hpa
kubectl top pods
kubectl get ingress
kubectl describe ingress nginx-ingress
```

## Internal application test

```bash
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- \
  curl http://nginx-service
```

## Ingress test

```bash
MINIKUBE_IP=$(minikube ip)
curl -H 'Host: nginx.example.com' "http://$MINIKUBE_IP/"
```

## Test self-healing

```bash
POD=$(kubectl get pod -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod "$POD"
kubectl get pods -w
```

## Test rollout and rollback

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.28-alpine
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment
```

## Test HPA

```bash
for i in $(seq 1 20); do
  kubectl run load-$i --image=busybox:1.36 --restart=Never -- \
    /bin/sh -c 'while true; do wget -q -O- http://nginx-service >/dev/null; done'
done

kubectl get hpa -w
```

## Troubleshooting rule

Always prove each layer:

```text
Cluster -> Deployment -> Pod -> Probe -> Service -> Endpoints -> Ingress -> Metrics/Scale -> Storage
```
