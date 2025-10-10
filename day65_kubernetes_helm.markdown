# Day 65: Helm - The Package Manager for Kubernetes

## Introduction

Welcome to Day 65 of my DevOps learning journey! Today, we’re exploring **Helm**, the package manager for Kubernetes, which simplifies deploying and managing applications. Helm uses **charts**—pre-configured templates—to define Kubernetes resources, making it easier to deploy complex applications like WordPress with MySQL.

In this post, we’ll cover Helm basics, how to install it, understand Helm charts, and walk through a hands-on example of deploying WordPress with MySQL using a Helm chart. If you missed Day 64 on Security Best Practices, check it out [here](link-to-day-64-post). Let’s dive in!

## Understanding Helm

**Helm** is a tool that streamlines the deployment and management of Kubernetes applications. It packages Kubernetes resources into reusable templates called **charts**, which can be versioned, shared, and customized.

- **Why Use Helm?**
  - **Simplified Deployments**: Deploy complex applications with a single command.
  - **Reusability**: Share and reuse charts across teams or projects.
  - **Versioning**: Manage application versions and rollbacks.
  - **Customization**: Configure deployments using values files or command-line overrides.

- **Key Components**:
  - **Helm CLI**: The command-line tool for interacting with Helm.
  - **Charts**: Packages containing Kubernetes manifests (e.g., Deployments, Services) and templates.
  - **Repositories**: Online storage for sharing charts (e.g., Artifact Hub).
  - **Releases**: Instances of a chart deployed to a cluster with specific configurations.

- **Chart Structure**:
  ```
  my-chart/
  ├── Chart.yaml       # Metadata about the chart
  ├── values.yaml      # Default configuration values
  ├── templates/       # Kubernetes manifest templates
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   └── ...
  └── charts/          # Dependency charts
  ```

- **Helm Workflow**:
  1. Install Helm CLI.
  2. Add a chart repository or create a custom chart.
  3. Customize chart values (e.g., via `values.yaml` or `--set`).
  4. Deploy the chart as a release using `helm install`.
  5. Manage releases with `helm upgrade`, `helm rollback`, or `helm uninstall`.

## Installing Helm

To use Helm, you need to install the Helm CLI on your local machine or CI/CD environment.

- **Installation (Linux/macOS)**:
  ```bash
  # Download Helm (replace with latest version)
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  ```

- **Verify Installation**:
  ```bash
  helm version
  ```
  Expected output: `version.BuildInfo{Version:"v3.15.4", ...}`

- **Add a Chart Repository**:
  Add the Bitnami repository for WordPress and MySQL charts:
  ```bash
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
  ```

## Understanding Helm Charts

- **Chart.yaml**: Contains metadata (name, version, description).
  ```yaml
  apiVersion: v2
  name: my-app
  version: 0.1.0
  ```

- **values.yaml**: Defines default configuration parameters (e.g., image tags, replicas).
  ```yaml
  image:
    repository: nginx
    tag: "1.27"
  replicas: 1
  ```

- **Templates**: YAML files with Go templating to generate Kubernetes manifests dynamically.
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: {{ .Release.Name }}-app
  spec:
    replicas: {{ .Values.replicas }}
    template:
      spec:
        containers:
        - name: app
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
  ```

- **Finding Charts**:
  Search for charts on Artifact Hub or a repository:
  ```bash
  helm search repo bitnami
  ```

## Hands-On: Deploy WordPress with MySQL Using Helm

Let’s deploy WordPress with a MySQL backend using the Bitnami WordPress Helm chart, which includes MySQL as a dependency. We’ll customize the deployment with a values file and test the setup.

### Step 1: Set Up the Environment

Ensure you have a Kubernetes cluster (e.g., minikube or a cloud provider) and Helm installed. Verify Helm:

```bash
helm version
```

Add the Bitnami repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Step 2: Create a Namespace

```yaml
# wordpress-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: wordpress
```

Apply: `kubectl apply -f wordpress-namespace.yaml`

### Step 3: Create a Custom Values File

Create a `custom-values.yaml` file to customize the WordPress chart, setting passwords, service types, and resource limits.

```yaml
# custom-values.yaml
wordpressUsername: admin
wordpressPassword: supersecret
wordpressEmail: user@example.com
wordpressFirstName: Admin
wordpressLastName: User
wordpressBlogName: My WordPress Blog

mariadb:
  auth:
    rootPassword: mysqlsecret
    database: wordpress
    username: wpuser
    password: wpsecret

service:
  type: ClusterIP
  port: 80

resources:
  requests:
    cpu: "100m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

### Step 4: Deploy WordPress with Helm

Install the WordPress chart with the custom values:

```bash
helm install my-wordpress bitnami/wordpress \
  --namespace wordpress \
  -f custom-values.yaml
```

Verify the release:

```bash
helm list -n wordpress
```

Expected output:

```
NAME         NAMESPACE  REVISION  UPDATED                  STATUS   CHART             APP VERSION
my-wordpress wordpress  1         2025-10-10 13:48:00  deployed wordpress-20.2.2  6.6.2
```

Check the Pods and Services:

```bash
kubectl get pods,svc -n wordpress
```

### Step 5: Access WordPress

Port-forward to access the WordPress Service:

```bash
kubectl port-forward svc/my-wordpress -n wordpress 8080:80
```

Open `http://localhost:8080` in a browser. Log in with:
- Username: `admin`
- Password: `supersecret`

You should see the WordPress dashboard.

To retrieve the admin password (if needed):

```bash
kubectl get secret my-wordpress -n wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d
```

### Step 6: Test MySQL Connectivity

The WordPress chart deploys a MySQL instance (MariaDB) as a dependency. Verify the MySQL Service:

```bash
kubectl get svc my-wordpress-mariadb -n wordpress
```

Test connectivity by exec’ing into the WordPress Pod:

```bash
kubectl exec -it <wordpress-pod-name> -n wordpress -- bash
mysql -h my-wordpress-mariadb -u wpuser -pwpsecret wordpress
```

Run a query:

```sql
SELECT * FROM wp_options LIMIT 1;
```

This confirms WordPress is connected to MySQL.

### Step 7: Upgrade or Rollback (Optional)

To update the deployment (e.g., change the WordPress blog name):

```yaml
# Update custom-values.yaml
wordpressBlogName: Updated WordPress Blog
```

Apply the update:

```bash
helm upgrade my-wordpress bitnami/wordpress \
  --namespace wordpress \
  -f custom-values.yaml
```

If something goes wrong, rollback:

```bash
helm rollback my-wordpress 1 -n wordpress
```

### Cleanup

Uninstall the Helm release:

```bash
helm uninstall my-wordpress -n wordpress
```

Delete the namespace:

```bash
kubectl delete -f wordpress-namespace.yaml
```

This hands-on demo shows how to use Helm to deploy a complex application like WordPress with MySQL.

## Best Practices

- **Helm**:
  - Store custom `values.yaml` files in version control for reproducibility.
  - Use meaningful release names and namespaces to organize deployments.
  - Regularly update Helm and charts to get security fixes and new features.

- **Charts**:
  - Use trusted chart repositories like Bitnami or Artifact Hub.
  - Review chart dependencies and values before deployment.
  - Test charts in a non-production environment first.

- **General**:
  - Combine Helm with security practices (e.g., Pod Security Contexts, Network Policies).
  - Use Helm secrets plugins (e.g., `helm-secrets`) for sensitive data.
  - Monitor releases with `helm status` and Kubernetes logs.

## Conclusion

Helm simplifies the deployment and management of Kubernetes applications with reusable charts. By using Helm to deploy WordPress and MySQL, you can streamline complex setups and customize them easily with values files.

Stay tuned for Day 66, where we’ll explore Horizontal Pod Autoscaling and cluster optimization! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 10, 2025.*