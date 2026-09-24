# Fault 03 - ImagePullBackOff

## Create fault

```bash
kubectl apply -f broken-deployment.yaml
kubectl get pods
```

## Investigate

```bash
kubectl describe pod <pod-name>
kubectl get events --sort-by=.metadata.creationTimestamp
```

Look for image pull errors and the exact image/tag requested.

## Fix with rollback

If this was introduced through `kubectl set image` and a previous revision exists:

```bash
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
```

Or set a valid image:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:latest
```
