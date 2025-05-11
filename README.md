# 📦 k8s-toolkit

&#x20; &#x20;

An all-in-one troubleshooting toolkit for **Kubernetes** and **OpenShift**, built on UBI.

## 🔧 Repository Structure

* **Dockerfile**: base image.
* **deployment.yaml**: Deployment manifest for Kubernetes/OpenShift.
* **serviceaccount-rbac.yaml**: ServiceAccount and ClusterRoleBinding (example as `cluster-admin`).
* **README.md**: this file.

## ⚙️ Prerequisites

* Docker or Podman installed
* Access to a container registry (e.g., Docker Hub, Quay, or private registry)
* `kubectl` and `oc` configured for the target cluster

## 🏗️ Building the Image

```bash
# Navigate to the repository root
git clone https://github.com/lorenzobiosa/k8s-toolkit.git && cd k8s-toolkit

# Build the image
docker build -t <your-registry>/k8s-toolkit:latest .
# or with Podman
podman build -t <your-registry>/k8s-toolkit:latest .
```

### Build Options

* **TAG**: image tag (e.g., `1.0`, `latest`).

  ```bash
  docker build -t <your-registry>/k8s-toolkit:<TAG>
  ```

## 🚀 Pushing the Image

```bash
# Log in to your registry
docker login <your-registry>

# Push the image
docker push <your-registry>/k8s-toolkit:latest
```

## 📥 Deploying to Kubernetes/OpenShift

```bash
# Create ServiceAccount and RBAC
kubectl apply -f serviceaccount-rbac.yaml

# Deploy the toolkit
kubectl apply -f deployment.yaml

# Verify
kubectl get pods -l app=k8s-toolkit
```

> For OpenShift, replace `kubectl` with `oc`.

## 🗑️ Cleanup

```bash
kubectl delete -f deployment.yaml
kubectl delete -f serviceaccount-rbac.yaml
```

---
