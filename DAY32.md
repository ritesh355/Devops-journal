# Day 32: My First GitHub Actions Workflow 🚀

Welcome to **Day 32** of my **#100DaysOfDevOps** journey! After learning CI/CD concepts on Day 31, today I set up a GitHub repository and created my first **GitHub Actions workflow** to run a simple Python script. As a beginner, I’m thrilled to automate my first CI step! This post walks you through my process, code, and lessons learned—perfect for anyone starting with CI/CD. Let’s dive in! 💻

## What is GitHub Actions? 🤔
GitHub Actions is a powerful CI/CD tool built into GitHub. It lets you automate tasks (like running scripts or tests) when events happen (e.g., pushing code). Workflows are defined in `.yml` files, making it easy to set up pipelines.

**Why It’s Exciting**:
- Automates my Weather App or WordPress blog tasks.
- Free for public repos, great for beginners.
- Builds on Day 34’s CI concepts and preps me for Day 36 (adding tests).

## Step 1: Setting Up the GitHub Repo 🗂️
I reused my `ci-cd-practice` repo from Day 31 (github.com/ritesh355/ci-cd-practice), which has:
- `app.py`: A simple function (`def add(a, b)`).
- `test_app.py`: Unit tests with `pytest`.

**New Addition**: I created `script.py` to run in my workflow:
```python
# script.py
print("Hello from GitHub Actions! This is my first workflow.")
```

**Commands**:
```bash
git add script.py
git commit -m "Add simple script for GitHub Actions"
git push origin main
```

This sets the stage for automation!

## Step 2: Creating the Workflow ⚙️
I created a GitHub Actions workflow to run `script.py` whenever I push to the `main` branch.

**Steps**:
1. Created `.github/workflows/ci.yml` in VS Code:
   ```yaml
   name: Basic CI Workflow

   on:
     push:
       branches:
         - main

   jobs:
     run-script:
       runs-on: ubuntu-latest
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         - name: Set up Python
           uses: actions/setup-python@v5
           with:
             python-version: '3.9'
         - name: Run script
           run: python script.py
   ```
2. Committed and pushed:
   ```bash
   git add .github/workflows/ci.yml
   git commit -m "Add basic GitHub Actions workflow to run script"
   git push origin main
   ```
3. Checked the **Actions** tab on GitHub:
   - Saw “Basic CI Workflow” running.
   - Found the output in logs: `Hello from GitHub Actions! This is my first workflow.`

**What’s Happening**:
- `on: push`: Triggers the workflow when I push to `main`.
- `runs-on: ubuntu-latest`: Runs on an Ubuntu virtual machine.
- `steps`:
  - Clones the repo (`actions/checkout@v4`).
  - Installs Python 3.9 (`actions/setup-python@v5`).
  - Runs `python script.py`.

## Step 3: Testing and Troubleshooting 🔍
To learn, I intentionally broke `script.py`:
```python
print(undefined_variable)  # Causes an error
```
- Pushed and saw the workflow fail in the Actions tab.
- Fixed it, pushed again, and confirmed it passed.

**Lessons**:
- Logs in the Actions tab are super helpful for debugging.
- Small changes trigger the workflow automatically—CI in action!

## Why This Matters 🌟
- This is my first automated CI pipeline, running a script on every push.
- It connects to Day 34: CI automates code checks, and this is the first step.
- Sets me up for Day 36, where I’ll add `flake8` (linting) and `pytest` (testing) to the workflow.

## Tips for Beginners 💡
1. **Start Simple**: Use a basic script26 like mine to learn workflows.
2. **Check Syntax**: Ensure `.yml` files are in `.github/workflows` and use correct indentation (YAML is picky!).
3. **Use Logs**: Actions tab logs show what went wrong.
4. **Explore Examples**: Check github.com/actions/starter-workflows for ideas.
5. **Document**: I’m noting everything in `Day35.md`:
   ```
   Set up `ci-cd-practice` repo and created `ci.yml` to run `script.py` on push.
   Learned to check logs and troubleshoot failures.
   ```

## Resources 📚
- **Docs**: GitHub Actions Quickstart (docs.github.com/en/actions/quickstart)
- **Video**: TechWorld with Nana’s “GitHub Actions Tutorial” (YouTube)
- **Tool**: GitHub (github.com) for free repos and Actions


## 👨‍💻 Author

**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GITHUB](https://github.com/ritesh355/Devops-journal)



## Join the Journey! 🚀

Have you tried GitHub Actions? Share your first workflow or any questions in the comments! Follow my #100DaysOfDevOps on Hashnode for more DevOps adventures. Let’s master CI/CD together! 💪

#100DaysOfDevOps #CICD #GitHubActions #DevOps #Beginner
