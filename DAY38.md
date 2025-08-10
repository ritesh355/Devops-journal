# 🚀 Day 38: GitHub Actions Caching Strategies – Speed Up Your CI/CD! #100DaysOfDevOps

Welcome to **Day 38** of my [#100DaysOfDevOps](https://github.com/ritesh355/Devops-journal)!  
Today, we’re diving into **GitHub Actions caching** to supercharge your CI/CD workflows by caching dependencies with `actions/cache@v4`. Let’s make those builds lightning fast! ⚡ #DevOps #GitHubActions

---

## 📦 What Is Caching in GitHub Actions?

Reinstalling dependencies like `node_modules` in every CI/CD run is time-consuming. With **GitHub Actions caching**, you can store and reuse these dependencies across runs, slashing build times and making your workflows more efficient. 🚀 #CI/CD #Automation

---

## 📁 Project Structure

Here’s how your project should look:

```
caching-demo/
│
├── app.js             # Simple JS app
├── app.test.js        # Jest test file
├── package.json       # Includes Jest
└── .github/
    └── workflows/
        └── nodejs.yml # GitHub Actions Workflow
```

---

## 🛠️ Step 1: Initialize the Project

Set up the project and install Jest:

```bash
mkdir caching-demo && cd caching-demo
npm init -y
npm install --save-dev jest
```

#NodeJS #Jest

---

## 🧪 Step 2: Add Code + Test

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

### Update `package.json`
Ensure your `package.json` includes the test script and Jest dependency:

```json
{
  "name": "caching-demo",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "test": "jest"
  },
  "devDependencies": {
    "jest": "^30.0.5"
  }
}
```

#JavaScript #Testing

---

## ⚙️ Step 3: Add GitHub Actions Workflow

Create the workflow file at `.github/workflows/nodejs.yml`:

```yaml
name: Node.js Caching Demo

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [14.x, 16.x, 18.x]

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🔧 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: 📦 Cache npm dependencies
        uses: actions/cache@v4
        with:
          path: ~/.npm
          key: Linux-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            Linux-node-

      - name: 📥 Install dependencies
        run: npm ci

      - name: 🧪 Run tests
        run: npm test
```

#GitHubActions #Caching

---

## 🚀 Step 4: Push to GitHub

Push your project to GitHub:

```bash
git init
git remote add origin https://github.com/ritesh355/caching-demo.git
git add .
git commit -m "Add caching demo with Jest and GitHub Actions"
git push -u origin main
```

#Git #VersionControl

---

## 🧪 Step 5: Check Workflow and Cache

1. Go to your GitHub repo → **Actions** tab.
2. Watch the **Node.js Caching Demo** workflow run across Node versions **14.x**, **16.x**, and **18.x**.

### First Run (Cache Miss)
**Output**:
```
Cache not found for input keys: Linux-node-...
Run npm ci
Installed packages...
```

**Result**:
- Dependencies installed from scratch.
- Cache created and saved for future runs.

### Second Run (Cache Hit)
**Output**:
```
Cache hit for: Linux-node-eab9f1a5...
Cache restored successfully
Run npm ci
```

**Result**:
- Cache restored from `~/.npm`.
- Dependencies not re-downloaded.
- 🚀 Tests run faster!

#WorkflowOptimization #CI/CD

---

## 🔍 How to Check Cache Status

In the GitHub Actions logs, look under the **Cache npm dependencies** step:
- ✅ **Cache hit**: Cache was reused, speeding up the build.
- ❌ **Cache not found**: A new cache was created.

#Debugging #Logs

---

## ✅ Final Output

After running tests:
```
Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        ~0.1s
```

**Benefits**:
- ✔️ Faster builds.
- ✔️ Reduced external API calls.
- ✔️ Smarter workflows.

#Efficiency #Automation

---

## 📚 What I Learned

- How to use `actions/cache@v4` to persist `~/.npm` or `node_modules` across jobs.
- Using the hash of `package-lock.json` for reliable cache keys.
- Caching significantly speeds up CI/CD pipelines.
- Debugging cache hits/misses in GitHub Actions logs.

#Learning #DevOpsJourney

---

## 🔗 My Work

- 📘 [GitHub Repo](https://github.com/ritesh355/matrix-demo)
- ✍️ [Hashnode Blog](https://ritesh-devops.hashnode.dev)
- 🔗 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340)

#Portfolio #Networking

---

## 🎉 Congratulations!

You’ve mastered **GitHub Actions caching** to optimize your CI/CD pipeline! Keep pushing the boundaries of your DevOps skills! 💪 #100DaysOfDevOps #KeepLearning

> **Need help?** Drop a comment or question, and I’ll guide you through any issues!
