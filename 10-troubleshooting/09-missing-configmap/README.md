# Fault 09 - Referenced ConfigMap Does Not Exist

## Create fault

```bash
kubectl apply -f broken-deployment.yaml
kubectl get pods
```

A Pod may remain unable to start because the referenced ConfigMap cannot be found.

## Investigate

```bash
kubectl describe pod <pod>
kubectl get configmap
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Fix

Either create the expected ConfigMap or change the Deployment reference to the real one:

```bash
kubectl apply -f ../../03-configmap/configmap.yaml
```
