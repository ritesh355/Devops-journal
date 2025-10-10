# Day 64: Security Best Practices in Kubernetes

## Introduction

Welcome to Day 64 of my DevOps learning journey! Today, we’re focusing on **Security Best Practices** in Kubernetes, covering **Pod Security Contexts**, **Security Policies** (transitioning from Pod Security Policies to PodSecurity standards), and **Image Scanning** with Trivy. Securing a Kubernetes cluster is critical to protect applications and data from threats, and these practices help enforce secure configurations and mitigate vulnerabilities.

In this post, we’ll explore these security mechanisms and provide a hands-on example of applying a Pod Security Context, enforcing a PodSecurity standard, and scanning container images with Trivy. If you missed Day 63 on Network Policies, check it out [here](link-to-day-63-post). Let’s dive in!

## Understanding Pod Security Contexts

**Pod Security Contexts** define security settings for Pods and their containers, controlling privileges, user IDs, and other security-related configurations.

- **Why Use Pod Security Contexts?**
  - **Minimize Privileges**: Run containers with least privilege to reduce attack surface.
  - **Control Access**: Specify user IDs, group IDs, and filesystem permissions.
  - **Enhance Isolation**: Restrict capabilities and enforce read-only filesystems.

- **Key Configurations**:
  - **runAsUser/runAsGroup**: Specifies the user ID (UID) and group ID (GID) for the container process.
  - **runAsNonRoot**: Ensures the container does not run as the root user.
  - **privileged**: Grants elevated privileges (avoid unless necessary).
  - **capabilities**: Adds or removes Linux capabilities (e.g., `NET_ADMIN`).
  - **readOnlyRootFilesystem**: Makes the container’s filesystem read-only.
  - **fsGroup**: Sets the GID for volume ownership.

- **Example Pod Security Context**:
  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: secure-pod
  spec:
    securityContext:
      runAsUser: 1000
      runAsGroup: 1000
      runAsNonRoot: true
      fsGroup: 1000
    containers:
    - name: app
      image: nginx:latest
      securityContext:
        readOnlyRootFilesystem: true
        allowPrivilegeEscalation: false
        capabilities:
          drop:
          - ALL
  ```

- **Use Cases**:
  - Running containers as non-root users.
  - Restricting filesystem writes for stateless applications.
  - Limiting Linux capabilities to prevent unauthorized actions.

## Understanding Security Policies (PSPs → PodSecurity)

**Pod Security Policies (PSPs)** were the original Kubernetes mechanism for enforcing security constraints at the cluster level, but they have been deprecated in favor of **PodSecurity standards** (introduced in Kubernetes 1.21, stabilized in 1.25). PodSecurity is a simpler, built-in admission controller that enforces predefined security profiles.

- **Pod Security Policies (Deprecated)**:
  - PSPs allowed fine-grained control over Pod security settings (e.g., restricting privileged containers, enforcing non-root users).
  - Required complex RBAC configurations, making them hard to manage.
  - Deprecated in Kubernetes 1.21, removed in 1.25.

- **PodSecurity Standards**:
  - Replaces PSPs with three predefined profiles:
    - **Privileged**: No restrictions; allows full access (least secure).
    - **Baseline**: Prevents known privilege escalations (e.g., blocks privileged containers, host namespaces).
    - **Restricted**: Enforces strict security (e.g., non-root users, read-only filesystems, no capabilities).
  - Applied at the namespace level using labels.
  - Example namespace label:
    ```yaml
    apiVersion: v1
    kind: Namespace
    metadata:
      name: secure-app
      labels:
        pod-security.kubernetes.io/enforce: restricted
        pod-security.kubernetes.io/enforce-version: latest
    ```

- **Why Transition to PodSecurity?**
  - Simpler to configure than PSPs.
  - Built into Kubernetes, no external controller needed.
  - Aligns with modern security best practices.

- **Use Cases**:
  - Enforcing non-root containers across a namespace.
  - Preventing privilege escalation in production workloads.
  - Standardizing security configurations across clusters.

## Image Scanning with Trivy

**Trivy** is an open-source vulnerability scanner for container images, detecting known vulnerabilities in OS packages and application dependencies.

- **Why Use Trivy?**
  - **Vulnerability Detection**: Identifies CVEs (Common Vulnerabilities and Exposures) in container images.
  - **Ease of Use**: Simple CLI tool, integrates with CI/CD pipelines.
  - **Comprehensive**: Scans OS packages (e.g., Alpine, Ubuntu) and language dependencies (e.g., Python, Node.js).

- **Installation**:
  ```bash
  # Install Trivy (example for Linux)
  wget https://github.com/aquasecurity/trivy/releases/download/v0.53.0/trivy_0.53.0_Linux-64bit.tar.gz
  tar -zxvf trivy_0.53.0_Linux-64bit.tar.gz
  sudo mv trivy /usr/local/bin/
  ```

- **Basic Usage**:
  Scan a container image:
  ```bash
  trivy image nginx:latest
  ```
  Output lists vulnerabilities with severity (e.g., CRITICAL, HIGH), CVE IDs, and remediation steps.

- **Integration**:
  - Use in CI/CD pipelines (e.g., GitHub Actions, Jenkins) to fail builds with critical vulnerabilities.
  - Combine with Kubernetes admission controllers to block vulnerable images.

## Hands-On: Applying Security Contexts, PodSecurity, and Image Scanning

Let’s deploy an Nginx application with a Pod Security Context, enforce a PodSecurity `restricted` profile, and scan the image with Trivy. We’ll use a namespace and verify security enforcement.

### Step 1: Scan the Nginx Image with Trivy

Run Trivy to scan the `nginx:latest` image:

```bash
trivy image nginx:latest
```

Review the output for vulnerabilities. For example:

```
nginx:latest (debian 12.7)
=========================
Total: 10 (CRITICAL: 2, HIGH: 5, MEDIUM: 3, LOW: 0, UNKNOWN: 0)

+-------------------+------------------+----------+-------------------+-------------------+
|      LIBRARY      | VULNERABILITY ID | SEVERITY | INSTALLED VERSION |   FIXED VERSION   |
+-------------------+------------------+----------+-------------------+-------------------+
| libcurl4          | CVE-2023-38545   | CRITICAL | 7.88.1-10         | 8.2.1-1           |
| curl              | CVE-2023-38545   | CRITICAL | 7.88.1-10         | 8.2.1-1           |
+-------------------+------------------+----------+-------------------+-------------------+
```

If critical vulnerabilities are found, consider using a fixed version (e.g., `nginx:1.27`) or a minimal image like `nginx:alpine`.

### Step 2: Create a Namespace with PodSecurity

Create a namespace with the `restricted` PodSecurity profile.

```yaml
# secure-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: secure-app
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
```

Apply: `kubectl apply -f secure-namespace.yaml`

### Step 3: Deploy Nginx with Security Context

Create a Deployment with a Pod Security Context to run Nginx as a non-root user, with a read-only filesystem and dropped capabilities.

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-nginx
  namespace: secure-app
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
      securityContext:
        runAsUser: 1000
        runAsGroup: 1000
        runAsNonRoot: true
        fsGroup: 1000
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
        securityContext:
          readOnlyRootFilesystem: true
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
            add:
            - NET_BIND_SERVICE
        volumeMounts:
        - name: tmp
          mountPath: /tmp
      volumes:
      - name: tmp
        emptyDir: {}
```

Note: We add `NET_BIND_SERVICE` to allow Nginx to bind to port 80 and mount an `emptyDir` volume for `/tmp` since the root filesystem is read-only.

Apply: `kubectl apply -f nginx-deployment.yaml`

### Step 4: Create a Service

```yaml
# nginx-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: secure-app
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

### Step 5: Test the Deployment

Verify the Pod is running:

```
kubectl get pods -n secure-app
```

Port-forward to access Nginx:

```
kubectl port-forward svc/nginx-service -n secure-app 8080:80
```

Open `localhost:8080` in a browser to see the Nginx welcome page.

### Step 6: Test PodSecurity Enforcement

Try deploying a non-compliant Pod (e.g., running as root) to test the `restricted` profile:

```yaml
# non-compliant-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: non-compliant
  namespace: secure-app
spec:
  containers:
  - name: nginx
    image: nginx:1.27
    securityContext:
      runAsUser: 0  # Root user
```

Apply: `kubectl apply -f non-compliant-pod.yaml`

Expected error (from PodSecurity admission controller):

```
Error: container <nginx> is not compliant with the restricted PodSecurity profile: must set securityContext.runAsNonRoot=true or securityContext.runAsUser>0
```

This confirms the `restricted` profile is enforced.

### Step 7: Verify Security Context

Check the Pod’s security settings:

```
kubectl describe pod -n secure-app
```

Look for `Security Context` details, confirming `runAsUser: 1000`, `runAsNonRoot: true`, and `readOnlyRootFilesystem: true`.

### Cleanup

```
kubectl delete -f nginx-deployment.yaml
kubectl delete -f nginx-service.yaml
kubectl delete -f secure-namespace.yaml
```

This hands-on demo shows how to apply a Pod Security Context, enforce a PodSecurity standard, and scan images with Trivy.

## Best Practices

- **Pod Security Contexts**:
  - Always run containers as non-root users unless absolutely necessary.
  - Use `readOnlyRootFilesystem: true` for stateless applications, with writable volumes for temporary data.
  - Drop all capabilities and only add specific ones (e.g., `NET_BIND_SERVICE`).

- **PodSecurity Standards**:
  - Apply the `restricted` profile to production namespaces for maximum security.
  - Use `baseline` for less strict environments to balance security and compatibility.
  - Audit namespaces with `pod-security.kubernetes.io/audit: restricted` to identify violations without blocking.

- **Image Scanning with Trivy**:
  - Scan images in CI/CD pipelines before deployment.
  - Fail builds for critical or high-severity vulnerabilities.
  - Use minimal base images (e.g., `alpine`) to reduce attack surface.

- **General**:
  - Combine with Network Policies and RBAC for comprehensive security.
  - Regularly update images to patch vulnerabilities.
  - Monitor cluster security with tools like Falco or Kubernetes audit logs.

## Conclusion

Pod Security Contexts, PodSecurity standards, and image scanning with Trivy are essential for securing Kubernetes workloads. By enforcing least-privilege principles, restricting Pod configurations, and scanning for vulnerabilities, you can significantly reduce your cluster’s attack surface.

Stay tuned for Day 65, where we’ll explore Pod Disruption Budgets and cluster maintenance! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 10, 2025.*