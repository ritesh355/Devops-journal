---

# 🚀 Day 25: Docker Multi-Stage Builds – Explained with a TypeScript Node.js App

Welcome to Day 25 of your DevOps journey! Today, we’re mastering **Docker Multi-Stage Builds** by building a clean and efficient image for a TypeScript-based Node.js app.

---

## 🔍 What are Multi-Stage Builds?

Multi-stage builds let you use multiple `FROM` statements in a Dockerfile, enabling you to separate the build environment from the production environment.

### 🎯 Benefits:

- ✅ Smaller image size
- ✅ Clean, secure production environment
- ✅ Efficient dependency management

---

## 📁 Project Structure

```
node-ts-app/
├── src/
│   └── index.ts
├── package.json
├── tsconfig.json
├── Dockerfile
```

---

## 🛠 Step-by-Step Breakdown

### 1️⃣ Create Your Project Directory

```bash
mkdir node-ts-app
cd node-ts-app
```

### 2️⃣ Create `package.json`

```bash
vim package.json
```

Paste this content:

```json
{
  "name": "node-ts-app",
  "version": "1.0.0",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {},
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

### 3️⃣ Create `tsconfig.json`

```bash
vim tsconfig.json
```

Paste this content:

```json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "CommonJS",
    "outDir": "dist",
    "strict": true
  },
  "include": ["src/**/*"]
}
```

### 4️⃣ Create `src/` folder and `index.ts`

```bash
mkdir src
cd src
vim index.ts
```

Paste this code:

```ts
console.log("🚀 Hello from TypeScript inside Docker!");
```

### 5️⃣ Go back to root and create `Dockerfile`

```bash
cd ..
vim Dockerfile
```

Paste this Dockerfile with multi-stage build:

```Dockerfile
# --------- Stage 1: Build Stage ----------
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# --------- Stage 2: Production Stage ----------
FROM node:18-slim

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY package*.json ./

RUN npm install --only=production

CMD ["node", "dist/index.js"]
```

### 6️⃣ Build the Docker Image

```bash
docker build -t node-ts-multistage .
```

### 7️⃣ Run the Docker Container

```bash
docker run --rm node-ts-multistage
```

✅ You should see:

```
🚀 Hello from TypeScript inside Docker!
```

---

## 📌 Final Outcome

- 🎯 TypeScript gets compiled in build stage
- 🎯 Only compiled JS and production deps go in final image
- 🎯 Clean, minimal, production-ready container

---

## 🧠 DevOps Takeaway

You don’t need to write the code—but you should understand how to:

| Task                    | Why It Matters                          |
| ----------------------- | --------------------------------------- |
| Identify the build tool | Helps configure Docker builds correctly |
| Understand the CMD      | Runs the app inside container           |
| Optimize Dockerfiles    | Creates small, secure images            |

---

✅ You just mastered **Multi-Stage Builds** with real-world Docker workflow!

Next up? We’ll deploy this optimized container to the cloud! ☁️
