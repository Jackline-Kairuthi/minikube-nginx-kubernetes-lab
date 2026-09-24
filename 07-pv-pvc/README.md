# 07 - PersistentVolume and PersistentVolumeClaim

## Storage model

```text
Pod -> PVC -> PV -> hostPath (/mnt/data/nginx-app in this Minikube lab)
```

The PVC is the application's storage request. The PV is the storage resource satisfying the request.

## Create PV and PVC

```bash
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl get pv,pvc
kubectl describe pvc app-pvc
```

Expected state:

```text
STATUS: Bound
```

## Reproduce the important failure from the lab

Apply the broken Deployment:

```bash
kubectl apply -f deployment-broken-webroot-mount.yaml
kubectl get pods -w
```

The volume is mounted over:

```text
/usr/share/nginx/html
```

A mount hides the files that were originally present in that directory inside the container image. The standard Nginx `index.html` is therefore hidden.

Possible chain:

```text
PVC mounted over Nginx web root
        |
        v
index.html hidden
        |
        v
GET / -> HTTP 403
        |
        +--> readiness fails -> Pod not Ready / no Service traffic
        |
        +--> liveness fails -> container restarted
                              |
                              v
                       CrashLoopBackOff
```

## Investigate systematically

```bash
kubectl get pods
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl get deployment nginx-deployment -o yaml
kubectl get pv
kubectl get pvc
```

The Nginx log may report a directory-index-forbidden style error for `/usr/share/nginx/html/`.

## Apply the fix

```bash
kubectl apply -f deployment-fixed-data-mount.yaml
kubectl rollout status deployment/nginx-deployment
kubectl get pods
```

The PVC is now mounted at:

```text
/data
```

Nginx keeps its original web root and probes can succeed.

## Multi-node Minikube warning

`hostPath` is node-local. `/mnt/data/...` on `minikube` is not automatically the same storage as `/mnt/data/...` on `minikube-m02`.

Inspect placement:

```bash
kubectl get pods -o wide
```

Inspect a node if needed:

```bash
minikube ssh
```
