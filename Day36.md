# 🚀 Day 36: Automating Docker Builds with GitHub Actions

Welcome to Day 36 of your DevOps journey! Today, we’ll automate building a Docker image and pushing it to Docker Hub using **GitHub Actions**. Let’s dive in and make it happen! 🎉

---

## 🔧 Prerequisites

Before we start, ensure the following are ready:

- ✅ **Docker Hub Account**: You’re all set with `ritesh355`.
- ✅ **GitHub Secrets**:
  - `DOCKER_USERNAME`: `ritesh355`
  - `DOCKER_PASSWORD`: Your **Docker Hub access token** (not your password).

> **Not set up?** No worries! Create a Docker Hub account at [docker.com](https://docker.com) and add the secrets in your GitHub repo under **Settings > Secrets and variables > Actions**. Let me know if you need help!

---

## 📁 Step-by-Step Project Setup

We’ll create a simple **Node.js app**, containerize it with Docker, and automate its deployment to Docker Hub using GitHub Actions.

### 1. 🔨 Create a New GitHub Repo

Let’s set up the project directory and initialize a Node.js app:

```bash
mkdir node-docker-push
cd node-docker-push
npm init -y
```

### 2. 📦 Create a Sample Node.js App

Create a file named `app.js` with the following content:

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  res.end('Hello from Docker + GitHub Actions 🚀');
});

server.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
```

### 3. 📄 Create a Dockerfile

Create a `Dockerfile` to containerize the app:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
```

### 4. 📝 Set Up GitHub Actions Workflow

Create a workflow file at `.github/workflows/docker-publish.yml`:

```yaml
name: 🚀 Build and Push Docker Image

on:
  push:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: 🧾 Checkout code
        uses: actions/checkout@v3

      - name: 🔐 Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: 🛠️ Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ritesh355/node-docker-push:latest
```

This workflow triggers on every push to the `main` branch, checks out the code, logs into Docker Hub, and builds/pushes the Docker image.

---

## 🚀 Run the Workflow

Follow these steps to push your project and trigger the workflow:

1. **Initialize Git and Push to GitHub**:

```bash
git init
git remote add origin https://github.com/ritesh355/node-docker-push.git
git add .
git commit -m "Day 34 - Push Docker Image to Docker Hub"
git branch -M main
git push -u origin main
```

2. **Monitor the Workflow**:
   - Go to your GitHub repo → **Actions** tab.
   - Watch the workflow run in real-time! 🎉

3. **Check Docker Hub**:
   - Once the workflow completes, visit [Docker Hub](https://hub.docker.com) and find your image: `ritesh355/node-docker-push:latest`. ✅

---

## ✅ Verify the Image Locally

If you have Docker installed, test the image locally:

```bash
docker pull ritesh355/node-docker-push:latest
docker run -p 3000:3000 ritesh355/node-docker-push
```

Open your browser and visit: [http://localhost:3000](http://localhost:3000). You should see:

**"Hello from Docker + GitHub Actions 🚀"**

---

## 🎉 Congratulations!

You’ve successfully automated building and pushing a Docker image to Docker Hub using GitHub Actions! Keep rocking your DevOps journey! 💪

> **Need help?** Drop a comment or question, and I’ll guide you through any issues!
