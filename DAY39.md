# 🚀 Day 39: GitHub Actions – Docker Layer Caching | #100DaysOfDevOps

Welcome to **Day 39** of my [#100DaysOfDevOps](https://github.com/ritesh355/Devops-journal)! Today, we’re diving into **Docker Layer Caching** in GitHub Actions to supercharge your CI/CD pipelines. By reusing previously built Docker layers, we can drastically reduce build times and optimize workflows. Let’s get started! 🐳⚡ #DevOps #GitHubActions

---

## 📌 Project: Docker Layer Caching Demo

This project demonstrates how to implement **Docker Layer Caching** in GitHub Actions using a simple Node.js application. The goal is to showcase how caching Docker layers can speed up builds by avoiding redundant work. 🚀 #Docker #CI/CD

---

## 📁 Project Structure

Here’s how your project directory should look:

```
docker-layer-caching-demo/
├── app.js                # Node.js application
├── Dockerfile            # Docker configuration
├── package.json          # Node.js dependencies and scripts
├── package-lock.json     # Lock file for reproducible builds
└── .github/
    └── workflows/
        └── docker.yml    # GitHub Actions workflow for Docker builds
```

---

## 🛠️ Step 1: Initialize the Project

Set up a new Node.js project:

```bash
mkdir docker-layer-caching-demo && cd docker-layer-caching-demo
npm init -y
npm install
```

The `npm install` command ensures dependencies are set up, though our simple app doesn’t require additional packages for this demo. #NodeJS

---

## 🧑‍💻 Step 2: Create the Node.js Application

### `app.js`
Create a simple HTTP server in `app.js`:

```javascript
const http = require('http');
const PORT = 3000;

const server = http.createServer((req, res) => {
  res.end('🚀 Docker Layer Caching in GitHub Actions!');
});

server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
```

This code sets up a Node.js server that responds with a message on port 3000. You can test it locally with:

```bash
node app.js
```

Visit [http://localhost:3000](http://localhost:3000) to see: **"🚀 Docker Layer Caching in GitHub Actions!"** #JavaScript

---

## 🐳 Step 3: Create the Dockerfile

Create a `Dockerfile` to containerize the app:

```dockerfile
FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["node", "app.js"]
```

**Why this structure?**
- Copying `package*.json` and running `npm install` before copying the app code ensures that the dependency layer is cached separately. This means changes to `app.js` won’t trigger a reinstall of dependencies, leveraging Docker’s layer caching. #Docker #Optimization

---

## 📦 Step 4: Update `package.json`

Ensure your `package.json` is set up correctly:

```json
{
  "name": "docker-layer-caching-demo",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "license": "ISC"
}
```

The `package-lock.json` will be auto-generated when you run `npm install`. This lock file is critical for consistent caching in GitHub Actions. #NodeJS #Dependencies

---

## ⚙️ Step 5: Set Up GitHub Actions Workflow

Create the workflow file at `.github/workflows/docker.yml`:

```yaml
name: 🚀 Docker Layer Caching

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: ⬇️ Checkout code
        uses: actions/checkout@v4

      - name: 🐳 Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: 📦 Docker Layer Cache
        uses: actions/cache@v4
        with:
          path: /tmp/.buildx-cache
          key: ${{ runner.os }}-docker-${{ github.sha }}
          restore-keys: |
            ${{ runner.os }}-docker-

      - name: 🏗️ Build Docker image
        run: |
          docker build \
            --build-arg BUILDKIT_INLINE_CACHE=1 \
            --cache-from=type=local,src=/tmp/.buildx-cache \
            --cache-to=type=local,dest=/tmp/.buildx-cache \
            -t myapp:latest .
```

**Key Points**:
- **Docker Buildx**: Enables advanced build features, including layer caching.
- **Cache Configuration**: Uses `actions/cache@v4` to store Docker layers in `/tmp/.buildx-cache`.
- **Cache Key**: Combines `${{ runner.os }}-docker-` with the commit SHA (`${{ github.sha }}`) for unique cache entries.
- **Restore Keys**: Allows fallback to previous caches if the exact SHA isn’t found.
- **Buildkit**: The `--build-arg BUILDKIT_INLINE_CACHE=1` ensures cache metadata is included in the image. #GitHubActions #DockerBuild

---

## 🚀 Step 6: Push to GitHub

Push your project to GitHub:

```bash
git init
git remote add origin https://github.com/ritesh355/docker-layer-caching-demo.git
git add .
git commit -m "Add Docker layer caching demo with GitHub Actions"
git push -u origin main
```

---

## 🧪 Step 7: Check Workflow and Cache

1. Go to your GitHub repo → **Actions** tab.
2. Watch the **Docker Layer Caching** workflow run.

### First Run (Cache Miss)
**Output**:
```
Cache not found for: Linux-docker-...
...
[+] Building 56.4s (10/10) FINISHED
```

**Result**:
- Docker layers are built from scratch.
- Cache is created and stored in `/tmp/.buildx-cache`.

### Second Run (Cache Hit)
**Output**:
```
Cache hit for: Linux-docker-c860ffe0118cab7eaf0092ade240cec129459046
Cache restored successfully
...
[+] Building 5.3s (10/10) FINISHED
```

**Result**:
- Cached layers are reused.
- Build time drops significantly (e.g., from ~50s to ~5s). 🚀

---

## 📈 Benefits of Docker Layer Caching

| **Build Stage**         | **Time Without Cache** | **Time With Cache** |
|-------------------------|------------------------|---------------------|
| Initial Build           | ⏳ ~50s               | ✅ Cached           |
| Subsequent Builds       | ⚡ ~5s                | 🚀 Super Fast!      |

**Why it works**:
- Docker layers (e.g., `npm install`) are cached and reused unless `package*.json` changes.
- The GitHub Actions cache persists layers between workflow runs, reducing redundant builds. #Optimization #Efficiency

---

## 🔍 How to Check Cache Status

In the GitHub Actions logs, look under the **Docker Layer Cache** step:
- ✅ **Cache hit**: Layers were reused, speeding up the build.
- ❌ **Cache not found**: A new cache was created.

---

## 📚 What I Learned

- How to implement **Docker Layer Caching** in GitHub Actions using `actions/cache@v4`.
- Using `docker/setup-buildx-action` and Buildkit for efficient Docker builds.
- Crafting cache keys with `package-lock.json` hashes or commit SHAs for reliability.
- Debugging cache hits/misses in GitHub Actions logs.
- Optimizing CI/CD pipelines for faster, smarter builds. #Learning #DevOpsJourney

---

## 🔗 Connect with Me

- 📘 [GitHub: ritesh355](https://github.com/ritesh355)
- ✍️ [Hashnode: ritesh-devops.hashnode.dev](https://ritesh-devops.hashnode.dev)
- 💼 [LinkedIn: ritesh-singh-092b84340](https://www.linkedin.com/in/ritesh-singh-092b84340)

#Portfolio #Networking

---

## 🎉 Congratulations!

You’ve mastered **Docker Layer Caching** in GitHub Actions, making your CI/CD pipelines faster and more efficient! Keep rocking your #100DaysOfDevOps journey! 💪 #KeepLearning

> **Need help?** Drop a comment or question, and I’ll guide you through any issues!
