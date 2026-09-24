# 08 - Horizontal Pod Autoscaler (HPA)

## Goal

Scale the Nginx Deployment automatically based on average CPU utilization.

Lab values:

```text
minReplicas: 2
maxReplicas: 10
target CPU: 60%
CPU request per Pod: 100m
```

The CPU request matters because percentage-based CPU HPA calculations use requested CPU as the baseline.

## Enable Metrics Server on Minikube

```bash
minikube addons enable metrics-server
```

Wait until metrics become available:

```bash
kubectl top nodes
kubectl top pods
```

If these return metrics, HPA can use them.

## Apply workload, Service and HPA

```bash
kubectl apply -f deployment.yaml
kubectl apply -f ../02-services/clusterip-service.yaml
kubectl apply -f hpa.yaml
```

## Watch the HPA

```bash
kubectl get hpa
kubectl get hpa -w
kubectl describe hpa nginx-hpa
kubectl top pods
```

## Generate load

One BusyBox loop:

```bash
kubectl run load-generator --image=busybox:1.36 --restart=Never -- \
  /bin/sh -c 'while true; do wget -q -O- http://nginx-service >/dev/null; done'
```

For much heavier traffic, create multiple load generators:

```bash
for i in $(seq 1 20); do
  kubectl run load-$i --image=busybox:1.36 --restart=Never -- \
    /bin/sh -c 'while true; do wget -q -O- http://nginx-service >/dev/null; done'
done
```

Observe:

```bash
kubectl get hpa -w
kubectl get pods -w
kubectl top pods
```

## Why replicas may not increase immediately at exactly 60-61%

HPA does not react to every tiny measurement change instantly. It has controller timing, metric averaging and tolerance behavior to avoid constant scale-up/scale-down oscillation.

If HPA does not scale, investigate:

```bash
kubectl top pods
kubectl get hpa
kubectl describe hpa nginx-hpa
kubectl get deployment nginx-deployment -o yaml
kubectl get apiservice | grep metrics
```

Check:

1. Metrics Server is working.
2. The HPA points to `nginx-deployment`.
3. The container has a CPU request.
4. Traffic is actually creating CPU load.
5. The current utilization stays sufficiently above the target long enough to trigger scaling.

## Cleanup load

```bash
kubectl delete pod load-generator --ignore-not-found
kubectl delete pod $(kubectl get pods -o name | grep '^pod/load-' | cut -d/ -f2) 2>/dev/null || true
```
