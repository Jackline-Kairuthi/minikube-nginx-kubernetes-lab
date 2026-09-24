# Minikube + Nginx Command Cheatsheet

## Cluster

```bash
minikube start
minikube status
minikube ip
minikube stop
kubectl config current-context
kubectl cluster-info
kubectl get nodes -o wide
```

## Deployment / ReplicaSet / Pods

```bash
kubectl get deploy,rs,pods
kubectl get pods -o wide
kubectl get pods --show-labels
kubectl describe deployment nginx-deployment
kubectl describe pod <pod>
kubectl scale deployment nginx-deployment --replicas=3
kubectl delete pod <pod>
```

## Logs

```bash
kubectl logs <pod>
kubectl logs <pod> --tail=10
kubectl logs <pod> --previous
kubectl logs -f <pod>
```

Correct `--tail` syntax:

```bash
kubectl logs <pod-name> --tail=10
```

## Services

```bash
kubectl get svc
kubectl describe svc nginx-service
kubectl get endpoints nginx-service
kubectl get endpointslices
kubectl port-forward service/nginx-service 8080:80
minikube service nginx-nodeport --url
```

## ConfigMap / Secret

```bash
kubectl get configmap nginx-config -o yaml
kubectl describe configmap nginx-config
kubectl get secret nginx-secret
kubectl describe secret nginx-secret
```

## Rollout / Rollback

```bash
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
kubectl set image deployment/nginx-deployment nginx=nginx:1.28-alpine
kubectl rollout undo deployment/nginx-deployment
kubectl rollout restart deployment/nginx-deployment
```

## Storage

```bash
kubectl get pv,pvc
kubectl describe pv app-pv
kubectl describe pvc app-pvc
kubectl exec -it <pod> -- df -h
```

## Metrics / HPA

```bash
minikube addons enable metrics-server
kubectl top nodes
kubectl top pods
kubectl get hpa
kubectl get hpa -w
kubectl describe hpa nginx-hpa
```

## Ingress

```bash
minikube addons enable ingress
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
kubectl get ingress
kubectl describe ingress nginx-ingress
```

## Events / troubleshooting

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get all
kubectl get all -o wide
```
