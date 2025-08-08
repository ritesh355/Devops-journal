# Day 34: Exploring GitHub Actions Triggers 🚀

Welcome to my **#100DaysOfDevOps** journey! Today, I learned about **GitHub Actions triggers**, specifically `push` and `pull_request`, and updated my `ci-cd-practice` workflow to run on both. This makes my CI pipeline more collaborative by checking code before merging. As a beginner, I’m excited to share my hands-on process, code, and lessons—perfect for anyone starting with CI/CD! Let’s get started! 💻

## What Are Triggers? 🤔
Triggers tell GitHub Actions when to run a workflow, like when I push code or create a pull request. They’re set in the `on` section of a `.yml` file.

- **`push`**: Runs the workflow when I push code to a branch (e.g., `main`).
- **`pull_request`**: Runs when I create or update a pull request, ensuring code is tested before merging.

**Why It’s Cool**:
- Automates checks for different events, keeping my code reliable.
- Makes my Weather App or WordPress blog pipeline professional.
- Great for team projects, as pull requests validate code changes.

## Step 1: Checking My Setup 🗂️
My `ci-cd-practice` repo (github.com/ritesh355/ci-cd-practice) has:
- `app.py`: A function (`def add(a, b)`).
- `test_app.py`: Unit tests.
- `script.py`: A simple script.
- `.github/workflows/ci.yml`: Runs `flake8` (linting), `pytest` (tests), and a script on `push` to `main`.

**Commands**:
```bash
cd ~/ci-cd-practice
git pull origin main
pip install flake8 pytest
flake8 app.py
pytest test_app.py
```
- Confirmed no linting errors and tests passed locally.

## Step 2: Adding `pull_request` Trigger ⚙️
I updated `ci.yml` to run on both `push` and `pull_request` to `main`.

**Updated `ci.yml`**:
```yaml
name: CI Workflow with Linting and Tests

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.9'
      - name: Install dependencies
        run: pip install flake8
      - name: Run linting
        run: flake8 app.py

  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.9'
      - name: Install dependencies
        run: pip install pytest
      - name: Run tests
        run: pytest test_app.py

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

**Commands**:
```bash
git add .github/workflows/ci.yml
git commit -m "Add pull_request trigger to workflow"
git push origin main
```

## Step 3: Testing the `pull_request` Trigger 🔍
I created a pull request to test the workflow.

**Steps**:
1. Created a branch:
   ```bash
   git checkout -b feature/add-test
   ```
2. Added a test to `test_app.py`:
   ```python
   def test_add_zero():
       assert add(0, 0) == 0
   ```
3. Pushed:
   ```bash
   git add test_app.py
   git commit -m "Add test for add(0, 0)"
   git push origin feature/add-test
   ```
4. Made a pull request on GitHub from `feature/add-test` to `main`.
5. Checked **Actions** tab:
   - Workflow ran: `lint` (passed), `test` (3 tests passed), `run-script` (printed message).
   - Pull request showed a green checkmark.
6. Merged the pull request; workflow ran again on `push` to `main`.

## Step 4: Testing Failures 🛠️
I created a buggy pull request to learn debugging:
1. Created `feature/buggy-code` branch.
2. Broke `app.py` (no spaces) and `test_app.py` (wrong assertion).
3. Pushed and made a pull request.
4. Workflow failed: `lint` showed style errors, `test` showed assertion errors.
5. Fixed both files, pushed, and saw the workflow pass.
6. Merged the pull request.

**Lesson**: Pull request triggers catch issues before merging, ensuring quality.

## Why This Matters 🌟
- **Collaboration**: Pull request triggers validate code, perfect for team projects.
- **Portfolio**: A workflow with multiple triggers impresses employers.
- **Weather App**: I can use this to test my Flask app before merging changes.

## Tips for Beginners 💡
1. **Test Locally**: Run `flake8` and `pytest` before pushing to avoid failures.
2. **Check Logs**: Use Actions tab logs to debug pull request failures.
3. **Start Small**: Add one trigger at a time (e.g., `pull_request`).
4. **Document**: I wrote in `Day37.md`:
   ```
   Added `pull_request` trigger to `ci.yml`.
   Tested with a new test and buggy code; fixed failures.
   Learned triggers make pipelines collaborative.
   ```
5. **Explore**: Try another pull request with a small change (e.g., update `script.py`).

## Resources 📚
- **Docs**: GitHub Actions Events (docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
- **Video**: TechWorld with Nana’s “GitHub Actions Tutorial” (YouTube)
- **Tool**: GitHub (github.com) for repos and Actions

## What’s Next? 🔜
Next, I’ll explore environment variables and secrets in GitHub Actions to securely manage sensitive data, like API keys for my Weather App. Stay tuned!

## Join the Journey! 🚀
Have you used GitHub Actions triggers? Share your experience or questions in the comments! Follow my #100DaysOfDevOps on Hashnode for more DevOps adventures. Let’s master CI/CD together! 💪

## 👨‍💻 Author
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GitHub](https://github.com/ritesh355/Devops-journal)

#100DaysOfDevOps #CICD #GitHubActions #DevOps #Beginner
