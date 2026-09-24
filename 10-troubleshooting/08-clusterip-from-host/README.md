# Fault 08 - Trying to Access ClusterIP Directly from the Host

A ClusterIP such as `10.x.x.x` is a virtual address intended for cluster-internal use.

## Correct internal test

```bash
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- \
  curl http://nginx-service
```

## Correct host-side alternatives

Port-forward:

```bash
kubectl port-forward service/nginx-service 8080:80
```

NodePort:

```bash
kubectl apply -f ../../02-services/nodeport-service.yaml
minikube service nginx-nodeport --url
```

Ingress:

```bash
minikube addons enable ingress
kubectl apply -f ../../09-ingress/ingress.yaml
```

The key lesson is to choose the correct exposure method rather than assuming a ClusterIP is a host/browser address.
