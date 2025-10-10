# Day 61: Mastering Ingress and Ingress Controllers in Kubernetes

## Introduction

Welcome to Day 61 of my DevOps learning journey! Today, we’re diving into **Ingress** and **Ingress Controllers** in Kubernetes, powerful tools for managing external access to services within your cluster. Unlike Services, which handle internal load balancing, Ingress provides a way to route external HTTP/HTTPS traffic to multiple services based on rules like hostnames or paths.

In this post, we’ll cover the basics of Ingress, explore the Nginx Ingress Controller, and walk through a hands-on example of routing traffic to multiple services. If you missed Day 60 on Probes and Resource Management, check it out [here](link-to-day-60-post). Let’s get started!

## Understanding Ingress

**Ingress** is a Kubernetes resource that defines rules for routing external HTTP/HTTPS traffic to Services within the cluster. It acts as a layer 7 (application layer) router, allowing you to manage traffic based on hostnames, URL paths, or other HTTP attributes.

- **Why Use Ingress?**
  - **Centralized Routing**: Consolidate external access under a single entry point (e.g., a domain or IP).
  - **Path-Based Routing**: Route traffic to different services based on URL paths (e.g., `/api` to one service, `/web` to another).
  - **Host-Based Routing**: Serve multiple domains (e.g., `app1.example.com`, `app2.example.com`) from the same cluster.
  - **TLS Support**: Enable HTTPS with certificates for secure communication.
  - **Load Balancing**: Distribute traffic across Pods with customizable algorithms.

- **Key Components**:
  - **Ingress Resource**: A YAML file defining routing rules.
  - **Ingress Controller**: A software component (e.g., Nginx, Traefik) that implements the routing logic.
  - **Service and Pods**: The backend services and Pods that handle the actual traffic.

- **How It Works**:
  1. An Ingress Controller runs as a Pod (or set of Pods) in the cluster.
  2. The Ingress resource defines rules (e.g., route `/api` to `api-service`).
  3. The Ingress Controller reads the Ingress resource and configures itself to route traffic accordingly.
  4. External traffic hits the Ingress Controller (via a LoadBalancer or NodePort), which routes it to the appropriate Service.

## Understanding the Nginx Ingress Controller

The **Nginx Ingress Controller** is one of the most popular Ingress Controllers for Kubernetes. It uses the Nginx web server to handle traffic routing, leveraging its performance and flexibility.

- **Why Use Nginx Ingress Controller?**
  - **Performance**: Nginx is battle-tested for high-performance HTTP routing.
  - **Features**: Supports advanced routing, SSL termination, WebSocket, and more.
  - **Community Support**: Widely used, with extensive documentation and community resources.

- **Installation**:
  - Install using Helm or manifests from the official repository (`kubernetes/ingress-nginx`).
  - Example (using Helm):
    ```
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
    ```
  - This deploys the Nginx Ingress Controller as a Deployment with a LoadBalancer Service for external access.

- **Key Configurations**:
  - **Annotations**: Customize behavior (e.g., `nginx.ingress.kubernetes.io/rewrite-target` for URL rewrites).
  - **TLS**: Add TLS certificates for HTTPS.
  - **Load Balancing**: Configure session affinity, rate limiting, or custom headers.

## Hands-On: Routing Traffic to Multiple Services

Let’s deploy two Nginx-based services and use an Ingress resource with the Nginx Ingress Controller to route traffic based on paths. We’ll create a namespace, deploy two services, set up the Ingress Controller, and define an Ingress to route traffic to `/web1` and `/web2`.

### Step 1: Set Up the Environment

Ensure you have a Kubernetes cluster (e.g., minikube or a cloud provider). We’ll assume the Nginx Ingress Controller is not yet installed.

#### Install the Nginx Ingress Controller

Using Helm:

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

Verify the controller is running:

```
kubectl get pods -n ingress-nginx
```

Get the external IP (for cloud clusters) or use `minikube tunnel` for minikube:

```
kubectl get svc -n ingress-nginx
```

Note the external IP or hostname for testing.

### Step 2: Create a Namespace

```yaml
# app-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: web-app
```

Apply: `kubectl apply -f app-namespace.yaml`

### Step 3: Deploy Two Nginx Services

We’ll deploy two Nginx instances with different content to distinguish them.

#### Service 1: Web1

```yaml
# web1-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web1
  namespace: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web1
  template:
    metadata:
      labels:
        app: web1
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html
        configMap:
          name: web1-html
```

```yaml
# web1-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web1-html
  namespace: web-app
data:
  index.html: |
    <h1>Welcome to Web1</h1>
```

```yaml
# web1-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web1-service
  namespace: web-app
spec:
  selector:
    app: web1
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

#### Service 2: Web2

```yaml
# web2-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web2
  namespace: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web2
  template:
    metadata:
      labels:
        app: web2
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html
        configMap:
          name: web2-html
```

```yaml
# web2-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web2-html
  namespace: web-app
data:
  index.html: |
    <h1>Welcome to Web2</h1>
```

```yaml
# web2-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web2-service
  namespace: web-app
spec:
  selector:
    app: web2
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

Apply all:

```
kubectl apply -f web1-deployment.yaml
kubectl apply -f web1-configmap.yaml
kubectl apply -f web1-service.yaml
kubectl apply -f web2-deployment.yaml
kubectl apply -f web2-configmap.yaml
kubectl apply -f web2-service.yaml
```

Verify: `kubectl get pods,svc -n web-app`

### Step 4: Create an Ingress Resource

This Ingress routes traffic to `/web1` for `web1-service` and `/web2` for `web2-service`.

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: web-app
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /web1
        pathType: Prefix
        backend:
          service:
            name: web1-service
            port:
              number: 80
      - path: /web2
        pathType: Prefix
        backend:
          service:
            name: web2-service
            port:
              number: 80
```

Apply: `kubectl apply -f ingress.yaml`

### Step 5: Test the Ingress

Get the Ingress Controller’s external IP or hostname:

```
kubectl get svc -n ingress-nginx
```

For minikube, use `minikube tunnel` or `minikube service ingress-nginx-controller -n ingress-nginx --url`.

Test the routes:

```
curl http://<external-ip>/web1
curl http://<external-ip>/web2
```

Expected output:
- `/web1`: `<h1>Welcome to Web1</h1>`
- `/web2`: `<h1>Welcome to Web2</h1>`

If using a browser, navigate to `http://<external-ip>/web1` and `http://<external-ip>/web2`.

### Step 6: Add TLS (Optional)

To enable HTTPS, create a Secret with a TLS certificate and update the Ingress:

```yaml
# tls-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: web-tls
  namespace: web-app
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-cert>
  tls.key: <base64-encoded-key>
```

Update the Ingress:

```yaml
# ingress-tls.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: web-app
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - example.com
    secretName: web-tls
  rules:
  - host: example.com
    http:
      paths:
      - path: /web1
        pathType: Prefix
        backend:
          service:
            name: web1-service
            port:
              number: 80
      - path: /web2
        pathType: Prefix
        backend:
          service:
            name: web2-service
            port:
              number: 80
```

Apply and test with `https://example.com/web1`. (Note: For testing, you may need a self-signed certificate or a real one from Let’s Encrypt.)

### Cleanup

```
kubectl delete -f ingress.yaml
kubectl delete -f web1-deployment.yaml
kubectl delete -f web1-configmap.yaml
kubectl delete -f web1-service.yaml
kubectl delete -f web2-deployment.yaml
kubectl delete -f web2-configmap.yaml
kubectl delete -f web2-service.yaml
kubectl delete -f app-namespace.yaml
helm uninstall ingress-nginx -n ingress-nginx
kubectl delete namespace ingress-nginx
```

This hands-on demo shows how to use Ingress to route traffic to multiple services based on paths.

## Best Practices

- **Ingress**:
  - Use descriptive path and host rules to avoid conflicts.
  - Specify `pathType` (`Prefix`, `Exact`, or `ImplementationSpecific`) for clarity.
  - Test routing rules in a non-production environment.

- **Nginx Ingress Controller**:
  - Monitor controller logs (`kubectl logs -n ingress-nginx`) for troubleshooting.
  - Use annotations to customize behavior (e.g., rate limiting, session affinity).
  - Enable TLS for production environments.

- **General**:
  - Use a domain name with DNS for production Ingress setups.
  - Secure Ingress with RBAC and network policies.
  - Monitor Ingress performance with tools like Prometheus and Grafana.

## Conclusion

Ingress and Ingress Controllers like Nginx provide a flexible and powerful way to manage external traffic in Kubernetes. By defining routing rules, you can efficiently direct HTTP/HTTPS traffic to multiple services, making it ideal for microservices architectures.

Stay tuned for Day 62, where we’ll explore Horizontal Pod Autoscaling and cluster optimization! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 10, 2025.*