# 06 - Rolling Update and Rollback

The strategy practiced was:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
    maxSurge: 1
```

## Meaning

- `maxSurge: 1` allows one temporary extra Pod during rollout.
- `maxUnavailable: 1` allows at most one desired Pod to be unavailable during the rollout.

## Apply baseline

```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment/nginx-deployment
```

## Perform an update

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.28-alpine
kubectl rollout status deployment/nginx-deployment
kubectl get pods -w
```

## Inspect rollout history

```bash
kubectl rollout history deployment/nginx-deployment
```

## Simulate a bad release

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:not-a-real-tag
kubectl get pods
kubectl describe pod <new-pod>
```

Expected symptom:

```text
ErrImagePull / ImagePullBackOff
```

## Roll back

```bash
kubectl rollout undo deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
```

## Why an old Pod may stay during a failed rollout

If the new Pods cannot become Ready, RollingUpdate may keep an older healthy Pod so the Deployment does not unnecessarily lose all available replicas.
