# 04 - Secrets

Secrets are used for values that should not be placed in a ConfigMap, such as passwords, tokens and API keys.

The value in `secret.example.yaml` is deliberately a disposable lab value. Do not commit real credentials.

## Apply

First ensure the ConfigMap from the previous lab exists:

```bash
kubectl apply -f ../03-configmap/configmap.yaml
```

Then:

```bash
kubectl apply -f secret.example.yaml
kubectl apply -f deployment-with-secret.yaml
```

## Verify

```bash
kubectl get secret nginx-secret
kubectl describe secret nginx-secret
```

Check that variables are present without printing the password unnecessarily:

```bash
POD=$(kubectl get pod -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl exec "$POD" -- sh -c 'test -n "$DB_USERNAME" && test -n "$DB_PASSWORD" && echo secret-vars-present'
```

## Important concept

Kubernetes Secret data is not made secure merely because it is Base64 encoded. Real environments require proper RBAC and secret-management practices.
