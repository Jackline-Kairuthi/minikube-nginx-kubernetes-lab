# 09 - Ingress on Minikube

## Why Ingress

Instead of exposing every HTTP application through a separate external entry, an Ingress Controller can accept HTTP traffic and route it to different Kubernetes Services using host/path rules.

For this Nginx lab:

```text
Client
  |
  v
Minikube ingress entry
  |
  v
Ingress Controller
  |
  v
nginx-ingress rule
  |
  v
nginx-service:80
  |
  v
nginx Pods:80
```

## Enable the Minikube Ingress addon

```bash
minikube addons enable ingress
```

Verify:

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

## Apply the Nginx Service and Ingress

```bash
kubectl apply -f ../02-services/clusterip-service.yaml
kubectl apply -f ingress.yaml
```

Verify:

```bash
kubectl get ingress
kubectl describe ingress nginx-ingress
```

## Test with Host header

```bash
MINIKUBE_IP=$(minikube ip)
curl -H 'Host: nginx.example.com' "http://$MINIKUBE_IP/"
```

Depending on the Minikube driver/platform, direct host routing can differ. `minikube tunnel` can be useful for networking modes that need a host-side route:

```bash
minikube tunnel
```

## Browser hostname option

Map the Minikube IP to the lab hostname in your hosts file:

```text
<minikube-ip> nginx.example.com
```

Then browse:

```text
http://nginx.example.com
```

## Ingress vs Service

Ingress does not replace the Service. Ingress routes to a **Service**, and the Service selects ready Pods.

```text
Ingress -> Service -> Pods
```

If Ingress returns an error, inspect every boundary rather than only the Ingress object.
