# 02 - Services: ClusterIP, NodePort and Port-Forwarding

A Pod IP can change when a Pod is replaced. A Service provides a stable virtual address and selects Pods by label.

## ClusterIP

```bash
kubectl apply -f clusterip-service.yaml
kubectl get svc nginx-service
kubectl get endpoints nginx-service
kubectl get endpointslices
```

Traffic flow:

```text
Client inside cluster
      |
      v
nginx-service:80
      |
      v
selected ready Pods:80
```

### Important

A ClusterIP is normally reachable **inside the cluster**, not directly from your Windows/browser host.

Test internally:

```bash
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- \
  curl http://nginx-service
```

## Port-forward

```bash
kubectl port-forward service/nginx-service 8080:80
```

Meaning:

```text
localhost:8080 -> Service port 80 -> Pod targetPort 80
```

This uses the Service's `port`, not its NodePort value.

## NodePort

```bash
kubectl apply -f nodeport-service.yaml
kubectl get svc nginx-nodeport
minikube service nginx-nodeport --url
```

Or inspect the Minikube IP:

```bash
minikube ip
```

Then access:

```text
http://<minikube-ip>:<nodePort>
```

## The port chain

```text
NodePort -> Service port -> targetPort -> container
```

For Nginx:

```text
3xxxx -> 80 -> 80 -> nginx
```

## Checks when a Service does not work

```bash
kubectl get pods --show-labels
kubectl describe svc nginx-service
kubectl get endpoints nginx-service
kubectl get endpointslices
```

If endpoints are empty, check the Service selector first.
