# Fault 06 - Deployment Selector Is Immutable

## Create the original Deployment

```bash
kubectl apply -f initial-deployment.yaml
```

## Try to change its selector

```bash
kubectl apply -f invalid-selector-change.yaml
```

Expected: Kubernetes rejects the update because `spec.selector` on an existing Deployment is immutable.

## Correct approaches

If the selector change is truly required in a disposable lab, recreate the Deployment:

```bash
kubectl delete deployment nginx-deployment
kubectl apply -f invalid-selector-change.yaml
```

For normal application updates, keep the selector stable and change only fields that are intended to evolve, such as image, resources, probes or Pod-template annotations.
