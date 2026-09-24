# Fault 02 - Service Uses the Wrong targetPort

This recreates the case where the Service had endpoints but forwarded to the wrong application port.

## Fault

Nginx listens on port `80`, but the Service uses:

```yaml
targetPort: 9376
```

## Investigate

```bash
kubectl apply -f ../../01-deployment/deployment.yaml
kubectl apply -f wrong-service.yaml
kubectl describe svc nginx-nodeport
kubectl get endpoints nginx-nodeport
kubectl get pods
```

Endpoints may exist because the selector is correct, but the traffic is sent to a port where Nginx is not listening.

## Fix

```bash
kubectl apply -f fixed-service.yaml
minikube service nginx-nodeport --url
```

Correct chain:

```text
NodePort -> port 80 -> targetPort 80 -> Nginx 80
```
