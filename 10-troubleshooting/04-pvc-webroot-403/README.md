# Fault 04 - PVC Mount Hides Nginx index.html

Use the manifests in `../../07-pv-pvc/`.

## Create storage

```bash
kubectl apply -f ../../07-pv-pvc/pv.yaml
kubectl apply -f ../../07-pv-pvc/pvc.yaml
```

## Create fault

```bash
kubectl apply -f ../../07-pv-pvc/deployment-broken-webroot-mount.yaml
```

## Investigate in order

```bash
kubectl get pods
kubectl get pods -o wide
kubectl describe pod <pod>
kubectl logs <pod>
kubectl logs <pod> --previous
kubectl get pv,pvc
kubectl get deployment nginx-deployment -o yaml
```

Reasoning path:

```text
Pod can start
 -> HTTP probe receives a response, often 403
 -> this is not primarily an image-pull/scheduling failure
 -> Nginx logs point to web-root content/index problem
 -> Deployment YAML shows PVC mounted over /usr/share/nginx/html
 -> mount hides original image content
```

## Repair

```bash
kubectl apply -f ../../07-pv-pvc/deployment-fixed-data-mount.yaml
kubectl rollout status deployment/nginx-deployment
kubectl get pods
```

Expected recovery: Pods become `1/1 Running` without probe-driven restarts.
