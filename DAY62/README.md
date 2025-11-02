# Day 62: Service Accounts and Secrets for Applications in Kubernetes

## Introduction

Welcome to Day 62 of my DevOps learning journey! Today, we’re exploring **Service Accounts** and **Secrets** in Kubernetes, focusing on how to use Service Accounts to provide applications with secure access to external resources, such as a database. Service Accounts allow Pods to authenticate with the Kubernetes API or external services, while Secrets store sensitive data like database credentials.

In this post, we’ll cover the basics of Service Accounts, how they integrate with Secrets, and a hands-on example of configuring a Service Account for an application to access a MySQL database. If you missed Day 61 on Ingress and Ingress Controllers, check it out [here](link-to-day-61-post). Let’s dive in!

## Understanding Service Accounts

**Service Accounts** in Kubernetes provide an identity for Pods or processes to interact with the Kubernetes API or external services. They are essential for applications that need to authenticate to perform actions, such as accessing a database or querying the Kubernetes API.

- **Why Use Service Accounts?**
  - **Authentication**: Provide a secure identity for Pods to interact with the Kubernetes API or external systems.
  - **Authorization**: Use Role-Based Access Control (RBAC) to control what a Service Account can do.
  - **Integration**: Enable applications to securely access resources like databases, cloud services, or APIs.

- **Key Concepts**:
  - Each Service Account has an associated **token** (stored as a Secret) that Pods can use for authentication.
  - By default, Pods are assigned the `default` Service Account in their namespace unless specified otherwise.
  - Service Accounts are namespace-scoped.

- **Creating a Service Account**:
  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: app-sa
    namespace: my-app
  ```

- **Using a Service Account in a Pod**:
  ```yaml
  spec:
    serviceAccountName: app-sa
  ```

## Integrating Secrets with Service Accounts

**Secrets** store sensitive data, such as database credentials or API keys, and can be mounted into Pods as environment variables or files. When a Service Account is created, Kubernetes automatically generates a Secret containing a token for API authentication, which can be used by Pods.

- **Service Account Token Secret**:
  - Automatically created with a name like `<service-account-name>-token-<random-suffix>`.
  - Contains a JSON Web Token (JWT) for authenticating with the Kubernetes API.
  - Example:
    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: app-sa-token-xyz
      namespace: my-app
      annotations:
        kubernetes.io/service-account.name: app-sa
    type: kubernetes.io/service-account-token
    ```

- **Custom Secrets for Applications**:
  - You can create Secrets for application-specific credentials (e.g., database passwords).
  - Mount these Secrets into Pods alongside the Service Account for secure access.

- **Why Use Secrets with Service Accounts?**
  - Securely provide credentials to applications without hardcoding them.
  - Enable RBAC to control access to Secrets.
  - Integrate with external systems like databases or cloud providers.

## Hands-On: Service Account for App-to-Database Access

Let’s create a hands-on example where an application uses a Service Account to access a MySQL database. We’ll deploy a MySQL database, create a Service Account for an application, and use a Secret to provide database credentials. The application will be a simple script that connects to the database.

### Step 1: Create a Namespace

```yaml
# app-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: app-db
```

Apply: `kubectl apply -f app-namespace.yaml`

### Step 2: Deploy MySQL with a Secret

First, create a Secret for the MySQL root password.

```yaml
# mysql-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: app-db
type: Opaque
data:
  mysql-root-password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
```

Create a PersistentVolumeClaim (PVC) for MySQL storage.

```yaml
# mysql-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: app-db
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
```

Deploy MySQL.

```yaml
# mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: app-db
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

Create a Service for MySQL.

```yaml
# mysql-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: app-db
spec:
  selector:
    app: mysql
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

### Step 3: Create a Service Account

Create a Service Account for the application.

```yaml
# app-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: app-db
```

Apply: `kubectl apply -f app-sa.yaml`

### Step 4: Create a Secret for Application Database Credentials

Create a Secret for the application to access the MySQL database.

```yaml
# app-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-db-secret
  namespace: app-db
type: Opaque
data:
  db-user: cm9vdA==          # base64-encoded "root"
  db-password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
  db-host: bXlzcWwtc2VydmljZQ==  # base64-encoded "mysql-service"
```

Apply: `kubectl apply -f app-secret.yaml`

### Step 5: Deploy the Application

We’ll deploy a simple Python application using the `mysql-connector-python` library to connect to the MySQL database. The application will use the Service Account and mount the Secret for credentials.

First, create a ConfigMap for the Python script.

```yaml
# app-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-script
  namespace: app-db
data:
  db_connect.py: |
    import mysql.connector
    import os
    import time

    while True:
        try:
            conn = mysql.connector.connect(
                host=os.getenv("DB_HOST"),
                user=os.getenv("DB_USER"),
                password=os.getenv("DB_PASSWORD"),
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

Deploy the application.

```yaml
# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: db-app
  namespace: app-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db-app
  template:
    metadata:
      labels:
        app: db-app
    spec:
      serviceAccountName: app-sa
      containers:
      - name: db-app
        image: python:3.9
        command: ["python", "/app/db_connect.py"]
        env:
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: app-db-secret
              key: db-user
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-db-secret
              key: db-password
        - name: DB_HOST
          valueFrom:
            secretKeyRef:
              name: app-db-secret
              key: db-host
        volumeMounts:
        - name: script
          mountPath: /app
      volumes:
      - name: script
        configMap:
          name: app-script
```

Apply:

```
kubectl apply -f app-configmap.yaml
kubectl apply -f app-deployment.yaml
```

### Step 6: Test the Application

Verify the application is running and connecting to the database:

```
kubectl get pods -n app-db
kubectl logs -f <db-app-pod-name> -n app-db
```

Expected output (repeated every 10 seconds):

```
Connected to database. Current time: 2025-10-10 12:34:56
```

### Step 7: Verify Service Account

Check the Service Account token is mounted in the Pod:

```
kubectl exec -it <db-app-pod-name> -n app-db -- ls /var/run/secrets/kubernetes.io/serviceaccount
```

Expected output: `ca.crt  namespace  token`

This confirms the Service Account token is available, though our application doesn’t use it directly in this case (it’s included for potential Kubernetes API access).

### Cleanup

```
kubectl delete -f app-deployment.yaml
kubectl delete -f app-configmap.yaml
kubectl delete -f app-secret.yaml
kubectl delete -f app-sa.yaml
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-service.yaml
kubectl delete -f mysql-pvc.yaml
kubectl delete -f mysql-secret.yaml
kubectl delete -f app-namespace.yaml
```

This hands-on demo shows how to use a Service Account and Secrets to enable an application to securely access a MySQL database.

## Best Practices

- **Service Accounts**:
  - Create dedicated Service Accounts for each application or workload to limit scope.
  - Use RBAC to restrict Service Account permissions to only what’s needed.
  - Avoid using the `default` Service Account for sensitive workloads.

- **Secrets**:
  - Store sensitive data like database credentials in Secrets, not ConfigMaps.
  - Use RBAC to control access to Secrets.
  - Enable encryption at rest for Secrets (consult your cluster admin).

- **General**:
  - Use namespaces to organize Service Accounts and Secrets.
  - Regularly rotate Secrets and Service Account tokens for security.
  - Monitor application logs to detect connection issues early.

## Conclusion

Service Accounts and Secrets are powerful tools for securing application access to resources like databases in Kubernetes. By combining Service Accounts with Secrets, you can provide secure, controlled access to external systems while keeping sensitive data safe.

Stay tuned for Day 63, where we’ll explore advanced RBAC and security policies! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 10, 2025.*
