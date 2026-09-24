# Publish This Folder to GitHub

From inside the repository directory:

```bash
git init
git add .
git commit -m "Add Minikube Nginx Kubernetes hands-on lab"
git branch -M main
git remote add origin https://github.com/<YOUR-USERNAME>/minikube-nginx-kubernetes-lab.git
git push -u origin main
```

Suggested repository name:

```text
minikube-nginx-kubernetes-lab
```

Suggested description:

```text
Hands-on Minikube Kubernetes lab using Nginx: Deployments, Services, ConfigMaps, Secrets, resources, probes, rollouts, PV/PVC, HPA, Ingress and troubleshooting.
```

Suggested GitHub topics:

```text
kubernetes minikube nginx devops kubectl hpa ingress persistent-volume troubleshooting
```
