# 🚀 Day 40: CI/CD with Flask + Docker + GitHub Actions | #100DaysOfDevOps

Welcome to **Day 40** of my [#100DaysOfDevOps](https://github.com/ritesh355/Devops-journal)! Today, I built a **CI/CD pipeline** for a Python **Flask** application, containerized it with **Docker**, and automated the build and deployment process using **GitHub Actions**. Let’s dive into this exciting journey! 🐍🐳💥 #DevOps #CI/CD

---

## 🔧 Project Overview: Flask App with Docker CI/CD

The goal of this project is to create a simple Flask application, containerize it using Docker, and set up a GitHub Actions workflow to automatically build and push the Docker image to Docker Hub whenever code is pushed to the `main` branch. #Flask #Docker #GitHubActions

---

## 🗂 Project Structure

Here’s the structure of the project:

```
flask-ci-cd-demo/
├── app/
│   ├── app.py           # Flask app logic
│   └── requirements.txt # Python dependencies
├── Dockerfile           # Docker configuration
├── .dockerignore        # Ignore unnecessary files in Docker context
├── .gitignore           # Ignore local dev/config files
├── .github/
│   └── workflows/
│       └── ci-cd.yml    # GitHub Actions workflow file
└── README.md            # Project details
```

---

## 🛠️ Step 1: Set Up the Project

Create the project directory and initialize a Python environment:

```bash
mkdir flask-ci-cd-demo && cd flask-ci-cd-demo
mkdir app
```

---

## 🐍 Step 2: Create the Flask Application

### `app/app.py`
Create a simple Flask app:

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 Hello from Flask CI/CD Pipeline!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

This code sets up a Flask server that responds with a message at `http://localhost:5000`. #Python #Flask

### `app/requirements.txt`
List the dependencies:

```text
flask
```

---

## 🐳 Step 3: Create the Dockerfile

Create a `Dockerfile` to containerize the Flask app:

```dockerfile
# Use official Python image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Copy files and install dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY app/ .

# Run the Flask app
CMD ["python", "app.py"]
```

**Why this structure?**
- Using `python:3.10-slim` keeps the image lightweight.
- Copying `requirements.txt` first allows Docker to cache the dependency layer, speeding up builds if only `app.py` changes. #Docker #Optimization

---

## 📦 Step 4: Optimize with `.dockerignore` and `.gitignore`

### `.dockerignore`
Prevent unnecessary files from being included in the Docker image:

```text
# Git and version control
.git
.gitignore

# Python bytecode
__pycache__/
*.pyc

# Virtual environments
env/
venv/
ENV/

# Editor settings
.vscode/
.idea/

# System files
.DS_Store

# GitHub Actions config
.github/
```

### `.gitignore`
Ignore local development and temporary files:

```text
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
env/
venv/
ENV/
*.env

# Editor settings
.vscode/
.idea/

# System files
.DS_Store
Thumbs.db

# Logs
*.log

# Docker artifacts
*.tar
```

These files ensure clean builds and repositories by excluding irrelevant files. #BestPractices

---

## ⚙️ Step 5: Set Up GitHub Actions Workflow

Create the workflow file at `.github/workflows/ci-cd.yml`:

```yaml
name: Flask CI/CD

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🐍 Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.10'

      - name: 📦 Install dependencies
        run: pip install -r app/requirements.txt

      - name: ✅ Run tests
        run: echo "No tests yet"

      - name: 🐳 Build Docker image
        run: docker build -t ritesh355/flask-ci-cd-demo .

      - name: 📤 Push to Docker Hub
        run: |
          echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin
          docker tag ritesh355/flask-ci-cd-demo ritesh355/flask-ci-cd-demo:latest
          docker push ritesh355/flask-ci-cd-demo:latest
```

**Key Points**:
- Triggers on pushes to the `main` branch.
- Sets up Python 3.10 and installs dependencies.
- Builds the Docker image and pushes it to Docker Hub.
- Uses GitHub Secrets for secure Docker Hub authentication. #GitHubActions #Automation

---

## 🔐 Step 6: Configure Docker Hub Secrets

To enable Docker Hub pushes, add these secrets to your GitHub repository:
- `DOCKER_USERNAME`: Your Docker Hub username (`ritesh355`).
- `DOCKER_PASSWORD`: Your Docker Hub access token (not your password).

Add them via:
1. Go to GitHub Repo → **Settings** → **Secrets and variables** → **Actions**.
2. Click **New repository secret** and add `DOCKER_USERNAME` and `DOCKER_PASSWORD`. #Security #DockerHub

---

## 🚀 Step 7: Push to GitHub

Push your project to GitHub:

```bash
git init
git remote add origin https://github.com/ritesh355/flask-ci-cd-demo.git
git add .
git commit -m "Add Flask CI/CD demo with Docker and GitHub Actions"
git push -u origin main
```

---

## ✅ Step 8: Verify the CI/CD Pipeline

1. Go to your GitHub repo → **Actions** tab.
2. Watch the **Flask CI/CD** workflow run. It will:
   - Install Python dependencies.
   - Build the Docker image.
   - Push the image to `ritesh355/flask-ci-cd-demo:latest` on Docker Hub.
3. Visit [Docker Hub](https://hub.docker.com/u/ritesh355) to confirm the image is published.

---

## 🧪 Step 9: Test the Docker Image Locally

To verify the image, run it locally (if you have Docker installed):

```bash
docker pull ritesh355/flask-ci-cd-demo:latest
docker run -p 5000:5000 ritesh355/flask-ci-cd-demo
```

Open your browser and visit [http://localhost:5000](http://localhost:5000). You should see:

**"🚀 Hello from Flask CI/CD Pipeline!"**

---

## 📌 Learnings from Day 13

- Built an end-to-end **CI/CD pipeline** for a Flask app using GitHub Actions.
- Used `.dockerignore` and `.gitignore` to optimize Docker builds and keep the repository clean.
- Secured Docker Hub credentials with **GitHub Secrets**.
- Automated Docker image builds and pushes to Docker Hub. #Learning #DevOpsJourney

---

## 📈 Benefits

- **Automation**: Push code, and GitHub Actions handles the rest.
- **Efficiency**: `.dockerignore` reduces image size and build time.
- **Security**: Sensitive credentials are safely stored in GitHub Secrets.
- **Scalability**: Ready to extend with tests or deployment steps.

---

## 🔗 Useful Links

- 💻 [GitHub Repo](https://github.com/ritesh355/flask-ci-cd-demo)
- 📦 [Docker Hub](https://hub.docker.com/u/ritesh355)
- ✍️ [My Blog](https://ritesh-devops.hashnode.dev)

#Portfolio #Networking

---

## 🎉 Congratulations!

You’ve successfully built a **CI/CD pipeline** for a Flask app with Docker and GitHub Actions! Keep rocking your #100DaysOfDevOps journey! 💪 #KeepLearning

> **Need help?** Drop a comment or question, and I’ll guide you through any issues!
