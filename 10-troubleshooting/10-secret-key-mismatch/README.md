# Fault 10 - Secret Exists but the Key Is Wrong

## Create fault

```bash
kubectl apply -f secret.yaml
kubectl apply -f broken-deployment.yaml
kubectl get pods
```

## Investigate

```bash
kubectl describe pod <pod>
kubectl get secret nginx-secret -o yaml
```

The Secret exists, but the Deployment asks for a key that is not present.

## Fix

Make the `secretKeyRef.key` match the actual key:

```text
DB_PASSWORD
```
