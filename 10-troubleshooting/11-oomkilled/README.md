# Fault 11 - Memory Limit and OOMKilled

This is a troubleshooting concept connected to the resource-limit lab.

If an application consumes more memory than its container memory limit, the container can be killed with reason `OOMKilled`.

## Investigate

```bash
kubectl get pods
kubectl describe pod <pod>
kubectl get pod <pod> -o jsonpath='{.status.containerStatuses[0].lastState.terminated.reason}{"\n"}'
kubectl top pod <pod>
```

Look for:

```text
Reason: OOMKilled
```

## Repair approach

Determine whether the application has a memory leak or genuinely needs more memory. Then tune its request/limit based on evidence rather than simply removing limits.
