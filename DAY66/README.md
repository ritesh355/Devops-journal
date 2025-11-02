# Day 66: Logging and Monitoring with Prometheus and Grafana in Kubernetes

## Introduction

Welcome to Day 66 of my DevOps learning journey! Today, we’re diving into **Logging and Monitoring** in Kubernetes using **Prometheus** and **Grafana**. These tools are essential for observing cluster health, tracking resource usage, and identifying performance issues. Prometheus collects and stores metrics, while Grafana visualizes them in customizable dashboards.

In this post, we’ll cover the basics of Prometheus and Grafana, their integration with Kubernetes, and a hands-on example of monitoring CPU and memory usage of Pods. If you missed Day 65 on Helm, check it out [here](link-to-day-65-post). Let’s get started!

## Understanding Prometheus

**Prometheus** is an open-source monitoring and alerting toolkit designed for reliability and scalability, especially in dynamic environments like Kubernetes.

- **Why Use Prometheus?**
  - **Time-Series Data**: Collects metrics as time-series data, ideal for tracking resource usage over time.
  - **Powerful Querying**: Uses PromQL to query metrics and create alerts.
  - **Kubernetes Integration**: Automatically discovers Kubernetes resources (e.g., Pods, Services) for monitoring.
  - **Alerting**: Integrates with Alertmanager for notifications (e.g., via Slack, email).

- **Key Components**:
  - **Prometheus Server**: Scrapes and stores metrics.
  - **Service Discovery**: Discovers targets (e.g., Pods) in Kubernetes.
  - **Exporters**: Collect metrics from applications or systems (e.g., Node Exporter for host metrics).
  - **PromQL**: Query language for analyzing metrics.
  - **Alertmanager**: Handles alerts based on defined rules.

- **How It Works**:
  1. Prometheus scrapes metrics from endpoints (e.g., `/metrics`) exposed by applications or exporters.
  2. Metrics are stored in a time-series database.
  3. PromQL queries retrieve and analyze metrics.
  4. Grafana or other tools visualize the data.

## Understanding Grafana

**Grafana** is an open-source platform for visualizing and analyzing data, often used with Prometheus to create dashboards for Kubernetes metrics.

- **Why Use Grafana?**
  - **Customizable Dashboards**: Create visualizations for CPU, memory, network, and more.
  - **Multi-Source Support**: Integrates with Prometheus, Loki, and other data sources.
  - **Alerting**: Supports alerts based on visualized metrics.
  - **User-Friendly**: Intuitive UI for exploring metrics.

- **Key Features**:
  - **Dashboards**: Pre-built or custom dashboards for Kubernetes metrics.
  - **Data Sources**: Connects to Prometheus, MySQL, Loki, etc.
  - **Plugins**: Extend functionality with additional visualizations or integrations.

## Hands-On: Monitor CPU and Memory of Pods

Let’s deploy Prometheus and Grafana in a Kubernetes cluster using the **kube-prometheus-stack** Helm chart, then set up a dashboard to monitor CPU and memory usage of Pods. We’ll deploy a sample Nginx application to generate metrics.

### Step 1: Set Up the Environment

Ensure you have a Kubernetes cluster (e.g., minikube or a cloud provider) and Helm installed. Verify Helm:

```bash
helm version
```

Add the Prometheus Community Helm repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### Step 2: Create a Namespace

```yaml
# monitoring-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
```

Apply: `kubectl apply -f monitoring-namespace.yaml`

### Step 3: Deploy Prometheus and Grafana

Install the `kube-prometheus-stack` Helm chart, which includes Prometheus, Grafana, and Node Exporter for collecting metrics.

```bash
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set grafana.adminPassword=adminsecret
```

- The `serviceMonitorSelectorNilUsesHelmValues=false` flag ensures Prometheus scrapes all ServiceMonitors in the namespace.
- The `grafana.adminPassword` sets the Grafana admin password to `adminsecret`.

Verify the deployment:

```bash
kubectl get pods -n monitoring
```

Expected output includes Pods for Prometheus, Grafana, and Node Exporter.

### Step 4: Deploy a Sample Nginx Application

Deploy an Nginx application to generate CPU and memory metrics.

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: monitoring
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
        image: nginx:1.27
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "200m"
            memory: "256Mi"
```

```yaml
# nginx-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: monitoring
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

Apply:

```bash
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
```

### Step 5: Create a ServiceMonitor for Nginx

Create a **ServiceMonitor** to tell Prometheus to scrape metrics from the Nginx Pods. Kubernetes provides cAdvisor metrics (via the kubelet) for CPU and memory, which Prometheus can collect.

```yaml
# nginx-servicemonitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: nginx-monitor
  namespace: monitoring
  labels:
    release: prometheus-stack
spec:
  selector:
    matchLabels:
      app: nginx
  endpoints:
  - port: web
    path: /metrics
  namespaceSelector:
    matchNames:
    - monitoring
```

Apply: `kubectl apply -f nginx-servicemonitor.yaml`

Note: The Nginx image doesn’t expose a `/metrics` endpoint by default, but Kubernetes cAdvisor provides container metrics (CPU/memory) that Prometheus collects via the kubelet.

### Step 6: Access Grafana

Port-forward to access the Grafana dashboard:

```bash
kubectl port-forward svc/prometheus-stack-grafana -n monitoring 8080:80
```

Open `http://localhost:8080` in a browser. Log in with:
- Username: `admin`
- Password: `adminsecret`

### Step 7: Create a Grafana Dashboard

1. In Grafana, click **Dashboards > New Dashboard**.
2. Add a new panel and configure the data source as **Prometheus** (auto-configured by the Helm chart).
3. Add the following PromQL queries to monitor CPU and memory:

   - **Pod CPU Usage**:
     ```
     sum(rate(container_cpu_usage_seconds_total{namespace="monitoring", pod=~"nginx-app.*"}[5m])) by (pod)
     ```
     This shows CPU usage per Nginx Pod over a 5-minute window.

   - **Pod Memory Usage**:
     ```
     sum(container_memory_working_set_bytes{namespace="monitoring", pod=~"nginx-app.*"}) by (pod)
     ```
     This shows memory usage per Nginx Pod.

4. Configure the panel:
   - Set **Panel Title** (e.g., “Nginx Pod CPU Usage”).
   - Choose visualization (e.g., Graph or Time Series).
   - Set units (e.g., CPU cores for CPU, bytes for memory).

5. Save the dashboard (e.g., name it “Nginx Resource Monitoring”).

### Step 8: Test the Dashboard

Generate load on the Nginx Pods to observe metrics:

```bash
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -n monitoring -- sh -c "while true; do wget -q -O- http://nginx-service.monitoring.svc.cluster.local; done"
```

Refresh the Grafana dashboard to see CPU and memory usage spikes for the `nginx-app` Pods.

### Step 9: Explore Prometheus

Port-forward to access the Prometheus UI:

```bash
kubectl port-forward svc/prometheus-stack-kube-prom-prometheus -n monitoring 9090:9090
```

Open `http://localhost:9090` and run the same PromQL queries to verify raw metrics.

### Cleanup

Uninstall the Helm release:

```bash
helm uninstall prometheus-stack -n monitoring
```

Delete the Nginx application and namespace:

```bash
kubectl delete -f nginx-servicemonitor.yaml
kubectl delete -f nginx-deployment.yaml
kubectl delete -f nginx-service.yaml
kubectl delete -f monitoring-namespace.yaml
```

This hands-on demo shows how to use Prometheus and Grafana to monitor CPU and memory usage of Pods in Kubernetes.

## Best Practices

- **Prometheus**:
  - Use ServiceMonitors to automate metric collection for new applications.
  - Configure alerting rules in Prometheus for critical thresholds (e.g., high CPU usage).
  - Set appropriate scrape intervals (e.g., 15s) to balance granularity and performance.

- **Grafana**:
  - Use pre-built dashboards (e.g., Kubernetes Cluster Monitoring) from Grafana Labs.
  - Organize dashboards by namespace or application for clarity.
  - Secure Grafana with strong passwords and RBAC in production.

- **General**:
  - Combine with logging tools like Loki for a complete observability stack.
  - Store Prometheus data on persistent volumes for production use.
  - Regularly back up Grafana dashboards and configurations.

## Conclusion

Prometheus and Grafana provide a robust solution for monitoring Kubernetes clusters, enabling you to track Pod CPU and memory usage with ease. By setting up dashboards, you can gain insights into resource utilization and detect issues proactively.

Stay tuned for Day 67, where we’ll explore advanced logging with Loki and Fluentd! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 10, 2025.*
