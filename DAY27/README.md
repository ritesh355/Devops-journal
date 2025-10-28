# Docker Networking: Connectivity Testing Lab 🐳

![Docker Logo](https://www.docker.com/wp-content/uploads/2022/03/horizontal-logo-monochromatic-white.png)
*Mastering container communication with Docker's default bridge network*

---

## 📖 Overview

This repository documents **Task 2: Test Connectivity** from **Day 24: Docker Networking**, part of a 100-day learning plan focused on **Containers & Automation**. The task explores Docker's default bridge network, testing inter-container communication and external access using Nginx containers. By following this lab, you'll verify connectivity using IP addresses, understand the limitations of DNS resolution, and expose a container to the host.


**Objective**: Demonstrate connectivity between containers (`web1`, `web2`, `web3`) on the default bridge network and external access via port mapping.

---

## 🚀 Prerequisites

Before starting, ensure you have:
- **Docker** installed and running (`docker --version` and `docker info`).
- A web browser to test external access.
- Basic terminal knowledge (e.g., `bash` commands).
- Containers `web1` and `web2` running on the default bridge network:
  ```bash
  docker run -d --name web1 nginx
  docker run -d --name web2 nginx
  ```

---

## 🛠️ Step-by-Step Process

Follow these steps to replicate the connectivity testing lab. All commands assume a single terminal unless specified. A second terminal may be needed for troubleshooting.

### 🛠 Step 1: Access `web1`’s Shell
**Command**:
```bash
docker exec -it web1 /bin/bash
```
- **What it does**: Opens an interactive Bash shell inside the `web1` container.
- **Terminal**: Use your main terminal.
- **Expected Outcome**: You’re inside `web1`’s shell (prompt: `root@<container_id>:/#`).

### 🛠 Step 2: Install `ping`
**Command** (inside `web1`’s shell):
```bash
apt-get update && apt-get install -y iputils-ping
```
- **What it does**: Updates the package list and installs the `ping` utility in the minimal Nginx image.
- **Terminal**: Inside `web1`’s shell.
- **Expected Outcome**: `ping` is installed, with output showing package downloads.

### 🛠 Step 3: Ping `web2` Using IP
**Command** (inside `web1`’s shell):
```bash
ping 172.17.0.3
```
- **What it does**: Pings `web2` (IP: `172.17.0.3`, from `docker network inspect bridge`) to test connectivity.
- **Why it works**: The default bridge network allows inter-container communication (`enable_icc: "true"`).
- **Terminal**: Inside `web1`’s shell.
- **Expected Outcome**:
  ```bash
  PING 172.17.0.3 (172.17.0.3): 56 data bytes
  64 bytes from 172.17.0.3: icmp_seq=1 ttl=64 time=0.123 ms
  ...
  ```
  Press `Ctrl+C` to stop.
- **Troubleshooting**:
  - Verify `web2` is running: Open a **new terminal** and run `docker ps`.
  - Confirm IP: Run `docker network inspect bridge` in a new terminal.

### 🛠 Step 4: Stay in the Shell
- **Action**: Remain in `web1`’s shell for the next step.
- **Terminal**: No change.

### 🛠 Step 5: Ping `web2` by Name (Expect Failure)
**Command** (inside `web1`’s shell):
```bash
ping web2
```
- **What it does**: Attempts to ping `web2` by its container name.
- **Why it fails**: The default bridge network doesn’t support DNS resolution by container name.
- **Terminal**: Inside `web1`’s shell.
- **Expected Outcome**:
  ```bash
  ping: web2: Name or service not known
  ```
- **Troubleshooting**: If a different error appears, verify `web2` is running (`docker ps` in a new terminal).

### 🛠 Step 6: Exit the Shell
**Command** (inside `web1`’s shell):
```bash
exit
```
- **What it does**: Returns to the host terminal.
- **Terminal**: Back to the host terminal.
- **Expected Outcome**: Host prompt (e.g., `user@machine:~$`).

### 🛠 Step 7: Run a New Container with Port Mapping
**Command** (in host terminal):
```bash
docker run -d --name web3 -p 8080:80 nginx
```
- **What it does**: Starts a new Nginx container (`web3`), mapping host port 8080 to container port 80.
- **Terminal**: Host terminal.
- **Expected Outcome**: Container starts. Verify with:
  ```bash
  docker ps
  ```
  Look for `web3` with `0.0.0.0:8080->80/tcp`.

### 🛠 Step 8: Access `web3` Externally
**Action**: Open `http://localhost:8080` in a web browser.
- **What it does**: Accesses Nginx’s default welcome page via the port mapping.
- **Terminal**: None (use browser).
- **Expected Outcome**: Displays “Welcome to nginx!” page.
- **Troubleshooting**:
  - Check `web3` is running (`docker ps`).
  - Ensure port 8080 is free (`netstat -tuln` on Linux or `netstat -a -n -o` on Windows).
  - Test with `curl http://localhost:8080` in the host terminal.

### 🛠 Step 9: Inspect the Bridge Network
**Command** (in host terminal):
```bash
docker network inspect bridge
```
- **What it does**: Shows the bridge network’s details, including `web3`’s IP (e.g., `172.17.0.4`).
- **Terminal**: Host terminal.
- **Expected Outcome**: `web3` is listed in the `Containers` section:
  ```json
  "Containers": {
      ...
      "<web3_id>": {
          "Name": "web3",
          "IPv4Address": "172.17.0.4/16",
          ...
      }
  }
  ```
- **Troubleshooting**: If `web3` is missing, ensure it’s running and not on another network.

### 🛠 Step 10: Test Connectivity from `web1` to `web3`
- **Sub-step: Access `web1`’s Shell**:
  - **Command** (in host terminal):
    ```bash
    docker exec -it web1 /bin/bash
    ```
  - **Terminal**: Host terminal to start, then inside `web1`’s shell.
  - **Expected Outcome**: Inside `web1`’s shell.

- **Sub-step: Install `curl`**:
  - **Command** (inside `web1`’s shell):
    ```bash
    apt-get update && apt-get install -y curl
    ```
  - **What it does**: Installs `curl` for HTTP testing.
  - **Expected Outcome**: `curl` is installed.

- **Sub-step: Test Connectivity**:
  - **Command** (inside `web1`’s shell):
    ```bash
    curl http://172.17.0.4
    ```
  - **What it does**: Sends an HTTP request to `web3`’s IP (from Step 9).
  - **Terminal**: Inside `web1`’s shell.
  - **Expected Outcome**: Returns Nginx’s HTML:
    ```html
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    ...
    ```
  - **Troubleshooting**:
    - Verify `web3`’s IP (`docker network inspect bridge` in a new terminal).
    - Ensure `web3` is running (`docker ps` in a new terminal).

### 🛠 Step 11: Exit the Shell
**Command** (inside `web1`’s shell):
```bash
exit
```
- **What it does**: Returns to the host terminal.
- **Terminal**: Back to host terminal.
- **Expected Outcome**: Host prompt.

---

## 🧹 Clean Up
To free resources, stop and remove containers:
```bash
docker stop web1 web2 web3
docker rm web1 web2 web3
```
- **Terminal**: Host terminal.
- **Why**: Prevents clutter and resource usage.

---

## 🔑 Key Takeaways
- **IP-Based Communication**: Containers on the default bridge network communicate via IP addresses (e.g., `172.17.0.3` for `web2`).
- **No DNS Resolution**: The default bridge network doesn’t support name-based communication (e.g., `ping web2` fails).
- **Port Mapping**: Exposes containers externally (e.g., `-p 8080:80` for `web3`).
- **Inter-Container Communication**: Enabled by `enable_icc: "true"`, allowing `curl http://172.17.0.4`.
- **Relevance**: Prepares you for user-defined networks (Day 24, Task 2) and Docker Compose (Day 28–30).

---

## 🛠 Troubleshooting
- **Ping Fails**: Verify containers are running (`docker ps`) and IPs are correct (`docker network inspect bridge`).
- **Browser Access Fails**: Check port 8080 is free and `web3` is running.
- **Curl Fails**: Ensure `curl` is installed and `web3`’s IP is correct.
- **New Terminal**: Use a second terminal for `docker ps` or `docker network inspect` while in `web1`’s shell.

---

## 📚 Resources
- [Docker Bridge Network Docs](https://docs.docker.com/network/bridge/)
- [Docker Exec Command](https://docs.docker.com/engine/reference/commandline/exec/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

## 🌟 Next Steps
- **Review**: Repeat the task to master `docker exec`, `ping`, and `curl`.
- **Explore**: Test a user-defined network (Day 24, Task 2) to compare with the default bridge.
- **Prepare**: Get ready for Day 25 (Dockerfiles) to build custom images.

---
