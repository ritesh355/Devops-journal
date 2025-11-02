# : Mastering Volumes and Persistent Storage in Kubernetes

## Introduction
t volume types (`emptyDir`, `hostPath`), dive into PVs, PVCs, and StorageClasses, and wrap up with a hands-on example of deploying a MySQL database with persistent storage. If you missed Day 6 on ConfigMaps and Secrets. Let’s dive in!

## Understanding Kubernetes Volumes

**Volumes** in Kubernetes allow Pods to store and access data beyond their ephemeral lifecycle. A Volume is attached to a Pod and can be mounted into containers, providing a way to share data or persist it across restarts.

### Volume Types

1. **emptyDir**:
   - **What is it?**: A temporary volume created when a Pod is assigned to a node. It’s deleted when the Pod is removed.
   - **Use Case**: Temporary storage for caching, scratch space, or sharing data between containers in the same Pod.
   - **Pros**: Simple, no external setup needed.
   - **Cons**: Data is lost when the Pod terminates.
   - **Example**:
     ```yaml
     volumes:
     - name: temp-storage
       emptyDir: {}
     ```

2. **hostPath**:
   - **What is it?**: Mounts a file or directory from the host node’s filesystem into the Pod.
   - **Use Case**: Accessing node logs, configuration files, or for development/testing.
   - **Pros**: Easy to set up for node-specific data.
   - **Cons**: Not portable across nodes; security risks if not restricted.
   - **Example**:
     ```yaml
     volumes:
     - name: host-storage
       hostPath:
         path: /data
         type: Directory
     ```

### Persistent Volumes (PVs) and Persistent Volume Claims (PVCs)

For persistent storage, Kubernetes uses **Persistent Volumes (PVs)** and **Persistent Volume Claims (PVCs)** to abstract storage provisioning and consumption.

- **Persistent Volume (PV)**:
  - A cluster-wide resource representing a piece of storage (e.g., NFS, cloud storage like AWS EBS, or local disk).
  - Defined by capacity, access modes (`ReadWriteOnce`, `ReadOnlyMany`, `ReadWriteMany`), and storage backend.
  - Created by cluster admins or dynamically via StorageClasses.
  - Example:
    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: my-pv
    spec:
      capacity:
        storage: 1Gi
      accessModes:
        - ReadWriteOnce
      hostPath:
        path: /mnt/data
    ```

- **Persistent Volume Claim (PVC)**:
  - A user’s request for storage, specifying size and access mode.
  - Kubernetes binds a PVC to a suitable PV or dynamically provisions one.
  - Pods use PVCs as volumes, abstracting the underlying storage details.
  - Example:
    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: my-pvc
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
    ```

### StorageClass

**StorageClass** enables dynamic provisioning of PVs, eliminating the need for admins to pre-create PVs. It defines the storage provider (e.g., AWS EBS, GCP Persistent Disk) and parameters like performance or replication.

- **Why Use StorageClass?**
  - Automates PV creation when a PVC is requested.
  - Supports cloud-specific or custom storage configurations.
  - Example:
    ```yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: standard
    provisioner: kubernetes.io/aws-ebs
    parameters:
      type: gp2
    ```

- PVCs reference a StorageClass to trigger dynamic provisioning:
  ```yaml
  spec:
    storageClassName: standard
  ```

## Hands-On: Deploying MySQL with Persistent Storage

Let’s deploy a MySQL database with persistent storage using a PVC and StorageClass. We’ll create a namespace, a Secret for the MySQL password, a PVC for storage, and a Deployment to run MySQL. Assume you’re using a cluster with a StorageClass (e.g., minikube or a cloud provider).

### Step 1: Create a Namespace

```yaml
# mysql-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mysql-app
```

Apply: `kubectl apply -f mysql-namespace.yaml`

### Step 2: Create a Secret for MySQL Password

```yaml
# mysql-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: mysql-app
type: Opaque
data:
  mysql-root-password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
```

Apply: `kubectl apply -f mysql-secret.yaml`

### Step 3: Create a PersistentVolumeClaim

We’ll request 1Gi of storage. If your cluster has a default StorageClass (e.g., `standard` in minikube), it will dynamically provision a PV.

```yaml
# mysql-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: mysql-app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard  # Adjust based on your cluster
```

Apply: `kubectl apply -f mysql-pvc.yaml`

Verify: `kubectl get pvc -n mysql-app`

### Step 4: Deploy MySQL with Persistent Storage

Create a Deployment that mounts the PVC and uses the Secret.

```yaml
# mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: mysql-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
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

Apply: `kubectl apply -f mysql-deployment.yaml`

Verify: `kubectl get pods -n mysql-app`

### Step 5: Expose MySQL with a Service

```yaml
# mysql-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: mysql-app
spec:
  selector:
    app: mysql
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
  type: ClusterIP
```

Apply: `kubectl apply -f mysql-service.yaml`

### Step 6: Test the MySQL Deployment

Port-forward to access MySQL:

```
kubectl port-forward svc/mysql-service -n mysql-app 3306:3306
```

Connect using a MySQL client (e.g., `mysql -h localhost -u root -psupersecret`). Create a table and insert data to verify persistence.

To confirm persistence, delete the Pod and let the Deployment recreate it:

```
kubectl delete pod -l app=mysql -n mysql-app
```

Reconnect and verify the data is still there, thanks to the PVC.

### Cleanup

```
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-service.yaml
kubectl delete -f mysql-pvc.yaml
kubectl delete -f mysql-secret.yaml
kubectl delete -f mysql-namespace.yaml
```

This hands-on demo shows how to use PVCs to provide persistent storage for a stateful application like MySQL.

## Best Practices

- **Volumes**:
  - Use `emptyDir` for temporary data and `hostPath` only for specific use cases (e.g., development).
  - Prefer PVCs for production workloads requiring persistence.

- **PVs and PVCs**:
  - Specify appropriate access modes based on your application’s needs.
  - Use descriptive names for PVs and PVCs to track their purpose.
  - Monitor PV usage to avoid running out of storage.

- **StorageClass**:
  - Define StorageClasses tailored to your environment (e.g., SSD vs. HDD).
  - Set a default StorageClass for dynamic provisioning: `kubectl annotate storageclass standard storageclass.kubernetes.io/is-default-class=true`.
  - Test dynamic provisioning in non-production environments first.

- **MySQL Specific**:
  - Always secure MySQL with a Secret for passwords.
  - Use appropriate storage backends (e.g., SSD-based for performance).
  - Consider StatefulSets for MySQL in production for stable Pod identities.

## Conclusion

Volumes, PVs, PVCs, and StorageClasses provide a robust framework for managing data in Kubernetes. From temporary `emptyDir` volumes to dynamic provisioning with StorageClasses, these tools ensure your applications can handle data reliably, even for stateful workloads like MySQL.



Thanks for reading! 🚀

*Originally posted on Hashnode on October 9, 2025.*
