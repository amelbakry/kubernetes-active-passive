# Kubernetes Active Passive Applications

## Introduction

We had a use case where we need the application to be running all the time so restart is not acceptable. we need active/passive or active/standby pods. as this is not yet supported by Kubernetes here is how you can implement this by tiny shell commands with the readiness probe and a statefulset

To use this feature, you need Statefulset configured with Readiness probe and use this tiny script check-readiness.sh for readiness probe.
So running 2 pods, for example, active-passive-0, active-passive-1

## How it works:
The script used for readiness probe will check if the other pod is running and return status ok, the readiness probe will fail. this means if one pod is running (active), the other pod will fail the readiness probe and stay running but not ready. If the active pod failed or restarted, the readiness probe of the passive pod will succeed and the passive will become active and so on.

```bash
kubectl get po | grep active
active-passive-0 1/1 Running 0 8m
active-passive-1 0/1 Running 0 6m
```

## Example:

```bash
kubectl get po | grep active
active-passive-0 1/1 Running 0 13m
active-passive-1 0/1 Running 0 10m
```
```bash
kubectl delete po active-passive-0
pod "active-passive-0" deleted
```
```bash
kubectl get po | grep active
active-passive-0 0/1 Pending 0 8s
active-passive-1 1/1 Running 0 11m
```
```bash
kubectl get po | grep active
active-passive-0 0/1 Running 0 49s
active-passive-1 1/1 Running 0 12m
```

And once more deleting active-passive-1 (the current active pod)
```bash
kubectl delete po active-passive-1
pod "active-passive-1" delete
```
```bash
kubectl get po | grep active
active-passive-0 1/1 Running 0 2m
active-passive-1 0/1 Running 0 5s
```
