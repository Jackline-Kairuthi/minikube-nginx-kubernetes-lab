# 10 - Troubleshooting Labs

These exercises recreate the failures investigated during the Minikube/Nginx practice.

## Universal investigation order

```bash
kubectl get pods -o wide
kubectl describe pod <pod>
kubectl logs <pod>
kubectl logs <pod> --previous
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get pods --show-labels
kubectl get svc
kubectl get endpoints
kubectl get endpointslices
kubectl get pv,pvc
kubectl top pods
kubectl describe hpa nginx-hpa
kubectl get ingress
kubectl describe ingress nginx-ingress
```

## Cases

| Case | Symptom | Main lesson |
|---|---|---|
| 01 | Service has no endpoints | selector must match Pod labels |
| 02 | Service forwards to wrong port | `targetPort` must match app port |
| 03 | ImagePullBackOff | inspect image/tag and Events |
| 04 | HTTP 403 + probe restarts | PVC mount hid Nginx web root |
| 05 | HPA not scaling | metrics + CPU request + real load |
| 06 | Deployment selector immutable | selector cannot be changed in-place |
| 07 | Pod Running but not Ready | readiness controls traffic eligibility |
| 08 | ClusterIP inaccessible from host | ClusterIP is an internal Service address |
| 09 | Missing ConfigMap | inspect Pod Events and object references |
| 10 | Secret key mismatch | Secret can exist while a referenced key is absent |
| 11 | OOMKilled | memory limits can terminate a container |
| 12 | Minikube/API health | prove the cluster is healthy before debugging the app |

Each subfolder contains a reproducible fault and its fix.
