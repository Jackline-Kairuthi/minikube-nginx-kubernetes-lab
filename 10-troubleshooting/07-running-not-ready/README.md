# Fault 07 - Pod Is Running but Not Ready

## Create fault

```bash
kubectl apply -f broken-probe.yaml
kubectl apply -f ../../02-services/clusterip-service.yaml
```

## Observe

```bash
kubectl get pods
kubectl describe pod <pod>
kubectl get endpoints nginx-service
```

The container can be `Running` while the Pod shows `0/1` Ready.

## Why

The readiness probe requests a nonexistent path. Readiness failure does **not** necessarily restart the container; it prevents the Pod from being an eligible Service backend.

## Fix

Change the probe path to:

```yaml
path: /
```
