# Fault 05 - HPA Does Not Scale

## Investigation order

```bash
kubectl get hpa
kubectl describe hpa nginx-hpa
kubectl top pods
kubectl top nodes
kubectl get deployment nginx-deployment -o yaml
```

## Check 1 - Metrics Server

```bash
minikube addons enable metrics-server
kubectl top pods
```

If `kubectl top` does not work, HPA cannot obtain resource metrics.

## Check 2 - CPU request

Percentage-based CPU utilization needs a request such as:

```yaml
resources:
  requests:
    cpu: "100m"
```

## Check 3 - Target object

```bash
kubectl describe hpa nginx-hpa
```

It must target:

```text
Deployment/nginx-deployment
```

## Check 4 - Real load

Create sustained load, then watch:

```bash
kubectl get hpa -w
kubectl get pods -w
kubectl top pods
```

A value only barely around the 60% target may not immediately create another replica because the HPA controller intentionally avoids reacting to every small fluctuation.
