# 03 - ConfigMap

## Why ConfigMaps

ConfigMaps keep non-sensitive runtime settings outside the container image.

Examples practiced:

- `APP_ENV`
- `LOG_LEVEL`
- `DB_HOST`

## Apply

```bash
kubectl apply -f configmap.yaml
kubectl apply -f deployment-with-configmap.yaml
```

## Verify

```bash
kubectl get configmap nginx-config -o yaml
kubectl rollout status deployment/nginx-deployment
kubectl get pods
```

Inspect variables inside a Pod:

```bash
POD=$(kubectl get pod -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl exec "$POD" -- printenv | grep -E 'APP_ENV|LOG_LEVEL|DB_HOST'
```

## Key relationship

`envFrom.configMapRef` belongs inside the **container definition in the Pod template of the Deployment**. The Deployment itself does not consume the variables; its Pods do.

## After changing ConfigMap values

Environment variables are not automatically refreshed in already-running containers. Restart the Deployment:

```bash
kubectl rollout restart deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
```
