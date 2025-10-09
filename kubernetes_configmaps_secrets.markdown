#  Managing Configuration with ConfigMaps and Secrets in Kubernetes

## Introduction

Welcome to Day 6 of my Kubernetes learning journey! Today, we're diving into **ConfigMaps** and **Secrets**, two essential Kubernetes resources for managing application configuration and sensitive data. These tools allow you to decouple configuration from your application code, making your apps more portable and secure.

In this post, we’ll explore how ConfigMaps and Secrets work, how to mount them as environment variables or files in Pods, and wrap up with a hands-on example of deploying an application using both. If you missed Day 5 on Namespaces, Labels, and Selectors, check it out [here](link-to-day-5-post). Let’s get started!

## Understanding ConfigMaps

**ConfigMaps** are Kubernetes objects used to store non-sensitive configuration data in key-value pairs or as files. They’re ideal for settings like application configurations, feature flags, or environment-specific parameters.

- **Why Use ConfigMaps?**
  - **Decouple Configuration**: Keep configuration separate from container images for portability.
  - **Reusability**: Share configuration across multiple Pods or environments.
  - **Flexibility**: Store simple key-value pairs or entire configuration files.

- **Creating a ConfigMap**:
  - **From Literal Values**:
    ```
    kubectl create configmap my-config --from-literal=app.name=myapp --from-literal=log.level=debug
    ```
  - **From a File**:
    ```
    echo -e "app.name=myapp\nlog.level=debug" > config.properties
    kubectl create configmap my-config --from-file=config.properties
    ```
  - **Using YAML**:

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
  namespace: my-app
data:
  app.name: myapp
  log.level: debug
  config.properties: |
    database.url=jdbc:mysql://localhost:3306/mydb
    database.enabled=true
```

Apply: `kubectl apply -f configmap.yaml`

- **Accessing ConfigMaps**:
  - As **environment variables** in a Pod.
  - As **files** mounted in a volume.
  - Via the Kubernetes API (advanced use case).

## Understanding Secrets

**Secrets** are similar to ConfigMaps but designed for sensitive data like passwords, API keys, or certificates. They’re stored in base64-encoded format and can be encrypted at rest (depending on cluster configuration).

- **Why Use Secrets?**
  - **Security**: Keep sensitive data separate from application code.
  - **Access Control**: Use RBAC to restrict who can read Secrets.
  - **Integration**: Mount as environment variables or files, just like ConfigMaps.

- **Creating a Secret**:
  - **From Literal Values**:
    ```
    kubectl create secret generic my-secret --from-literal=db.password=supersecret
    ```
  - **From a File**:
    ```
    echo -n "supersecret" > db-password.txt
    kubectl create secret generic my-secret --from-file=db.password=db-password.txt
    ```
  - **Using YAML**:

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
  namespace: my-app
type: Opaque
data:
  db.password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
  api.key: YXBpa2V5MTIzNDU=      # base64-encoded "apikey12345"
```

Apply: `kubectl apply -f secret.yaml`

*Note*: The `data` field requires base64-encoded values. Use `echo -n "value" | base64` to encode manually.

- **Accessing Secrets**: Like ConfigMaps, Secrets can be mounted as environment variables or files.

## Mounting ConfigMaps and Secrets

You can inject ConfigMaps and Secrets into Pods in two primary ways:

1. **As Environment Variables**:
   - Reference specific keys from a ConfigMap or Secret.
   - Example:
     ```yaml
     env:
       - name: APP_NAME
         valueFrom:
           configMapKeyRef:
             name: my-config
             key: app.name
       - name: DB_PASSWORD
         valueFrom:
           secretKeyRef:
             name: my-secret
             key: db.password
     ```

2. **As Files in a Volume**:
   - Mount the entire ConfigMap or Secret as files in a directory.
   - Example:
     ```yaml
     volumes:
       - name: config-volume
         configMap:
           name: my-config
       - name: secret-volume
         secret:
           secretName: my-secret
     containers:
       - name: my-app
         volumeMounts:
           - name: config-volume
             mountPath: /etc/config
           - name: secret-volume
             mountPath: /etc/secrets
     ```

   Files appear at `/etc/config/config.properties` or `/etc/secrets/db.password`.

## Hands-On: Deploying an App with ConfigMap and Secret

Let’s deploy an Nginx-based application that uses a ConfigMap for configuration and a Secret for sensitive data. We’ll create a namespace, a ConfigMap, a Secret, and a Deployment that mounts them.

### Step 1: Create a Namespace

```yaml
# app-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-app
```

Apply: `kubectl apply -f app-namespace.yaml`

### Step 2: Create a ConfigMap

We’ll store Nginx configuration and app settings.

```yaml
# app-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: my-app
data:
  nginx.conf: |
    server {
      listen 80;
      server_name localhost;
      location / {
        root /usr/share/nginx/html;
        index index.html;
      }
    }
  app.settings: |
    app.name=my-nginx-app
    log.level=info
```

Apply: `kubectl apply -f app-configmap.yaml`

### Step 3: Create a Secret

Store a mock API key and database password.

```yaml
# app-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: my-app
type: Opaque
data:
  db.password: c3VwZXJzZWNyZXQ=  # base64-encoded "supersecret"
  api.key: YXBpa2V5MTIzNDU=      # base64-encoded "apikey12345"
```

Apply: `kubectl apply -f app-secret.yaml`

### Step 4: Deploy Nginx with ConfigMap and Secret

Create a Deployment that mounts the ConfigMap and Secret.

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: my-app
spec:
  replicas: 1
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
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: db.password
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: api.key
        - name: APP_NAME
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: app.settings
        volumeMounts:
        - name: config-volume
          mountPath: /etc/nginx/conf.d
        - name: secret-volume
          mountPath: /etc/secrets
      volumes:
      - name: config-volume
        configMap:
          name: app-config
          items:
          - key: nginx.conf
            path: default.conf
      - name: secret-volume
        secret:
          secretName: app-secret
```

Apply: `kubectl apply -f nginx-deployment.yaml`

### Step 5: Expose the Deployment

```yaml
# nginx-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: my-app
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

Apply: `kubectl apply -f nginx-service.yaml`

### Step 6: Test the Application

Port-forward to access Nginx:

```
kubectl port-forward svc/nginx-service -n my-app 8080:80
```

Open `localhost:8080` in a browser to see the Nginx welcome page.

Check mounted files and environment variables inside the Pod:

```
kubectl exec -it <pod-name> -n my-app -- bash
cat /etc/nginx/conf.d/default.conf  # View nginx.conf
cat /etc/secrets/db.password        # View secret
echo $DB_PASSWORD                   # View env variable
```

### Cleanup

```
kubectl delete -f nginx-deployment.yaml
kubectl delete -f nginx-service.yaml
kubectl delete -f app-configmap.yaml
kubectl delete -f app-secret.yaml
kubectl delete -f app-namespace.yaml
```

This hands-on demo shows how to use ConfigMaps and Secrets to manage configuration and sensitive data.

## Best Practices

- **ConfigMaps**:
  - Use meaningful key names and organize data logically.
  - Store large configs as files in `data` for clarity.
  - Avoid hardcoding configs in container images; use ConfigMaps instead.

- **Secrets**:
  - Always use Secrets for sensitive data, not ConfigMaps.
  - Enable encryption at rest for Secrets (consult your cluster admin).
  - Limit access using RBAC and avoid exposing Secrets unnecessarily.

- **General**:
  - Use namespaces to organize ConfigMaps and Secrets.
  - Keep ConfigMaps and Secrets small to avoid performance issues.
  - Validate mounted files and env variables during testing.

## Conclusion

ConfigMaps and Secrets are powerful tools for managing configuration and sensitive data in Kubernetes. By decoupling these from your application code, you make your apps more portable, secure, and easier to manage across environments.

Stay tuned for Day 7, where we’ll dive into Persistent Storage with Volumes and PersistentVolumeClaims! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 9, 2025.*
