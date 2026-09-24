# 00 - Minikube Environment

## Goal

Start a local Kubernetes cluster and confirm that `kubectl` is talking to Minikube.

## Start Minikube

```bash
minikube start
```

For the multi-node variation used during storage testing:

```bash
minikube start --nodes 2
```

## Verify context and nodes

```bash
kubectl config current-context
kubectl get nodes -o wide
minikube status
```

Expected context:

```text
minikube
```

## Useful checks

```bash
kubectl get pods -A
kubectl cluster-info
minikube ip
```

## Why this matters

Before troubleshooting an application, first confirm that the Kubernetes API and nodes are healthy. Otherwise an application problem can actually be a cluster/context problem.
