# 🟦Day 48 Kubernetes Journey – DevOps Journal  


I am practicing Kubernetes as part of my **100 Days of DevOps Journey**.  

---

## 📅 : Introduction to Kubernetes & Setup  

### 🔹 What is Kubernetes?
Kubernetes (K8s) is an **open-source container orchestration platform** for:
- Automating deployment  
- Scaling applications  
- Managing containerized workloads  

It ensures applications run reliably across multiple machines.  

---

### 🔹 Why Kubernetes (vs Docker & Docker Compose)?
- **Docker** → Runs a single containerized app.  
- **Docker Compose** → Runs multi-container apps but only on a single host.  
- **Kubernetes** → Runs and manages apps across **multiple nodes (cluster)** with scaling, self-healing, and load balancing.  

---

### 🔹 Kubernetes Architecture
1. **Control Plane (Master Node)**  
   - API Server → Frontend for cluster communication  
   - etcd → Key-value store (cluster state)  
   - Scheduler → Decides where Pods run  
   - Controller Manager → Ensures desired state  
  
2. **Worker Node**  
   - Kubelet → Talks to Control Plane  
   - Kube Proxy → Handles networking  
   - Container Runtime (Docker/CRI-O/containerd) → Runs containers  

---

# Kubernetes Architecture Overview

Kubernetes is a powerful container orchestration platform that manages containerized workloads and services across a cluster. The cluster is divided into two primary parts: the **Control Plane** (often referred to as the master node) and the **Worker Nodes**. Additionally, **Add-ons** provide extra functionality to enhance cluster operations. Below is a detailed breakdown of each component.

## 1. Control Plane (Master Node)

The **Control Plane** is responsible for managing the entire Kubernetes cluster. It makes global decisions about scheduling, scaling, and maintaining the desired state of the cluster. The control plane consists of several key components:

### API Server (kube-apiserver)
- **Role**: Acts as the entry point to the Kubernetes cluster.
- **Functionality**: 
  - Exposes the Kubernetes REST API, enabling interaction with the cluster.
  - Processes commands issued via tools like `kubectl`, which communicates directly with the API server to create, update, or delete resources such as pods, deployments, or services.
  - Validates and forwards requests to other control plane components, acting as a gatekeeper.
- **Example**: When you run `kubectl create deployment my-app --image=nginx`, the API server receives the command, validates it, and coordinates with other components to deploy the application.

### etcd
- **Role**: A distributed key-value database that stores the cluster's state.
- **Functionality**:
  - Holds all configuration data, including details about deployments, pods, services, and other resources.
  - Acts as the "brain memory" of Kubernetes, providing a single source of truth for the cluster's desired and current state.
  - Ensures consistency and reliability across the distributed system.
- **Example**: If a deployment specifies three replicas of a pod, etcd stores this information, allowing the scheduler and controllers to access it.

### Scheduler (kube-scheduler)
- **Role**: Determines the optimal placement of pods across the cluster's nodes.
- **Functionality**:
  - Evaluates resource availability (e.g., CPU, RAM), node constraints, and workload requirements to decide where to schedule a pod.
  - Optimizes cluster efficiency by balancing workloads across nodes.
- **Example**: If Node A is fully utilized but Node B has available CPU and RAM, the scheduler assigns a new pod to Node B.

### Controller Manager (kube-controller-manager)
- **Role**: Runs multiple controllers to maintain the cluster's desired state.
- **Functionality**:
  - Continuously monitors the cluster and reconciles the current state with the desired state.
  - Key controllers include:
    - **ReplicaSet Controller**: Ensures the specified number of pod replicas are running.
    - **Node Controller**: Monitors node health and marks nodes as "ready" or "not ready."
    - **Endpoint Controller**: Manages endpoints for services to enable communication.
- **Example**: If a pod crashes unexpectedly, the ReplicaSet controller detects the discrepancy and works with the scheduler to restart the pod.

## 2. Worker Nodes

**Worker Nodes** are the machines that run the actual application workloads in the form of pods. Each worker node hosts one or more pods and includes components to manage them and enable communication. The key components on a worker node are:

### Kubelet
- **Role**: An agent running on each worker node.
- **Functionality**:
  - Communicates with the API server to receive instructions about which pods to run.
  - Ensures that the pods and their containers are healthy and running as expected.
  - Reports the node's status back to the control plane.
- **Example**: If the API server instructs a node to run two Nginx pods, the kubelet ensures those pods are created and maintained.

### Kube-Proxy
- **Role**: Manages networking on each worker node.
- **Functionality**:
  - Handles traffic routing to the appropriate pods based on Kubernetes services (e.g., ClusterIP, NodePort, LoadBalancer).
  - Maintains network rules to enable communication between pods, services, and external clients.
- **Example**: If a service routes traffic to a pod running on Node B, kube-proxy ensures the traffic reaches the correct pod.

### Container Runtime (Docker, Containerd, CRI-O)
- **Role**: Responsible for running containers on the worker node.
- **Functionality**:
  - Executes and manages the lifecycle of containers based on instructions from the kubelet.
  - Common runtimes include Docker, Containerd, and CRI-O.
  - In setups like Minikube, Docker is often used as the container runtime.
- **Example**: When the kubelet instructs the runtime to start an Nginx container, the container runtime pulls the image and runs it.

## 3. Add-ons (Extra Services in Cluster)

**Add-ons** are additional services that enhance the functionality of a Kubernetes cluster. They are typically deployed as pods and provide features like service discovery, monitoring, and user interfaces. Key add-ons include:

### CoreDNS
- **Role**: Provides DNS-based service discovery within the cluster.
- **Functionality**:
  - Resolves service names to IP addresses, allowing pods to communicate using names like `my-service.default.svc.cluster.local`.
  - Essential for internal networking and service-to-service communication.
- **Example**: A pod can access another service by its DNS name, such as `my-app.default.svc.cluster.local`, thanks to CoreDNS.

### Dashboard
- **Role**: A web-based user interface for managing the Kubernetes cluster.
- **Functionality**:
  - Allows users to visualize cluster resources, monitor workloads, and perform administrative tasks.
  - Provides a graphical alternative to `kubectl` commands.
- **Example**: You can use the dashboard to view the status of pods or deploy new applications.

### Metrics Server
- **Role**: Collects and provides resource usage metrics for monitoring and auto-scaling.
- **Functionality**:
  - Gathers data on CPU and memory usage for pods and nodes.
  - Enables features like Horizontal Pod Autoscaling (HPA) to dynamically adjust the number of pod replicas based on demand.
- **Example**: If a pod's CPU usage exceeds a threshold, the Metrics Server can trigger the creation of additional pod replicas.

# 🚀 Kubernetes on Ubuntu with Minikube — Step-by-Step (Beginner Friendly)

This guide walks you through setting up **Kubernetes locally on Ubuntu** using **Minikube + Docker**, deploying your **first app**, and then **cleaning up**.

> ✅ Tested on Ubuntu (desktop) with Docker driver.  
> 🧠 Perfect for learning and local labs—no cloud account required.

---

## 📋 Prerequisites

- Ubuntu machine (VM or bare metal)
- ~2 CPUs, 2–4 GB RAM, 20 GB free disk
- Admin (sudo) access
- Internet connectivity

---

## 🧰 Step 1 — Install Dependencies

```bash
sudo apt update -y
sudo apt install -y curl wget apt-transport-https conntrack
```
---
##🐳 Step 2 — Install Docker (Container Runtime)
```bash
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```
- Add your user to the docker group (so you don’t need sudo for docker)
```bash
sudo usermod -aG docker $USER
newgrp docker   # apply group change immediately
```
- Verify Docker:
```bash
docker --version
docker run hello-world
```

## 🧠 Step 3 — Install kubectl (Kubernetes CLI)
```bash
# Step 1: Download kubectl
curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl

# Step 2: Make it executable
chmod +x kubectl

# Step 3: Move to /usr/local/bin/
sudo mv kubectl /usr/local/bin/

# Step 4: Verify installation
kubectl version --client
```
---
## 📦 Step 4 — Install Minikube

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```
---

## ▶️ Step 5 — Start Your Kubernetes Cluster
```bash
minikube start --driver=docker
```
Verify cluster is up:
```bash
kubectl cluster-info
kubectl get nodes
```
Expected:
```bash
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   Xs    v1.xx.x
```

## ❤️ Follow My DevOps Journey
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GITHUB](https://github.com/ritesh355/Devops-journal)
