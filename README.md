# Minikube + Nginx Kubernetes Hands-On Lab

A GitHub-ready repository that recreates the **Minikube-only Kubernetes work** practiced step by step with a basic Nginx application.

> Scope: Minikube only. kubeadm is intentionally excluded.

## What this repository covers

1. Minikube pre-checks
2. Nginx Deployment, ReplicaSet, scaling and self-healing
3. ClusterIP and NodePort Services
4. Labels, selectors, endpoints and port-forwarding
5. ConfigMaps
6. Secrets
7. CPU/memory requests and limits
8. Readiness and liveness probes
9. RollingUpdate strategy, rollout history and rollback
10. PersistentVolume and PersistentVolumeClaim
11. The PVC/web-root mistake that caused Nginx HTTP 403 and CrashLoopBackOff
12. Metrics Server and Horizontal Pod Autoscaler (HPA)
13. Nginx Ingress on Minikube
14. Repeatable troubleshooting exercises from the lab
15. A final combined manifest

## Learning path

```text
Minikube
   |
   v
Deployment -> ReplicaSet -> Pods
   |
   v
Service -> ConfigMap -> Secret
   |
   v
Resources -> Probes
   |
   v
Rolling Update -> Rollback
   |
   v
PV -> PVC -> Volume Mount
   |
   v
Metrics Server -> HPA
   |
   v
Ingress Controller -> Ingress -> Service -> Pods
   |
   v
Troubleshooting
```

## Repository structure

```text
.
├── 00-environment/
├── 01-deployment/
├── 02-services/
├── 03-configmap/
├── 04-secret/
├── 05-resources-and-probes/
├── 06-rolling-update-and-rollback/
├── 07-pv-pvc/
├── 08-hpa/
├── 09-ingress/
├── 10-troubleshooting/
├── 11-final-lab/
├── scripts/
└── README.md
```

## Quick start

```bash
minikube start
kubectl get nodes
kubectl apply -f 01-deployment/deployment.yaml
kubectl apply -f 02-services/clusterip-service.yaml
kubectl get pods,deploy,rs,svc
```

Test from inside the cluster:

```bash
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- \
  curl http://nginx-service
```

Or use local port-forwarding:

```bash
kubectl port-forward service/nginx-service 8080:80
```

Then open `http://localhost:8080`.

## The troubleshooting habit used throughout this repo

Do not guess randomly. Investigate in this order:

```text
1. Does the object exist?
2. What is its current state?
3. What do Events say?
4. What do current/previous logs say?
5. Do labels and selectors match?
6. Does the Service have endpoints?
7. Are ports and targetPorts correct?
8. Are readiness/liveness probes succeeding?
9. Are PV/PVC objects Bound and mounted correctly?
10. Does Metrics Server work and does HPA have CPU requests?
11. Is the Ingress Controller running and routing to the correct Service?
```

High-value commands:

```bash
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get pods --show-labels
kubectl get svc
kubectl get endpoints
kubectl get endpointslices
kubectl get pv,pvc
kubectl top pods
kubectl get hpa
kubectl describe hpa nginx-hpa
kubectl get ingress
kubectl describe ingress nginx-ingress
```

## Important lab lesson: Running does not always mean healthy

One of the most useful failures in this lab happened when a PVC was mounted directly over:

```text
/usr/share/nginx/html
```

That hid Nginx's original `index.html`. Nginx returned HTTP 403, the readiness probe failed, the liveness probe kept restarting the container, and the new rollout could not become healthy.

The fix was to mount the PVC somewhere that did not hide the Nginx web root, for example:

```yaml
mountPath: /data
```

The broken and fixed manifests are in `07-pv-pvc/` and the investigation is repeated in `10-troubleshooting/04-pvc-webroot-403/`.

## Suggested order

Run every folder in numeric order. Each folder has its own `README.md` with:

- goal
- YAML
- commands
- expected result
- verification
- common fault
- troubleshooting steps
- cleanup

## Cleanup

Delete the lab objects:

```bash
bash scripts/cleanup.sh
```

Stop Minikube without deleting it:

```bash
minikube stop
```

Delete the cluster completely:

```bash
minikube delete
```

## Portfolio use

This repository demonstrates hands-on understanding of Kubernetes workload management, networking, configuration, health checks, resource control, storage, autoscaling, ingress and systematic troubleshooting using Minikube and Nginx.
