# 🟦 Day 50: ReplicaSets & Deployments in Kubernetes

---

## 📌 1. Recap: Pod
- A **Pod** is the smallest deployable unit in Kubernetes.
- Pods wrap one or more containers.
- Pods are **ephemeral**:
  - If a Pod crashes, it won’t be recreated automatically.
  - This makes Pods unsuitable for production as-is.

---

## 📌 2. What is a ReplicaSet?
- Ensures that a specified number of **replicas of a Pod** are running at all times.
- If a Pod fails or is deleted, the ReplicaSet creates a new one.
- Handles **scaling** (up/down replicas).
- **But:** ReplicaSet doesn’t support **rolling updates**.

## 3. Deployment
- A higher-level controller that manages ReplicaSets.
- Handles
   - Rolling updates (upgrade containers without downtime).
   - Rollbacks (go back to previous version).
   - Scaling (up/down easily).
- ✅ The most common way to run apps in Kubernetes.
👉 Think of ReplicaSet as: **Pod + self-healing + scaling**

# 🚀 Scaling and Rolling Updates in Kubernetes

## 📌 Scaling in Kubernetes

### 🔹 What is Scaling?
Scaling means **increasing or decreasing the number of Pods** in a Deployment or ReplicaSet.

- **Horizontal Scaling** → Increase or decrease the number of Pod replicas.  
- **Vertical Scaling** → Adjust CPU/Memory resources of Pods (less common, requires pod restart).  

Kubernetes makes scaling simple and allows both manual and automatic scaling.

---

### 🔹 Manual Scaling with `kubectl`

Suppose you have a Deployment named `nginx-deployment` with 2 replicas.

- Check deployments:
```bash
kubectl get deployments
```
- Scale to 5 replicas:
```bash
kubectl scale deployment nginx-deployment --replicas=5
```
- Verify the pods:
```bash
kubectl get pods
```
- Scale back to 3 replicas:
```bash
kubectl scale deployment nginx-deployment --replicas=3
```
---
### 🔹 Auto Scaling with HPA (Horizontal Pod Autoscaler)
Kubernetes can automatically scale Pods based on CPU or memory usage using **Horizontal Pod Autoscaler (HPA)**.
Enable autoscaling:
```bash
kubectl autoscale deployment nginx-deployment --min=2 --max=10 --cpu-percent=70
```
This configuration means:

   - Minimum 2 Pods, maximum 10 Pods.

   - If average CPU usage per Pod exceeds 70%, Kubernetes will add more Pods.

Check HPA:
```bash
kubectl get hpa
```
---

## 🔄 Rolling Updates in Kubernetes
###🔹 What is a Rolling Update?

A Rolling Update gradually replaces old Pods with new ones without downtime.

- Old Pods are terminated after new Pods are running.

- Ensures the application remains available during the update.

- Default update strategy in Kubernetes is RollingUpdate.

---
### 🔹 Example: Deploy Nginx

Let’s say you deploy an Nginx app (v1.14):

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
Apply the deployment:
```
kubectl apply -f nginx-deployment.yaml
```
---
**🔹 Performing a Rolling Update**
Update the Nginx version:
```
kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1
```
Check rollout progress:
```
kubectl rollout status deployment/nginx-deployment
```
Watch Pods update one by one:
```
kubectl get pods -w
```
**🔹 Rollback if Something Goes Wrong**
Undo the update:
```
kubectl rollout undo deployment/nginx-deployment
```
Check history of rollouts:
```
kubectl rollout history deployment/nginx-deployment
```
---
### ✅ Summary

- Scaling ensures your app can handle more/less traffic by changing Pod counts.

- Rolling Updates let you upgrade your app version with zero downtime.

- Kubernetes also supports rollback if something breaks.

- Together, these features make applications highly available and resilient.

## ❤️ Follow My DevOps Journey
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GITHUB](https://github.com/ritesh355/Devops-journal)




























