# Day 59: Running Batch and Scheduled Tasks with Jobs and CronJobs in Kubernetes

## Introduction

Welcome to Day 59 of my DevOps learning journey! Today, we’re exploring **Jobs** and **CronJobs** in Kubernetes, which are designed for running batch and scheduled tasks. Unlike Deployments or StatefulSets, which manage long-running applications, Jobs and CronJobs handle tasks that run to completion, such as data processing or backups.

In this post, we’ll dive into the mechanics of Jobs and CronJobs, their use cases, and conclude with a hands-on example of setting up a CronJob to perform periodic database backups. If you missed Day 58 on DaemonSets and StatefulSets, check it out [here](link-to-day-58-post). Let’s get started!

## Understanding Jobs

**Jobs** in Kubernetes are used to run tasks that execute once or a fixed number of times until completion. Once the task is done, the Pod terminates, and the Job is marked as complete.

- **Why Use Jobs?**
  - **One-Time Tasks**: Run tasks like database migrations, batch processing, or report generation.
  - **Reliability**: Ensure tasks complete successfully, with retries on failure.
  - **Parallelism**: Run multiple instances of a task concurrently for large workloads.

- **Key Features**:
  - **Completions**: Specify how many times a task must complete (e.g., `spec.completions: 5`).
  - **Parallelism**: Run multiple Pods simultaneously (e.g., `spec.parallelism: 3`).
  - **Restart Policy**: Use `Never` or `OnFailure` (not `Always`, which is for Deployments).
  - **Backoff Limit**: Number of retries before marking the Job as failed.

- **Example Job YAML**:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-process
spec:
  completions: 1
  parallelism: 1
  template:
    spec:
      containers:
      - name: processor
        image: busybox
        command: ["sh", "-c", "echo Processing data && sleep 5"]
      restartPolicy: Never
```

- **Use Cases**:
  - Running a data ETL (Extract, Transform, Load) pipeline.
  - Performing a one-time database schema migration.
  - Generating a report and uploading it to storage.

## Understanding CronJobs

**CronJobs** extend Jobs by scheduling them to run at specific times or intervals, using a cron-like syntax. They’re perfect for recurring tasks like backups or cleanup scripts.

- **Why Use CronJobs?**
  - **Scheduled Tasks**: Automate tasks like nightly backups or periodic data syncs.
  - **Consistency**: Ensure tasks run reliably on a schedule.
  - **History Tracking**: Track success/failure of past runs.

- **Key Features**:
  - **Schedule**: Defined using cron syntax (e.g., `0 2 * * *` for daily at 2 AM).
  - **Concurrency Policy**: Control how overlapping runs are handled (`Allow`, `Forbid`, `Replace`).
  - **History Limits**: Limit the number of completed/failed Jobs retained (`successfulJobsHistoryLimit`, `failedJobsHistoryLimit`).
  - **Suspend**: Pause CronJob execution without deleting it.

- **Example CronJob YAML**:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: daily-task
spec:
  schedule: "0 2 * * *"  # Run daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: task
            image: busybox
            command: ["sh", "-c", "echo Running task && sleep 5"]
          restartPolicy: OnFailure
```

- **Use Cases**:
  - Nightly database backups.
  - Periodic cleanup of temporary files.
  - Scheduled API calls to external systems.

## Hands-On: CronJob for Database Backup

Let’s create a CronJob to back up a MySQL database periodically. We’ll assume a MySQL database is running in the cluster (as deployed in Day 7) and use a CronJob to run `mysqldump` to create backups. The backups will be stored in a PersistentVolumeClaim (PVC) for persistence.

### Step 1: Set Up the Environment

We’ll reuse the `mysql-app` namespace and MySQL setup from Day 7. Ensure you have:
- A MySQL Deployment with a Service (`mysql-service`) in the `mysql-app` namespace.
- A Secret (`mysql-secret`) with the MySQL root password (`mysql-root-password: supersecret`).
- A PVC (`mysql-pvc`) for storage.

If you don’t have these, refer to Day 7’s setup or create them:

```yaml
# mysql-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mysql-app
```

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
  storageClassName: standard
```

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

Apply: `kubectl apply -f <file>.yaml` for each.

### Step 2: Create a PVC for Backups

We’ll create a separate PVC to store the backup files.

```yaml
# backup-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: backup-pvc
  namespace: mysql-app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
```

Apply: `kubectl apply -f backup-pvc.yaml`

### Step 3: Create a CronJob for MySQL Backup

The CronJob will run `mysqldump` daily at 2 AM to back up the MySQL database and store the output in the PVC.

```yaml
# mysql-backup-cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mysql-backup
  namespace: mysql-app
spec:
  schedule: "0 2 * * *"  # Run daily at 2 AM
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: mysql:8.0
            command: ["sh", "-c", "mysqldump -h mysql-service -u root -p${MYSQL_ROOT_PASSWORD} --all-databases > /backups/backup-$(date +%Y%m%d-%H%M%S).sql"]
            env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-root-password
            volumeMounts:
            - name: backup-storage
              mountPath: /backups
          restartPolicy: OnFailure
          volumes:
          - name: backup-storage
            persistentVolumeClaim:
              claimName: backup-pvc
```

Apply: `kubectl apply -f mysql-backup-cronjob.yaml`

### Step 4: Test the CronJob

Manually trigger the CronJob to test:

```
kubectl create job --from=cronjob/mysql-backup manual-backup -n mysql-app
```

Verify the backup file in the PVC:

```
kubectl get pods -n mysql-app
kubectl exec -it <backup-pod-name> -n mysql-app -- ls /backups
```

You should see a file like `backup-YYYYMMDD-HHMMSS.sql`.

To test scheduled execution, wait for the next scheduled run (or modify the schedule to `*/5 * * * *` for every 5 minutes during testing). Check the Job history:

```
kubectl get jobs -n mysql-app
```

### Step 5: Verify Backup Contents

Copy the backup file locally to inspect:

```
kubectl cp mysql-app/<backup-pod-name>:/backups/backup-<timestamp>.sql ./backup.sql
```

Open `backup.sql` to verify it contains the database dump.

### Cleanup

```
kubectl delete -f mysql-backup-cronjob.yaml
kubectl delete -f backup-pvc.yaml
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-service.yaml
kubectl delete -f mysql-pvc.yaml
kubectl delete -f mysql-secret.yaml
kubectl delete -f mysql-namespace.yaml
```

This hands-on demo shows how to use a CronJob to automate MySQL database backups with persistent storage.

## Best Practices

- **Jobs**:
  - Set appropriate `completions` and `parallelism` for your workload.
  - Use `restartPolicy: Never` for one-off tasks or `OnFailure` for retryable tasks.
  - Monitor Job status with `kubectl get jobs` to catch failures early.

- **CronJobs**:
  - Use a clear cron schedule and test it with tools like crontab.guru.
  - Set `concurrencyPolicy: Forbid` to prevent overlapping runs for critical tasks.
  - Limit history with `successfulJobsHistoryLimit` and `failedJobsHistoryLimit` to avoid clutter.

- **Backup Specific**:
  - Store backups in a reliable PVC or external storage (e.g., S3) for production.
  - Test restore procedures to ensure backups are usable.
  - Secure sensitive data (e.g., database credentials) with Secrets.

## Conclusion

Jobs and CronJobs are essential for running batch and scheduled tasks in Kubernetes. Whether it’s a one-time data processing task or a recurring database backup, these controllers provide the reliability and automation needed for DevOps workflows.

Stay tuned for Day 60, where we’ll explore Ingress and advanced networking! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

*Originally posted on Hashnode on October 9, 2025.*
