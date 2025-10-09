# Kubernetes Namespaces, Labels, and Selectors

## Introduction

Welcome to Day 5 of my Kubernetes learning journey! Today, we're diving into **Namespaces**, **Labels**, and **Selectors**—three fundamental concepts that help organize and manage workloads in a Kubernetes cluster. These tools are essential for isolating applications, grouping resources, and enabling precise targeting of objects like Pods and Services.

If you missed Day 4, where we explored Services and Networking, check it out [here](link-to-day-4-post). Let’s break down today’s topics and get hands-on with practical examples for your Kubernetes toolkit!

## Understanding Namespaces

**Namespaces** in Kubernetes are a way to partition a single cluster into multiple virtual clusters. They provide isolation for resources like Pods, Services, and Deployments, making it easier to manage multi-tenant environments or separate different projects.

- **Why Use Namespaces?**
  - **Isolation**: Separate teams, projects, or environments (e.g., dev, staging, prod) within one cluster.
  - **Resource Management**: Apply resource quotas and limits per namespace to control usage.
  - **Name Scoping**: Resources like Pods can have the same name in different namespaces without conflicts.
  - **Access Control**: Use RBAC (Role-Based Access Control) to restrict access to specific namespaces.

- **Default Namespaces**:
  - `default`: Where resources go if no namespace is specified.
  - `kube-system`: For Kubernetes system components (e.g., kube-proxy, DNS).
  - `kube-public`: For resources accessible to all users.
  - `kube-node-lease`: For node lease objects.

- **Creating a Namespace**:

```yaml
# my-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-app
```

Apply it:

```
kubectl apply -f my-namespace.yaml
```

Verify: `kubectl get namespaces`

- **Using Namespaces**:
  - Specify the namespace when creating resources: `kubectl apply -f my-pod.yaml -n my-app`
  - View resources in a namespace: `kubectl get pods -n my-app`
  - Switch context to a namespace: `kubectl config set-context --current --namespace=my-app`

**Use Case**: A company running multiple apps (e.g., a web app and a backend API) can use namespaces like `web-app` and `api` to isolate their resources, apply different quotas, and manage access.

## Labels: Grouping Workloads

**Labels** are key-value pairs attached to Kubernetes objects (e.g., Pods, Services, Deployments) to identify and organize them. They’re incredibly flexible and used for grouping, filtering, and managing resources.

- **Why Use Labels?**
  - **Organization**: Group resources by app, environment, version, or team (e.g., `app: nginx`, `env: prod`).
  - **Selection**: Used by Selectors to target specific resources for Services, Deployments, or other operations.
  - **Flexibility**: Labels can be added or modified at any time without changing the resource’s core configuration.

- **Example Label Syntax**:
  ```yaml
  metadata:
    labels:
      app: nginx
      env: dev
      version: v1
  ```

- **Adding Labels**:
  - At creation: Include in the YAML file.
  - After creation: `kubectl label pod my-pod app=nginx`

- **Viewing Labels**:
  ```
  kubectl get pods --show-labels
  ```

**Use Case**: Label Pods with `app: frontend` and `app: backend` to distinguish between different components of your application.

## Selectors: Targeting Resources

**Selectors** use labels to identify a set of objects. They’re the glue that connects Services, Deployments, and other controllers to the right Pods.

- **Types of Selectors**:
  - **Equality-Based Selectors**: Match exact label values (e.g., `app=nginx`, `env=prod`).
  - **Set-Based Selectors**: Use conditions like `in`, `notin`, or `exists` (e.g., `env in (prod, staging)`).

- **Example in a Service**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

This Service targets all Pods with the label `app: nginx`.

- **Set-Based Selector Example** (in a Deployment):

```yaml
selector:
  matchExpressions:
    - { key: env, operator: In, values: [prod, staging] }
    - { key: app, operator: Exists }
```

This selects Pods where the `env` label is either `prod` or `staging` and the `app` label exists.

- **Viewing Selected Resources**:
  ```
  kubectl get pods -l app=nginx
  ```

**Use Case**: A Service uses a selector to load-balance traffic across all Pods labeled `app: nginx` and `tier: frontend`.

## Hands-On: Isolating and Grouping an Nginx App

Let’s apply these concepts by creating a namespace, deploying an Nginx app with labels, and using selectors to expose it via a Service.

### Step 1: Create a Namespace

```yaml
# nginx-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-app
```

Apply: `kubectl apply -f nginx-namespace.yaml`

### Step 2: Deploy Nginx with Labels

Create a Deployment with labeled Pods:

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: nginx-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
      env: dev
  template:
    metadata:
      labels:
        app: nginx
        env: dev
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

Apply: `kubectl apply -f nginx-deployment.yaml`

Verify Pods in the namespace:

```
kubectl get pods -n nginx-app --show-labels
```

### Step 3: Expose with a Service Using Selectors

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
    env: dev
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

Apply: `kubectl apply -f nginx-service.yaml`

Test the Service:

```
kubectl port-forward svc/nginx-service -n nginx-app 8080:80
```

Then, `curl localhost:8080` in another terminal to see Nginx’s welcome page.

### Step 4: Experiment with Labels

Add a new label to one Pod:

```
kubectl label pod <pod-name> -n nginx-app tier=frontend
```

Check which Pods the Service still targets (only those with `app: nginx` and `env: dev`):

```
kubectl get pods -n nginx-app -l app=nginx,env=dev
```

### Cleanup

```
kubectl delete -f nginx-deployment.yaml
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-namespace.yaml
```

This hands-on demo shows how namespaces isolate workloads and how labels/selectors enable precise targeting.

## Best Practices

- **Namespaces**:
  - Use meaningful names (e.g., `prod`, `staging`, `team-alpha`).
  - Apply resource quotas to prevent overuse: `kubectl create quota my-quota -n my-app --hard=cpu=2,memory=2Gi`.
  - Avoid overusing namespaces; they’re not meant for fine-grained separation (use labels for that).

- **Labels**:
  - Follow a consistent naming convention (e.g., `app`, `env`, `tier`, `version`).
  - Use labels to encode metadata like release versions or team ownership.
  - Avoid excessive labels to keep things manageable.

- **Selectors**:
  - Use equality-based selectors for simple cases and set-based for complex filtering.
  - Ensure selectors match the intended Pods to avoid misrouting traffic.

## Conclusion

Namespaces, Labels, and Selectors are powerful tools for organizing and managing Kubernetes workloads. Namespaces provide isolation, while labels and selectors enable flexible grouping and targeting. Together, they make your cluster more manageable and scalable.

Stay tuned for Day 6, where we’ll explore ConfigMaps and Secrets for managing application configuration! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 9, 2025.*
