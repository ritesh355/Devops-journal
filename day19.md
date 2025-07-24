# 🚀 Day 19: Build a Local Git + Bash Automation Tool

Welcome to Day 19 of my **#100DaysOfDevOps** journey! Today, I built a simple yet powerful **Git automation tool** using Bash. This tool helps me instantly initialize new projects, commit them, create a GitHub repo, and push — all in a few seconds! 💻⚡

---

## 🎯 Goal

To create a script that:
- Takes a project name (and optional GitHub visibility)
- Initializes a local Git repo
- Commits initial code
- Creates a GitHub repo using the `gh` CLI
- Pushes everything automatically 🚀

---

## 🧠 Why This Matters

As a DevOps engineer, automation is key 🔑. Repeating the same Git + GitHub setup over and over wastes time. This tool streamlines that process so I can focus more on writing and deploying code!

---

## 📜 The Script: `autogit.sh`

```bash
#!/bin/bash

PROJECT_NAME=$1
VISIBILITY=${2:-public}
DATE=$(date)
LOG_FILE="$HOME/.autogit_log.txt"

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Please provide a project name: ./autogit.sh <project_name> [public|private]"
  exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
  read -p "⚠️ '$PROJECT_NAME' already exists. Overwrite it? (y/n): " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    rm -rf "$PROJECT_NAME"
    echo "🗑️ Old folder removed."
  else
    echo "❌ Operation canceled."
    exit 1
  fi
fi

mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME" || exit
echo "# $PROJECT_NAME" > README.md
echo -e "📁 Project: $PROJECT_NAME\n🕒 Created: $DATE" >> README.md

git init
git add .
git commit -m "Initial commit by AutoGit"
git branch -M main

gh repo create "ritesh355/$PROJECT_NAME" --$VISIBILITY --source=. --remote=origin --push

echo "$DATE - Project '$PROJECT_NAME' created and pushed [$VISIBILITY]" >> "$LOG_FILE"
echo "✅ '$PROJECT_NAME' successfully created and pushed to GitHub!"

---

##💻 How to Use It

```bash
chmod +x autogit.sh
./autogit.sh my_cool_project 

```
You can also set visibility to private.

---

🛠️ Requirements

   - Git installed (git --version)

   - GitHub CLI authenticated (gh auth login)

   - GitHub account with proper permissions

---

📂 Example Output

```bash
📦 Starting AutoGit setup for: my_cool_project
Initialized empty Git repository
✨ Created README.md
✅ Pushed to GitHub: https://github.com/ritesh355/my_cool_project

```

- **Note** replace my_cool_project with your project folder name and give your github link 
---

🔗 My Work

    [Project](https://github.com/ritesh355/ritesh)
    [📂 GitHub Repo](https://github.com/ritesh355/Devops-journal)

    [✍️ Blog Post] (https://ritesh-devops.hashnode.dev)

    [🔗 LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/)

---
 💬 Let’s Connect!

💬 Drop your feedback or suggestions here or on LinkedIn. Let’s grow together!
#100DaysOfDevOps #Bash #GitHubCLI #DevOpsTools # github   


