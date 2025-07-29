# 🐳 Docker Images: The Building Blocks of Containers

![Docker Logo](https://www.docker.com/wp-content/uploads/2022/03/horizontal-logo-monochromatic-white.png)
*Master Docker images with hands-on practice and networking integration!*

---

## 📖 Getting Started

This repository kicks off your journey into **Docker Images**, a cornerstone of containerization, as part of **Day 24: Docker Networking** in the **Phase 2: Containers & Automation** learning plan. Below are the essential commands, practice tasks, and resources to get you started with Docker images, followed by a deeper dive into their structure and advanced practice.

### 🔑 Key Commands
- 🖼 `docker pull <image>`: Downloads an image from Docker Hub (e.g., `nginx:latest`).
- 📋 `docker images`: Lists all images on your Docker host.
- 🚀 `docker run <image>`: Creates and starts a container from an image.
- 🏃 `docker ps`: Lists running containers.
- 📜 `docker ps -a`: Lists all containers (running or stopped).

### 🧪 Practice: Getting Started
1. **Install Docker**:
   - Verify installation:
     ```bash
     docker --version
     docker info
     ```
   - **Outcome**: Confirms Docker is installed and running (e.g., `Docker version 24.0.5`, no errors in `docker info`).

2. **Pull and Run an Image**:
   - Pull the Nginx image:
     ```bash
     docker pull nginx
     ```
   - Run an Nginx container:
     ```bash
     docker run -d -p 8080:80 nginx
     ```
     - **Why**: Starts a container in detached mode (`-d`) with port 8080 (host) mapped to 80 (container).
     - **Outcome**: Open `http://localhost:8080` in a browser to see the Nginx welcome page.
   - **Terminal**: Host terminal.

3. **Explore Commands**:
   - List images:
     ```bash
     docker images
     ```
     - **Outcome**: Shows `nginx:latest` with its `IMAGE ID` and `SIZE`.
   - List running containers:
     ```bash
     docker ps
     ```
     - **Outcome**: Shows the Nginx container with a `CONTAINER ID`.
   - Stop the container:
     ```bash
     docker stop <container_id>
     ```
     - Replace `<container_id>` with the ID from `docker ps`.
   - Remove the container:
     ```bash
     docker rm <container_id>
     ```
   - **Terminal**: Host terminal.

### 📚 Resources
- 🐳 [Docker Get Started](https://docs.docker.com/get-started/): Beginner-friendly guide to Docker basics.
- 🖼 [Docker Image Reference](https://docs.docker.com/engine/reference/commandline/image/): Commands for managing images.
- 📜 [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/): Syntax for building images.
- 🌐 [Docker Hub](https://hub.docker.com): Public registry for sharing images.
- 📝 [Building Docker Images](https://www.digitalocean.com/community/tutorials/how-to-build-docker-images-and-host-a-docker-image-repository-with-docker-hub): Step-by-step image creation.
- 🎥 [Docker Images Explained](https://www.youtube.com/watch?v=5q6Us1T9QRY): Visual guide to image layers.

---

## 🚀 Overview

This repository dives deep into **Docker Images**, building on **Day 24: Docker Networking** in your 40-day **Containers & Automation** journey. Docker images are the blueprints for containers, and this lab explores their structure, creation, and usage, with practical tasks to solidify your skills. You'll work with the `nginx` image, build a custom image, and share it on Docker Hub, integrating networking concepts from Day 24.

**Date & Time**: July 29, 2025, 03:43 PM IST  
**Objective**: Master Docker image fundamentals, build and run custom images, and prepare for Day 25 (Dockerfiles).

---

## 📖 What Are Docker Images?

Docker images are **lightweight, portable, and immutable templates** that package everything needed to run an application:

- 🎨 **Application Code**: Your app (e.g., a Python Flask app).
- 🛠 **Dependencies**: Libraries and runtimes (e.g., `pip install flask`).
- 💾 **OS Base**: A minimal OS layer (e.g., `alpine` or `ubuntu:20.04`).
- ⚙️ **Configuration**: Environment variables, config files, or default commands.

### Key Characteristics
- 🔒 **Immutable**: Images are read-only; changes create new images.
- 🥞 **Layered**: Built from cached layers for efficiency (e.g., base OS, app code, dependencies).
- 🌍 **Portable**: Run anywhere Docker is installed, via registries like Docker Hub.
- 🏷 **Tagged**: Named with tags (e.g., `nginx:latest`) for versioning.

### How They Work
- 📜 **Built with Dockerfiles**: Define steps to create an image (e.g., `FROM`, `COPY`, `RUN`).
- 🗄 **Stored Locally or in Registries**: Use `docker pull` to download or `docker push` to share.
- 🏃 **Run as Containers**: `docker run` creates a container with a writable layer on top of the image.
- 🔗 **Networking Connection**: Images define services (e.g., Nginx on port 80), which interact with Docker’s networks (e.g., Day 24’s port mapping).

---

## 🛠 Prerequisites

Ensure you have:
- 🐳 **Docker** installed and running (`docker --version`, `docker info`).
- 🌐 A web browser for testing web servers.
- ✍️ A text editor (e.g., VS Code) for creating files.
- 📡 Optional: A Docker Hub account for Task 4.
- 🖥 One terminal (Linux/Mac/WSL2 or Windows PowerShell). Open a second terminal for troubleshooting if needed.

---

## 🧪 Advanced Practice Tasks

These hands-on tasks build on Day 24’s Nginx containers and networking, helping you master Docker images beyond the basics.

### 🧪 Task 1: Explore Docker Images
**Goal**: Inspect the `nginx` image used in Day 24.

1. **Clean Up Existing Containers**:
   ```bash
   docker stop web1 web2 web3
   docker rm web1 web2 web3
   ```
   - **Why**: Clears containers from Day 24 for a fresh start.
   - **Outcome**: No containers listed (`docker ps -a`).
   - **Terminal**: Host terminal.

2. **List Images**:
   ```bash
   docker images
   ```
   - **Why**: Shows all images, including `nginx`.
   - **Outcome**: Displays `nginx:latest` with its `IMAGE ID` and `SIZE` (~140MB).
   - **Troubleshooting**: If missing, run `docker pull nginx:latest`.

3. **Inspect the Nginx Image**:
   ```bash
   docker image inspect nginx:latest
   ```
   - **Why**: Reveals metadata (layers, ports, commands).
   - **Outcome**: JSON output with `ExposedPorts` (`80/tcp`) and `Cmd` (`["nginx", "-g", "daemon off;"]`).
   - **Terminal**: Host terminal.

4. **View Image Layers**:
   ```bash
   docker history nginx:latest
   ```
   - **Why**: Shows the image’s layers (e.g., base OS, Nginx installation).
   - **Outcome**: Lists layers with commands and sizes.
   - **Terminal**: Host terminal.

### 🧪 Task 2: Run and Test Containers
**Goal**: Run containers from `nginx` and test connectivity (like Day 24).

1. **Run Containers**:
   ```bash
   docker run -d --name web1 nginx
   docker run -d --name web2 nginx
   ```
   - **Why**: Creates `web1` and `web2` on the default bridge network.
   - **Outcome**: Containers running (`docker ps`).
   - **Terminal**: Host terminal.

2. **Check Network IPs**:
   ```bash
   docker network inspect bridge
   ```
   - **Why**: Confirms IPs (e.g., `172.17.0.2`, `172.17.0.3`).
   - **Outcome**: JSON shows `web1` and `web2` under `Containers`.
   - **Terminal**: Host terminal.

3. **Test Connectivity**:
   - **Access `web1` Shell**:
     ```bash
     docker exec -it web1 /bin/bash
     ```
   - **Install Tools**:
     ```bash
     apt-get update && apt-get install -y iputils-ping curl
     ```
   - **Ping `web2`**:
     ```bash
     ping 172.17.0.3
     ```
     - **Outcome**: Successful replies (e.g., `64 bytes from 172.17.0.3`).
   - **Ping by Name** (expect failure):
     ```bash
     ping web2
     ```
     - **Outcome**: Fails with “Name or service not known”.
   - **Exit Shell**:
     ```bash
     exit
     ```
   - **Terminal**: Host terminal, then `web1` shell, then back to host.

4. **Run `web3` with Port Mapping**:
   ```bash
   docker run -d --name web3 -p 8080:80 nginx
   ```
   - **Why**: Exposes Nginx on port 8080.
   - **Outcome**: Open `http://localhost:8080` to see the Nginx welcome page.
   - **Terminal**: Host terminal.

### 🧪 Task 3: Build a Custom Image
**Goal**: Create a custom Nginx image with a static HTML page.

1. **Create Project Directory**:
   ```bash
   mkdir my-image && cd my-image
   ```
   - **Terminal**: Host terminal.

2. **Create `index.html`**:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>My Custom Image</title>
   </head>
   <body>
       <h1>Hello from my custom Docker image!</h1>
   </body>
   </html>
   ```
   - **Why**: A custom page for Nginx to serve.
   - **Terminal**: Host terminal (use a text editor).

3. **Create `Dockerfile`**:
   ```dockerfile
   FROM nginx:alpine
   COPY index.html /usr/share/nginx/html/index.html
   EXPOSE 80
   CMD ["nginx", "-g", "daemon off;"]
   ```
   - **Why**: Defines a custom image based on `nginx:alpine`.
   - **Terminal**: Host terminal.

4. **Build the Image**:
   ```bash
   docker build -t my-custom-nginx:latest .
   ```
   - **Outcome**: Image built, visible in `docker images`.
   - **Terminal**: Host terminal.

5. **Run the Container**:
   ```bash
   docker run -d --name custom-web -p 8081:80 my-custom-nginx
   ```
   - **Outcome**: Open `http://localhost:8081` to see “Hello from my custom Docker image!”.
   - **Terminal**: Host terminal.

6. **Inspect the Image**:
   ```bash
   docker image inspect my-custom-nginx:latest
   ```
   - **Outcome**: Shows layers and metadata, including `index.html`.
   - **Terminal**: Host terminal.

### 🧪 Task 4: Push and Pull from Docker Hub
**Goal**: Share your custom image.

1. **Create a Docker Hub Repository**:
   - Sign up at [hub.docker.com](https://hub.docker.com) and create a repository (e.g., `yourusername/my-custom-nginx`).

2. **Tag the Image**:
   ```bash
   docker tag my-custom-nginx:latest yourusername/my-custom-nginx:latest
   ```
   - **Terminal**: Host terminal.

3. **Log in to Docker Hub**:
   ```bash
   docker login
   ```
   - **Outcome**: “Login Succeeded” after entering credentials.
   - **Terminal**: Host terminal.

4. **Push the Image**:
   ```bash
   docker push yourusername/my-custom-nginx:latest
   ```
   - **Outcome**: Image uploaded to Docker Hub.
   - **Terminal**: Host terminal.

5. **Test Pulling**:
   ```bash
   docker rmi yourusername/my-custom-nginx:latest my-custom-nginx:latest
   docker pull yourusername/my-custom-nginx:latest
   docker run -d --name test-web -p 8082:80 yourusername/my-custom-nginx:latest
   ```
   - **Outcome**: Open `http://localhost:8082` to see the custom page.
   - **Terminal**: Host terminal.

### 🧪 Task 5: Clean Up
```bash
docker stop web1 web2 web3 custom-web test-web
docker rm web1 web2 web3 custom-web test-web
docker image prune -a -f
```
- **Why**: Removes containers and unused images to free resources.
- **Terminal**: Host terminal.

---

## 🔑 Key Takeaways
- 🖼 **Images as Blueprints**: Package apps, dependencies, and OS for portability.
- 🥞 **Layered Efficiency**: Cached layers optimize builds and storage.
- 🌐 **Networking Integration**: Images define services (e.g., Nginx on port 80) that interact with Docker’s networks (Day 24).
- 🛠 **Custom Images**: Building images (Task 3) prepares you for Day 25’s Dockerfiles.
- 🚀 **Next Steps**: Ready for Flask + Nginx + MongoDB project (Day 31–33).

---

## 🛠 Troubleshooting
- **Image Missing**: Run `docker pull nginx:latest` if `nginx` isn’t found.
- **Build Fails**: Check Dockerfile syntax and file paths (e.g., `index.html`).
- **Port Conflicts**: Verify ports 8080–8082 are free (`netstat -tuln` on Linux).
- **Push Fails**: Ensure Docker Hub login and correct repository name.
- **New Terminal**: Use a second terminal for `docker ps` or `docker network inspect` while in a container shell.

---

## 🌟 Next Steps
- 🔄 **Review**: Repeat Tasks 3–4 to master image creation.
- 📚 **Prepare**: Study Dockerfiles for Day 25.
- 💡 **Extend**: Build a Python-based image (e.g., Flask) for your project.
- 📢 **Share**: Push this repo to GitHub and share on X (@GrokAI).

---

*Built as part of a 40-day Containers & Automation journey. Let’s containerize the world! 🚢*