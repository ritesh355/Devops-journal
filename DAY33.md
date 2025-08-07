# Day 33: Adding Linting and Unit Tests to My GitHub Actions Workflow 🚀

Welcome to **Day 33** of my **#100DaysOfDevOps** journey! After setting up a basic GitHub Actions workflow on Day 35, today I enhanced it to run **linting** (`flake8`) and **unit tests** (`pytest`) automatically. This brings Continuous Integration (Day 34) to life by ensuring my code is clean and functional. As a beginner, I’m excited to share my step-by-step process, code, and lessons—perfect for anyone learning CI/CD! Let’s dive in! 💻

## Why Linting and Unit Tests? 🤔
- **Linting**: Checks code style (e.g., `flake8` enforces PEP 8 for Python). Keeps my code readable and professional.
- **Unit Tests**: Verifies code works (e.g., `pytest` tests my `add` function). Catches bugs early.
- **CI/CD Connection**: Automating these checks in GitHub Actions is core to Continuous Integration, ensuring quality on every push.

This builds on my `ci-cd-practice` repo (github.com/ritesh355/ci-cd-practice) and preps me for Docker workflows (Days 39–40).

## Step 1: Verifying My Setup 🗂️
I used my `ci-cd-practice` repo from Days 32–33, which has:
- `app.py`: A simple function.
  ```python
  def add(a, b):
      return a + b
  ```
- `test_app.py`: Unit tests.
  ```python
  from app import add

  def test_add():
      assert add(2, 3) == 5
      assert add(-1, 1) == 0
  ```
- `script.py`: A script from Day 35.
- `.github/workflows/ci.yml`: Basic workflow.

**Commands**:
```bash
cd ~/ci-cd-practice
git pull origin main
pip install flake8 pytest
flake8 app.py
pytest test_app.py
```
- `flake8` checked style; `pytest` passed 2 tests.
- Fixed any style issues locally to ensure clean code.

## Step 2: Enhancing the Workflow ⚙️
I updated `.github/workflows/ci.yml` to add `lint` and `test` jobs alongside `run-script`.

**Updated `ci.yml`**:
```yaml
name: CI Workflow with Linting and Tests

on:
  push:
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
git commit -m "Add linting and unit tests to GitHub Actions workflow"
git push origin main
```

**What Happened**:
- Pushed to `main`, triggering the workflow.
- Checked GitHub’s **Actions** tab:
  - `lint`: Ran `flake8 app.py` (no errors if clean).
  - `test`: Ran `pytest test_app.py` (2 tests passed).
  - `run-script`: Printed “Hello from GitHub Actions!”.

## Step 3: Testing with Errors 🔍
To practice debugging , I broke things:
1. **Linting Failure**:
   - Edited `app.py`:
     ```python
     def add(a,b):return a+b
     ```
   - Pushed; `lint` job failed with `flake8` errors (e.g., “E231 missing whitespace”).
2. **Test Failure**:
   - Edited `test_app.py`:
     ```python
     def test_add():
         assert add(2, 3) == 6  # Wrong
         assert add(-1, 1) == 0
     ```
   - Pushed; `test` job failed with `pytest` error (“5 != 6”).
3. **Fixed Both**:
   - Restored `app.py` and `test_app.py` to original versions.
   - Pushed; all jobs passed.

**Lesson**: Logs in the Actions tab are key for debugging CI failures.

## Why This Matters 🌟
- **CI in Action**: My workflow now ensures code quality (`flake8`) and functionality (`pytest`) on every push.
- **Portfolio**: This pipeline is a strong addition to my GitHub portfolio for DevOps jobs.
- **Weather App**: I can apply this to my Flask app to automate checks before deployment.

## Tips for Beginners 💡
1. **Test Locally First**: Run `flake8` and `pytest` before pushing to avoid workflow failures.
2. **Check Logs**: Use GitHub Actions logs to debug errors.
3. **Keep Jobs Simple**: Separate `lint` and `test` jobs for clarity.
4. **Document**: I noted everything in `Day36.md`:
   ```
   Added `flake8` and `pytest` to `ci.yml`.
   Tested failures and fixes; learned to read logs.
   Ready for Day 37’s triggers.
   ```
5. **Explore**: Try adding a new test (e.g., `assert add(0, 0) == 0`) and push to see it run.

## Resources 📚
- **Docs**: `flake8` (flake8.pycqa.org), `pytest` (docs.pytest.org), GitHub Actions (docs.github.com/en/actions)
- **Video**: FreeCodeCamp’s “GitHub Actions Tutorial” (YouTube)
- **Tool**: GitHub (github.com) for repos and Actions

## What’s Next? 🔜
On Day 37, I’ll explore GitHub Actions triggers (e.g., `push`, `pull_request`) to make my workflow more flexible. This will enhance collaboration for my projects! Stay tuned!

## Join the Journey! 🚀
Have you added tests to a CI pipeline? Share your tips or questions in the comments! Follow my #100DaysOfDevOps on Hashnode for more DevOps adventures. Let’s master CI/CD together! 💪

## 👨‍💻 Author
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GitHub](https://github.com/ritesh355/Devops-journal)

#100DaysOfDevOps #CICD #GitHubActions #DevOps #Beginner
