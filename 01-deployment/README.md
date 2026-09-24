# 01 - Deployment, ReplicaSet, Scaling and Self-Healing

## Apply the Deployment

```bash
kubectl apply -f deployment.yaml
```

## Inspect what Kubernetes created

```bash
kubectl get deployment
kubectl get rs
kubectl get pods -o wide
kubectl get pods --show-labels
```

Mental model:

```text
Deployment
   |
   v
ReplicaSet
   |
   +----> nginx Pod
   +----> nginx Pod
```

## Why `selector` and Pod labels must match

The Deployment selector is:

```yaml
selector:
  matchLabels:
    app: nginx
```

The Pod template has:

```yaml
labels:
  app: nginx
```

The Deployment uses that label relationship to know which Pods belong to it.

## Scaling

```bash
kubectl scale deployment nginx-deployment --replicas=3
kubectl get pods -w
```

Scale back:

```bash
kubectl scale deployment nginx-deployment --replicas=2
```

## Self-healing exercise

Delete one Pod manually:

```bash
kubectl get pods
kubectl delete pod <one-nginx-pod>
kubectl get pods -w
```

The Deployment/ReplicaSet creates a replacement because the desired replica count is still 2.

## Useful troubleshooting

```bash
kubectl describe deployment nginx-deployment
kubectl describe pod <pod-name>
kubectl get events --sort-by=.metadata.creationTimestamp
```
