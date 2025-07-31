---

# 📅 Day 26: Dockerfile + Docker Compose (Node.js + MongoDB)

Today, I worked on building a **Node.js + MongoDB** project using Docker and Docker Compose. This task helped me understand how to containerize applications efficiently and link services together.

---

## 🗂️ Project Structure

```
node-mongo-app/
├── app/
│   ├── server.js
│   └── ...other files
├── Dockerfile
├── docker-compose.yml
├── package.json
```

---

## 🛠️ Step 1: Dockerfile (Multi-stage)

```Dockerfile
# Base stage
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install --production

# Copy source code
COPY ./app ./app
WORKDIR /app/app

# Final image
EXPOSE 3000
CMD ["node", "server.js"]
```

### 🔍 Explanation

- **Stage 1:** Use `node:18-alpine` for a small image.
- **Install dependencies:** `npm install --production` installs only needed modules.
- **COPY:** Transfers app files to image.
- **EXPOSE:** Documents port 3000.
- **CMD:** Starts the app.

---

## 🐳 Step 2: `docker-compose.yml`

```yaml
version: '3.8'

services:
  web:
    build: .
    container_name: node-mongo-app_web_1
    ports:
      - "3000:3000"
    depends_on:
      - mongo
    environment:
      - MONGO_URL=mongodb://mongo:27017/mydb

  mongo:
    image: mongo:6.0
    container_name: node-mongo-app_mongo_1
    volumes:
      - mongo-data:/data/db
    ports:
      - "27017:27017"

volumes:
  mongo-data:
```

### 🔍 Explanation

- **web:** Builds from Dockerfile, connects to MongoDB.
- **mongo:** Uses MongoDB 6.0 and mounts a volume.
- **depends\_on:** Ensures MongoDB starts first.

---

## 📦 `package.json`

```json
{
  "name": "node-mongo-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.6.1"
  }
}
```

---

## 📄 `app/server.js`

```javascript
const express = require('express');
const mongoose = require('mongoose');
const app = express();

const PORT = 3000;
const MONGO_URL = process.env.MONGO_URL || 'mongodb://localhost:27017/mydb';

mongoose.connect(MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('MongoDB Connected'))
.catch((err) => console.error('Mongo Error:', err));

app.get('/', (req, res) => {
  res.send('Hello from Node + Mongo App in Docker!');
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

---

## ▶️ Commands I Practiced

### Build and Run

```bash
docker-compose up --build
```

### Stop and Remove Containers

```bash
docker-compose down
```

### List All Containers

```bash
docker ps -a
```

### Start Containers in Background

```bash
docker-compose up -d
```

### Rebuild Containers

```bash
docker-compose up --build
```

---

## 🧠 Learnings & Observations

- Learned how to use multi-stage builds in Docker.
- Understood how services communicate within Docker networks.
- Practiced common Docker Compose commands.
- Managed persistent MongoDB data using volumes.

---

## 🔗 Connect With Me

- 🌐 [GitHub](https://github.com/ritesh355/Devops-journal)
- ✍️ [Hashnode](https://ritesh-devops.hashnode.dev)
- 💼 [LinkedIn](https://linkedin.com/in/ritesh-singh-092b84340)

---

## 📸 Optional: Add Screenshot

Add a screenshot of the running app (localhost:3000) or terminal logs from `docker-compose up`.

---

✅ End of Day 26. A solid foundation in Docker Compose! Ready for deploying complex stacks! 🚀

