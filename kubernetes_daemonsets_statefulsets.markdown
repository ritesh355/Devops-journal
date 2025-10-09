# Day 58: Exploring DaemonSets and StatefulSets in Kubernetes

## Introduction

Welcome to Day 58 of my Kubernetes learning journey! Today, we’re diving into **DaemonSets** and **StatefulSets**, two specialized Kubernetes controllers designed for specific workload patterns. While Deployments are great for stateless applications, DaemonSets and StatefulSets cater to unique use cases like running node-level agents and managing stateful applications.

In this post, we’ll explore what DaemonSets and StatefulSets are, their use cases, and conclude with hands-on examples of deploying a logging agent with a DaemonSet and a stateful application (MongoDB) with a StatefulSet. If you missed Day 7 on Volumes and Persistent Storage. Let’s get started!

## Understanding DaemonSets

**DaemonSets** ensure that a copy of a Pod runs on every node in the cluster (or a subset of nodes, if specified). They’re ideal for cluster-wide services like logging, monitoring, or networking agents that need to be present on all nodes.

- **Why Use DaemonSets?**
  - **Node-Level Coverage**: Run a Pod on every node, automatically scaling as new nodes are added.
  - **Consistency**: Ensure consistent services (e.g., log collectors, metrics agents) across the cluster.
  - **Node-Specific Tasks**: Perform tasks like collecting node logs or monitoring node health.

- **How It Works**:
  - Kubernetes schedules one Pod per node, matching the DaemonSet’s `PodTemplate`.
  - If a new node is added, the DaemonSet automatically deploys a Pod to it.
  - If a node is removed, the Pod is garbage-collected.
  - Use `nodeSelector` or taints/tolerations to limit the DaemonSet to specific nodes.

- **Example Use Cases**:
  - Deploying Fluentd or Filebeat for log collection on every node.
  - Running Prometheus node-exporter for monitoring node metrics.
  - Deploying a network proxy like Cilium or Calico.

- **Example DaemonSet YAML**:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: logging-agent
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:v1.14-1
```

## Understanding StatefulSets

**StatefulSets** are designed for stateful applications that require stable identities, persistent storage, and ordered deployment/scaling. Unlike Deployments, which treat Pods as interchangeable, StatefulSets provide guarantees about Pod identity and order.

- **Why Use StatefulSets?**
  - **Stable Identity**: Each Pod gets a unique, predictable name (e.g., `db-0`, `db-1`) and hostname.
  - **Ordered Operations**: Pods are created, scaled, or deleted in a specific order (e.g., `db-0` before `db-1`).
  - **Persistent Storage**: Each Pod can have its own PersistentVolumeClaim for consistent storage.

- **How It Works**:
  - Pods are named sequentially (e.g., `app-0`, `app-1`).
  - A headless Service (no ClusterIP) manages network identity, providing DNS entries like `app-0.app-service`.
  - Scaling up/down or updates happen in order, ensuring stability for stateful apps.
  - Persistent storage is tied to each Pod via PVCs.

- **Example Use Cases**:
  - Databases like MongoDB, MySQL, or PostgreSQL.
  - Distributed systems like Cassandra, ZooKeeper, or Kafka.
  - Applications requiring unique network identities or stable storage.

- **Example StatefulSet YAML**:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  serviceName: mongodb-service
  replicas: 2
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:5.0
```

## Hands-On: Deploying a Logging Agent and MongoDB

Let’s put these concepts into practice by deploying a **Fluentd logging agent** using a DaemonSet and a **MongoDB database** using a StatefulSet with persistent storage.

### Part 1: Deploying Fluentd with a DaemonSet

We’ll deploy Fluentd as a logging agent on every node to collect logs.

#### Step 1: Create a Namespace

```yaml
# logging-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: logging
```

Apply: `kubectl apply -f logging-namespace.yaml`

#### Step 2: Create a DaemonSet for Fluentd

```yaml
# fluentd-daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: logging
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:v1.14-1
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 100Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

Apply: `kubectl apply -f fluentd-daemonset.yaml`

Verify: `kubectl get pods -n logging -o wide`

This DaemonSet runs Fluentd on every node, mounting the node’s `/var/log` directory to collect logs.

### Part 2: Deploying MongoDB with a StatefulSet

We’ll deploy MongoDB with persistent storage and a headless Service for stable network identity.

#### Step 1: Create a Namespace

We’ll reuse the `mysql-app` namespace from Day 7 or create a new one:

```yaml
# mongodb-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mongodb-app
```

Apply: `kubectl apply -f mongodb-namespace.yaml`

#### Step 2: Create a Secret for MongoDB

```yaml
# mongodb-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
  namespace: mongodb-app
type: Opaque
data:
  mongodb-root-password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
```

Apply: `kubectl apply -f mongodb-secret.yaml`

#### Step 3: Create a Headless Service

A headless Service (no ClusterIP) provides DNS entries for each Pod.

```yaml
# mongodb-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
  namespace: mongodb-app
spec:
  clusterIP: None  # Headless Service
  selector:
    app: mongodb
  ports:
  - protocol: TCP
    port: 27017
    targetPort: 27017
```

Apply: `kubectl apply -f mongodb-service.yaml`

#### Step 4: Create a PersistentVolumeClaim

Each MongoDB Pod gets its own PVC for storage.

```yaml
# mongodb-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
  namespace: mongodb-app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard  # Adjust based on your cluster
```

Apply: `kubectl apply -f mongodb-pvc.yaml`

#### Step 5: Create a StatefulSet for MongoDB

```yaml
# mongodb-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
  namespace: mongodb-app
spec:
  serviceName: mongodb-service
  replicas: 2
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:5.0
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: mongodb-root-password
        volumeMounts:
        - name: mongodb-storage
          mountPath: /data/db
  volumeClaimTemplates:
  - metadata:
      name: mongodb-storage
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
      storageClassName: standard
```

Apply: `kubectl apply -f mongodb-statefulset.yaml`

Verify: `kubectl get pods -n mongodb-app`

Pods will be named `mongodb-0`, `mongodb-1`, etc., with stable DNS entries like `mongodb-0.mongodb-service.mongodb-app.svc.cluster.local`.

#### Step 6: Test MongoDB

Port-forward to access MongoDB:

```
kubectl port-forward mongodb-0 -n mongodb-app 27017:27017
```

Connect using a MongoDB client (e.g., `mongo -u root -p supersecret localhost:27017`). Create a database and insert data.

To test persistence and ordering, delete a Pod and verify data is retained:

```
kubectl delete pod mongodb-0 -n mongodb-app
```

Reconnect to confirm data persists and Pods are recreated in order.

### Cleanup

```
kubectl delete -f fluentd-daemonset.yaml
kubectl delete -f mongodb-statefulset.yaml
kubectl delete -f mongodb-service.yaml
kubectl delete -f mongodb-pvc.yaml
kubectl delete -f mongodb-secret.yaml
kubectl delete -f logging-namespace.yaml
kubectl delete -f mongodb-namespace.yaml
```

This hands-on demo illustrates how DaemonSets ensure node-level coverage and StatefulSets manage stateful applications with stable identities and storage.

## Best Practices

- **DaemonSets**:
  - Use for node-level tasks like logging or monitoring, not for general workloads.
  - Limit resource usage to avoid impacting other Pods on the node.
  - Use `nodeSelector` or taints/tolerations to target specific nodes.

- **StatefulSets**:
  - Use for applications requiring stable identities or ordered operations.
  - Always pair with a headless Service for DNS-based Pod discovery.
  - Ensure PVCs are backed by reliable storage for production databases.

- **General**:
  - Monitor resource usage of DaemonSet Pods to avoid node overload.
  - Test StatefulSet scaling and failover in a non-production environment.
  - Use namespaces to organize related resources.

## Conclusion

DaemonSets and StatefulSets are powerful tools for specific Kubernetes workloads. DaemonSets ensure critical services run on every node, while StatefulSets provide the stability needed for stateful applications like databases. Mastering these controllers unlocks the ability to manage complex, real-world applications in Kubernetes.


Thanks for reading! 🚀


