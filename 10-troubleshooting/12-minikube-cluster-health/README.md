# Fault 12 - Minikube API Unreachable / Disk Pressure

This captures the Minikube-side checks used when `kubectl` cannot reach the API or the Minikube VM/container is unhealthy.

Example symptoms can include:

```text
no route to host
connection refused
kubectl get nodes fails
Minikube filesystem is full
```

## Investigate from the outside first

```bash
minikube status
kubectl config current-context
kubectl cluster-info
minikube ip
```

## Inspect Minikube disk usage

```bash
minikube ssh -- df -h
```

If the root filesystem is full, free unnecessary data before treating the problem as an application/YAML issue.

## Restart local cluster services

A simple lab recovery can be:

```bash
minikube stop
minikube start
```

Then verify:

```bash
kubectl get nodes
kubectl get pods -A
```

Do not start debugging an Nginx Service or Deployment until the Kubernetes API and node are reachable.
