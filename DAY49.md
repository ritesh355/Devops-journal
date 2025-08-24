# 🟦 Day 49: Pods & kubectl

Welcome to **Day 49 of Kubernetes learning**.  
Today we’ll dive into **Pods** (the smallest deployable unit in Kubernetes) and learn how to manage them using **kubectl**.

---

## 📌 1. What is a Pod?

A **Pod** is the **smallest deployable unit** in Kubernetes.  
It represents a **single instance of a running process** in your cluster.

### 🔹 Key Features:
- A Pod can contain **one or more containers** (but usually one).
- Containers inside the same Pod:
  - Share the **same network namespace** (same IP and ports).
  - Can **communicate over localhost**.
  - Can share **volumes (storage)**.
- A Pod is always scheduled on a **single Node** in the cluster.

👉 Think of a **Pod as a wrapper** around your container(s) with extra Kubernetes features (network, storage, lifecycle).

---

## 📌 2. Imperative vs Declarative in Kubernetes

Kubernetes supports **two ways** of interacting with resources.

### 🔹 Imperative (command-based)
You directly tell Kubernetes what to do **immediately**.

Examples:
```bash
# Run a Pod with nginx image
kubectl run nginx --image=nginx

# List all Pods
kubectl get pods

# Delete a Pod
kubectl delete pod nginx
```
✔️ Good for quick testing, not ideal for production.
---
### 🔹 Declarative (YAML manifest)
You describe the desired state in a YAML file, and Kubernetes ensures that state.
Example: nginx-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
```

---
Apply it:
```bash
kubectl apply -f nginx-pod.yaml
```
Verify:
```bash
kubectl get pods -o wide
kubectl describe pod nginx-pod
```
Delete it:
```bash
kubectl delete -f nginx-pod.yaml
```
👉 In real DevOps work → Declarative YAML is the standard.
---
## 📌 3. Useful kubectl Commands for Pods
```bash
# Get all Pods
kubectl get pods

# Describe details of a Pod
kubectl describe pod <pod-name>

# Check Pod logs
kubectl logs <pod-name>

# Exec into a Pod (like SSH into container)
kubectl exec -it <pod-name> -- /bin/bash

# Forward Pod port to localhost (for testing)
kubectl port-forward pod/<pod-name> 8080:80
```
👉 To stop port-forwarding, press Ctrl + C.

---

# Pod Lifecycle

Pods are ephemeral:

- If a Pod crashes, it does not automatically restart.
- Kubernetes can restart the container inside a Pod if configured with `restartPolicy`.
- For scaling and self-healing, we use ReplicaSets and Deployments (covered in Day 50).

# When to Use Pods Directly?

Rarely used alone in production.

Mostly for:

- Testing a single container quickly.
- Debugging.
- Learning basics of Kubernetes.

In real-world scenarios → use Deployments for managing Pods.

# Summary

- Pod = smallest deployable unit in Kubernetes.
- Pods can contain multiple containers (sharing network + storage).
- Imperative = direct commands (fast, temporary).
- Declarative = YAML manifests (recommended, scalable).
- Pods are ephemeral → for real apps, use ReplicaSets/Deployments.
---

## ❤️ Follow My DevOps Journey
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GITHUB](https://github.com/ritesh355/Devops-journal)


