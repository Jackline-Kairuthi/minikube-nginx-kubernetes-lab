# Fault 01 - Service Selects No Pods

## Create fault

```bash
kubectl apply -f ../../01-deployment/deployment.yaml
kubectl apply -f wrong-service.yaml
```

## Observe

```bash
kubectl get pods --show-labels
kubectl get svc nginx-service
kubectl get endpoints nginx-service
```

Expected clue: endpoints are empty.

## Root cause

Service selector:

```text
app=nginx-WRONG
```

Pod label:

```text
app=nginx
```

## Fix

```bash
kubectl apply -f fixed-service.yaml
kubectl get endpoints nginx-service
```
