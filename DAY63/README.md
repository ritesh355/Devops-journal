# Day 63: Controlling Pod-to-Pod Communication with Network Policies in Kubernetes

## Introduction

Welcome to Day 63 of my DevOps learning journey! Today, we’re diving into **Network Policies** in Kubernetes, a powerful mechanism for controlling network traffic between Pods. Network Policies allow you to define fine-grained rules to secure and manage Pod-to-Pod communication, ensuring only authorized traffic flows within your cluster.

In this post, we’ll explore the basics of Network Policies, their key components, and a hands-on example where we implement a **deny-all policy** and then allow specific traffic between Pods. If you missed Day 62 on Service Accounts and Secrets, check it out [here](link-to-day-62-post). Let’s get started!

## Understanding Network Policies

**Network Policies** are Kubernetes resources that define how Pods communicate with each other and with external endpoints. They act like a firewall, specifying which traffic is allowed or denied based on labels, namespaces, IP addresses, or ports.

- **Why Use Network Policies?**
  - **Security**: Restrict unauthorized access between Pods to prevent lateral movement in case of a breach.
  - **Isolation**: Enforce network segmentation for multi-tenant clusters or sensitive applications.
  - **Control**: Fine-tune traffic flow to optimize performance and compliance.

- **Key Concepts**:
  - **Pod Selector**: Identifies the Pods to which the policy applies using labels (e.g., `app: frontend`).
  - **Policy Types**: 
    - **Ingress**: Controls incoming traffic to Pods.
    - **Egress**: Controls outgoing traffic from Pods.
  - **Rules**: Define allowed traffic based on source/destination Pods, namespaces, or ports.
  - **Default Behavior**: Without a Network Policy, all traffic is allowed (unless a CNI plugin enforces otherwise).

- **Prerequisites**:
  - Your cluster must use a Container Network Interface (CNI) plugin that supports Network Policies, such as Calico, Cilium, or Weave Net.
  - Common cloud providers (e.g., AWS, GCP) support Network Policies with their managed CNI plugins.

- **Example Network Policy**:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-specific
  spec:
    podSelector:
      matchLabels:
        app: backend
    policyTypes:
    - Ingress
    ingress:
    - from:
      - podSelector:
          matchLabels:
            app: frontend
      ports:
      - protocol: TCP
        port: 8080
  ```
  This policy allows TCP traffic on port 8080 from Pods labeled `app: frontend` to Pods labeled `app: backend`.

## Network Policy Components

- **PodSelector**: Targets Pods in the same namespace based on labels.
- **PolicyTypes**: Specifies whether the policy applies to `Ingress`, `Egress`, or both.
- **From/To**: Defines the source (`ingress.from`) or destination (`egress.to`) of allowed traffic, using:
  - `podSelector`: Matches Pods in the same namespace.
  - `namespaceSelector`: Matches Pods in specific namespaces.
  - `ipBlock`: Matches traffic from/to specific IP ranges.
- **Ports**: Restricts traffic to specific protocols (e.g., TCP, UDP) and ports.

- **Default Deny-All Policy**:
  To block all traffic to/from a set of Pods:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: deny-all
  spec:
    podSelector: {}
    policyTypes:
    - Ingress
    - Egress
  ```
  This policy applies to all Pods in the namespace (`podSelector: {}`) and denies all ingress and egress traffic.

## Hands-On: Deny-All Policy with Specific Allow Rules

Let’s deploy two applications (a frontend and a backend) and use Network Policies to enforce a **deny-all policy** for the backend, then allow specific traffic from the frontend. We’ll use a namespace, deploy a MySQL backend and a Python frontend, and apply Network Policies to control communication.

### Step 1: Set Up the Environment

Ensure you have a Kubernetes cluster with a CNI plugin that supports Network Policies (e.g., Calico). For minikube, enable the Calico CNI:

```
minikube start --network-plugin=cni --cni=calico
```

### Step 2: Create a Namespace

```yaml
# app-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: net-policy
```

Apply: `kubectl apply -f app-namespace.yaml`

### Step 3: Deploy MySQL Backend

Create a Secret for the MySQL root password.

```yaml
# mysql-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: net-policy
type: Opaque
data:
  mysql-root-password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
```

Create a PVC for MySQL storage.

```yaml
# mysql-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: net-policy
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
```

Deploy MySQL with a label `app: mysql-backend`.

```yaml
# mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-backend
  namespace: net-policy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql-backend
  template:
    metadata:
      labels:
        app: mysql-backend
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: mysql-root-password
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
```

Create a Service for MySQL.

```yaml
# mysql-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: net-policy
spec:
  selector:
    app: mysql-backend
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
  type: ClusterIP
```

Apply all:

```
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
```

### Step 4: Deploy Python Frontend

Create a ConfigMap for a Python script that connects to the MySQL backend.

```yaml
# frontend-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-script
  namespace: net-policy
data:
  db_connect.py: |
    import mysql.connector
    import os
    import time

    while True:
        try:
            conn = mysql.connector.connect(
                host="mysql-service",
                user="root",
                password=os.getenv("MYSQL_ROOT_PASSWORD"),
                database="mysql"
            )
            cursor = conn.cursor()
            cursor.execute("SELECT NOW()")
            result = cursor.fetchone()
            print(f"Connected to database. Current time: {result[0]}")
            cursor.close()
            conn.close()
        except Exception as e:
            print(f"Error connecting to database: {e}")
        time.sleep(10)
```

Create a Secret for the frontend to access MySQL.

```yaml
# frontend-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: frontend-secret
  namespace: net-policy
type: Opaque
data:
  mysql-root-password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
```

Deploy the frontend with a label `app: frontend`.

```yaml
# frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: net-policy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: python:3.9
        command: ["python", "/app/db_connect.py"]
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: frontend-secret
              key: mysql-root-password
        volumeMounts:
        - name: script
          mountPath: /app
      volumes:
      - name: script
        configMap:
          name: frontend-script
```

Apply:

```
kubectl apply -f frontend-configmap.yaml
kubectl apply -f frontend-secret.yaml
kubectl apply -f frontend-deployment.yaml
```

### Step 5: Test Connectivity Without Network Policies

Verify the frontend can connect to the MySQL backend:

```
kubectl logs -f <frontend-pod-name> -n net-policy
```

Expected output (repeated every 10 seconds):

```
Connected to database. Current time: 2025-10-10 12:34:56
```

This confirms unrestricted communication, as no Network Policies are applied yet.

### Step 6: Apply a Deny-All Network Policy

Create a Network Policy to deny all ingress and egress traffic to/from the MySQL backend Pods.

```yaml
# deny-all-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-mysql
  namespace: net-policy
spec:
  podSelector:
    matchLabels:
      app: mysql-backend
  policyTypes:
  - Ingress
  - Egress
```

Apply: `kubectl apply -f deny-all-policy.yaml`

Wait a few seconds and check the frontend logs again:

```
kubectl logs -f <frontend-pod-name> -n net-policy
```

Expected output:

```
Error connecting to database: (2003, "Can't connect to MySQL server on 'mysql-service'...")
```

The deny-all policy blocks all traffic to the MySQL backend, causing the frontend to fail.

### Step 7: Allow Specific Traffic

Create a Network Policy to allow TCP traffic on port 3306 from Pods labeled `app: frontend` to Pods labeled `app: mysql-backend`.

```yaml
# allow-frontend-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-mysql
  namespace: net-policy
spec:
  podSelector:
    matchLabels:
      app: mysql-backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 3306
```

Apply: `kubectl apply -f allow-frontend-policy.yaml`

Check the frontend logs again:

```
kubectl logs -f <frontend-pod-name> -n net-policy
```

Expected output (resumes after a few seconds):

```
Connected to database. Current time: 2025-10-10 12:35:10
```

This confirms the frontend can now connect to the MySQL backend due to the allow rule.

### Cleanup

```
kubectl delete -f allow-frontend-policy.yaml
kubectl delete -f deny-all-policy.yaml
kubectl delete -f frontend-deployment.yaml
kubectl delete -f frontend-secret.yaml
kubectl delete -f frontend-configmap.yaml
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-service.yaml
kubectl delete -f mysql-pvc.yaml
kubectl delete -f mysql-secret.yaml
kubectl delete -f app-namespace.yaml
```

This hands-on demo shows how to enforce a deny-all Network Policy and selectively allow traffic between specific Pods.

## Best Practices

- **Network Policies**:
  - Start with a deny-all policy for sensitive workloads (e.g., databases) and add allow rules as needed.
  - Use descriptive labels to make podSelectors clear and maintainable.
  - Test policies in a non-production environment to avoid accidental outages.

- **Security**:
  - Combine Network Policies with RBAC to secure both network and API access.
  - Regularly audit Network Policies to ensure they align with security requirements.
  - Use `namespaceSelector` for cross-namespace policies when needed.

- **General**:
  - Verify your CNI plugin supports Network Policies before relying on them.
  - Monitor network traffic with tools like Prometheus or Cilium Hubble.
  - Document policies to track allowed traffic flows.

## Conclusion

Network Policies provide fine-grained control over Pod-to-Pod communication, enhancing security and isolation in Kubernetes clusters. By implementing a deny-all policy and selectively allowing traffic, you can protect sensitive applications like databases while maintaining necessary connectivity.

Stay tuned for Day 64, where we’ll explore advanced topics like Pod Disruption Budgets and cluster maintenance! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 10, 2025.*
