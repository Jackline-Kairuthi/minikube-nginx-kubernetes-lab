# 05 - CPU/Memory Requests, Limits and Probes

## Resource settings used in this lab

```text
CPU request:    100m
CPU limit:      500m
Memory request: 128Mi
Memory limit:   256Mi
```

`request` helps the scheduler decide where a Pod can fit. `limit` caps how much the container can use.

A CPU limit can lead to throttling. Exceeding a memory limit can result in `OOMKilled`.

## Probes

Readiness asks:

> Can this Pod receive traffic now?

If readiness fails, the Pod can keep running but is removed from Service endpoints.

Liveness asks:

> Is this application unhealthy enough that the container should be restarted?

If liveness repeatedly fails, Kubernetes restarts the container.

## Apply prerequisites and Deployment

```bash
kubectl apply -f ../03-configmap/configmap.yaml
kubectl apply -f ../04-secret/secret.example.yaml
kubectl apply -f deployment.yaml
kubectl apply -f ../02-services/clusterip-service.yaml
```

## Verify

```bash
kubectl rollout status deployment/nginx-deployment
kubectl get pods
kubectl describe pod <pod-name>
kubectl get endpoints nginx-service
```

Look under `Conditions`, `Readiness`, `Liveness` and `Events`.

## Resource usage

After Metrics Server is enabled later:

```bash
kubectl top pods
```
