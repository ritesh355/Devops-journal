# Day 60: Mastering Probes and Resource Management in Kubernetes

## Introduction

Welcome to Day 60 of my DevOps learning journey! Today, we’re diving into **Probes** and **Resource Management** in Kubernetes, critical concepts for ensuring application health and efficient resource utilization. Probes help Kubernetes monitor the state of your containers, while resource requests and limits ensure fair and predictable resource allocation across your cluster.

In this post, we’ll explore **Liveness**, **Readiness**, and **Startup** probes, the difference between resource **Requests** and **Limits**, and conclude with a hands-on example of deploying an application with probes and resource constraints. If you missed Day 59 on Jobs and CronJobs, check it out [here](link-to-day-59-post). Let’s get started!

## Understanding Probes

**Probes** are diagnostic checks Kubernetes performs on containers to determine their health or readiness. They help ensure your application is running correctly and available to serve traffic.

### Types of Probes

1. **Liveness Probe**:
   - **Purpose**: Determines if a container is running correctly. If the probe fails, Kubernetes restarts the container.
   - **Use Case**: Detect and recover from crashes, deadlocks, or hung processes.
   - **Example**: Check if a web server is responding to HTTP requests.

2. **Readiness Probe**:
   - **Purpose**: Determines if a container is ready to serve traffic. If the probe fails, the container is removed from Service endpoints.
   - **Use Case**: Prevent traffic from reaching containers that are starting up, overloaded, or unhealthy.
   - **Example**: Ensure a database connection is established before serving requests.

3. **Startup Probe**:
   - **Purpose**: Delays liveness and readiness probes until a container has fully started. Useful for apps with long initialization times.
   - **Use Case**: Avoid restarting slow-starting applications prematurely.
   - **Example**: Wait for a legacy app to complete its startup process.

### Probe Types and Configuration

Probes can be configured to use one of three methods:
- **HTTP**: Sends an HTTP GET request to an endpoint (e.g., `/health`). Expects a 200–399 status code.
- **TCP**: Checks if a TCP connection can be established on a specified port.
- **Command**: Executes a command inside the container. Expects a zero exit code.

Common probe parameters:
- `initialDelaySeconds`: Time to wait after container startup before probing.
- `periodSeconds`: How often to probe.
- `timeoutSeconds`: How long to wait for a response.
- `successThreshold`: Number of successful checks to consider healthy.
- `failureThreshold`: Number of failed checks to consider unhealthy.

Example Liveness Probe (HTTP):

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3
```

## Understanding Resource Management

Kubernetes allows you to manage CPU and memory usage for containers using **Requests** and **Limits**.

- **Requests**:
  - Specify the minimum resources a container needs (e.g., `cpu: "100m"`, `memory: "128Mi"`).
  - Used by the scheduler to place Pods on nodes with sufficient resources.
  - Ensures the container gets at least the requested resources.

- **Limits**:
  - Specify the maximum resources a container can use.
  - Prevents a container from consuming excessive resources and impacting others.
  - CPU limits throttle usage; memory limits trigger OOM (Out-Of-Memory) kills if exceeded.

- **Units**:
  - **CPU**: Measured in cores (e.g., `1` for one core, `100m` for 100 milli-cores or 0.1 core).
  - **Memory**: Measured in bytes (e.g., `128Mi` for 128 mebibytes, `1Gi` for 1 gibibyte).

Example Resource Configuration:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"
```

- **Why Use Requests and Limits?**
  - **Predictability**: Ensures fair resource allocation across Pods.
  - **Stability**: Prevents resource starvation or node crashes.
  - **Efficiency**: Optimizes cluster resource usage.

## Hands-On: Deploying an App with Probes and Resource Limits

Let’s deploy an Nginx application with liveness and readiness probes, and set CPU and memory requests/limits. We’ll use a namespace, a ConfigMap for Nginx configuration, and a Deployment with probes and resource constraints.

### Step 1: Create a Namespace

```yaml
# nginx-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-app
```

Apply: `kubectl apply -f nginx-namespace.yaml`

### Step 2: Create a ConfigMap for Nginx

We’ll configure Nginx with a health check endpoint.

```yaml
# nginx-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: nginx-app
data:
  nginx.conf: |
    server {
      listen 80;
      server_name localhost;
      location / {
        root /usr/share/nginx/html;
        index index.html;
      }
      location /health {
        return 200 "healthy\n";
      }
    }
```

Apply: `kubectl apply -f nginx-configmap.yaml`

### Step 3: Create a Deployment with Probes and Resources

This Deployment includes liveness and readiness probes, and sets CPU/memory requests and limits.

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: nginx-app
spec:
  replicas: 2
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
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "256Mi"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        volumeMounts:
        - name: config-volume
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: config-volume
        configMap:
          name: nginx-config
          items:
          - key: nginx.conf
            path: default.conf
```

Apply: `kubectl apply -f nginx-deployment.yaml`

### Step 4: Expose the Deployment

```yaml
# nginx-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx-app
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

### Step 5: Test the Application

Port-forward to access Nginx:

```
kubectl port-forward svc/nginx-service -n nginx-app 8080:80
```

Open `localhost:8080` in a browser to see the Nginx welcome page, or test the health endpoint:

```
curl localhost:8080/health
```

Expected output: `healthy`

### Step 6: Verify Probes and Resource Limits

- **Check Probe Status**:
  ```
  kubectl describe pod -n nginx-app
  ```
  Look for `Liveness` and `Readiness` probe events to confirm they’re working.

- **Test Liveness Probe Failure**:
  Simulate a failure by modifying the Nginx config to break the `/health` endpoint. Edit the ConfigMap to return a 500 status:

  ```yaml
  # Update nginx-configmap.yaml
  location /health {
    return 500 "unhealthy\n";
  }
  ```

  Apply: `kubectl apply -f nginx-configmap.yaml`

  Kubernetes will detect the liveness probe failure and restart the Pod. Verify with:

  ```
  kubectl get pods -n nginx-app -w
  ```

- **Verify Resource Limits**:
  Check resource usage with a tool like `kubectl top`:

  ```
  kubectl top pod -n nginx-app
  ```

  Ensure CPU and memory stay within the specified limits (`500m` CPU, `256Mi` memory).

### Cleanup

```
kubectl delete -f nginx-deployment.yaml
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-configmap.yaml
kubectl delete -f nginx-namespace.yaml
```

This hands-on demo shows how to use probes to monitor application health and resource limits to control resource usage.

## Best Practices

- **Probes**:
  - Use **liveness probes** sparingly to avoid unnecessary restarts; focus on critical health checks.
  - Set **readiness probes** to ensure traffic only reaches ready containers.
  - Use **startup probes** for slow-starting apps to prevent premature failures.
  - Tune `initialDelaySeconds` and `failureThreshold` to match your app’s behavior.

- **Resource Management**:
  - Set **requests** based on minimum requirements and **limits** to prevent overuse.
  - Monitor resource usage with `kubectl top` or metrics tools like Prometheus.
  - Avoid setting limits too low, as it may cause OOM kills or CPU throttling.
  - Use cluster-wide policies (e.g., LimitRange, ResourceQuota) to enforce defaults.

## Conclusion

Probes and resource management are essential for building reliable and efficient Kubernetes applications. Liveness, readiness, and startup probes ensure your containers are healthy and ready to serve traffic, while requests and limits optimize resource allocation. Together, they help maintain a stable and performant cluster.

Stay tuned for Day 61, where we’ll explore advanced topics like Horizontal Pod Autoscaling! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 9, 2025.*
