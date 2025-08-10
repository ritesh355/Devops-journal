# 🚀 Day 37: GitHub Actions – Matrix Builds with Node.js + Jest

Welcome to **Day 10** of your DevOps journey! Today, we’re diving into **GitHub Actions** to master **matrix builds**, test a Node.js app across multiple Node versions (18.x, 20.x, 22.x), and troubleshoot compatibility issues. Let’s build a robust CI pipeline with **Jest**! 🎉

---

## 📌 Goals

By the end of this guide, you’ll know how to:
- 🛠️ Use **matrix builds** in GitHub Actions to test across multiple environments.
- ✅ Test Node.js code across Node versions **18.x**, **20.x**, and **22.x**.
- 🔍 Identify and troubleshoot compatibility issues.
- ⚙️ Write clean CI pipelines for Node.js + Jest.

---

## 🛠️ Step 1: Project Setup

Let’s create a new project and set up Jest for testing.

1. Create a project folder and initialize a Node.js app:
   ```bash
   mkdir matrix-demo && cd matrix-demo
   npm init -y
   ```

2. Install Jest as a dev dependency:
   ```bash
   npm install --save-dev jest
   ```

3. Your `package.json` should look like this:

```json
{
  "name": "matrix-demo",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "jest"
  },
  "license": "ISC",
  "devDependencies": {
    "jest": "^30.0.5"
  }
}
```

---

## 📄 Step 2: Create App and Test Files

### `app.js`
Create a simple function to test:

```javascript
function add(a, b) {
  return a + b;
}

module.exports = add;
```

### `app.test.js`
Write a Jest test for the `add` function:

```javascript
const add = require('./app');

test('adds 1 + 2 to equal 3', () => {
  expect(add(1, 2)).toBe(3);
});
```

### Test Locally
Run the tests to verify everything works:

```bash
npm test
```

**Expected Output**:
```
PASS  ./app.test.js
✓ adds 1 + 2 to equal 3 (1 ms)
```

---

## 🚀 Step 3: Push Code to GitHub

Push your project to a GitHub repository:

```bash
git init
git remote add origin https://github.com/ritesh355/matrix-demo.git
git add .
git commit -m "Initial commit with jest test"
git push -u origin main
```

---

## ⚙️ Step 4: Add GitHub Actions Workflow

Create a matrix build workflow to test across Node.js versions.

1. Create the file `.github/workflows/test.yml`:

```yaml
name: Matrix Test Workflow

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x, 20.x, 22.x]

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Install Dependencies
        run: npm ci

      - name: Run Tests
        run: npm test
```

2. Commit and push the workflow:

```bash
git add .github/workflows/test.yml
git commit -m "Add matrix build workflow"
git push
```

---

## ✅ Step 5: View the Workflow in GitHub

1. Go to your GitHub repository → **Actions** tab.
2. You’ll see the **Matrix Test Workflow** running three parallel jobs:
   - Node **18.x** ✅
   - Node **20.x** ✅
   - Node **22.x** ✅

3. If any job fails, check for compatibility issues (e.g., Jest or syntax problems).

---

## 🔍 Troubleshooting

### Common Error
```
failed to fetch oauth token... 401 Unauthorized
```

### ✅ Solution
- This error is typically related to Docker credentials but isn’t applicable here unless you’re pushing images.
- For matrix builds, ensure your GitHub Actions workflow is correct and dependencies are compatible with all Node versions.

---

## 🧠 What You Learned

- ✅ How to test code across multiple Node.js versions using **matrix builds**.
- ⚙️ Setting up a **GitHub Actions** pipeline with Jest.
- 🔍 Managing dependency compatibility across environments.
- 🚀 Writing clean, efficient CI pipelines for Node.js projects.

---

## 🔗 Resources

- 📚 [GitHub Actions Matrix Strategy](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs)
- 🧪 [Jest Documentation](https://jestjs.io/)

---

## ✍️ Author

**Ritesh Singh**
- 🔗 [GitHub: ritesh355](https://github.com/ritesh355)
- ✍️ [Blog: ritesh-devops.hashnode.dev](https://ritesh-devops.hashnode.dev)
- 💼 [LinkedIn: Ritesh Singh](https://www.linkedin.com/in/ritesh-singh-355)

---

## 🎉 Congratulations!

You’ve successfully set up a **matrix build** with GitHub Actions to test your Node.js app across multiple versions! Keep rocking your DevOps journey! 💪

> **Need help?** Drop a comment or question, and I’ll guide you through any issues!
