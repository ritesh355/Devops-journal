# 🚀 Day 1 of My DevOps Journey – From Terminal Noob to First HTML Deployment

## 👋 Why I’m Starting This Journey

Hi, I’m Ritesh — and today I officially started my DevOps learning journey.  
I’ve committed to studying DevOps full-time (8–10 hours daily), and I’m sharing it **publicly** through Hashnode, GitHub, and LinkedIn to stay consistent, help others, and attract real opportunities.

---

## 🧠 What I Learned Today

Today I focused on getting comfortable with the **Linux terminal** and basic commands that form the foundation of everything in DevOps.

### 🔧 Commands I Practiced:
- `cd`, `ls`, `pwd`, `mkdir`, `rm`, `rmdir`
- `touch` vs `echo` (how they create files differently)
- `cat`, `head`, `tail` to read files
- `chmod`, `chown` to control file permissions
- Created a folder structure for my DevOps journey

---

## 💻 Mini Project: My First HTML Page

I created a simple `index.html` file manually using `echo`, then served it using Python’s built-in web server — all from the Linux terminal.

### Code:
```bash
mkdir devops_day1
cd devops_day1

cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
  <title>DevOps Day 1</title>
</head>
<body>
  <h1>Hello from DevOps!</h1>
  <p>This page was served using Python3 and built using echo commands in Linux.</p>
</body>
</html>
EOF

python3 -m http.server
```

I then opened `http://localhost:8000` in my browser — and boom 💥, my first DevOps-powered webpage was live!

---

## 🔍 Key Differences I Learned:

| `touch` | `echo` |
|--------|--------|
| Creates an empty file | Creates a file **with content** |
| Example: `touch file.txt` | Example: `echo "Hello" > file.txt` |

---

## 🔥 Highlights:
- Setup my Linux terminal workspace
- Practiced 20+ commands
- Wrote & served my own HTML page
- Understood file redirection (`>`, `>>`)
- Felt the **power of CLI automation**

---

## 🔮 What’s Next (Day 2 Plan):

- Deep dive into **Linux file permissions**  
- Start using **Git & GitHub**  
- Push my first repository  
- Begin solving **OverTheWire Bandit wargame**

---

## 🧠 Reflection

> “The terminal used to scare me. Now I realize it's just the most honest way to talk to a computer.”

This is just Day 1, but I already feel like I’ve taken the first real step toward becoming a DevOps Engineer.

---

## 📸 Screenshots (optional)
*You can add a screenshot of your terminal or HTML page here.*

---

## 📦 Project Repository

📍 [GitHub Repo – devops_day1](https://github.com/yourusername/devops_day1)

---

Thanks for reading! If you’re also learning DevOps or want to follow my journey, connect with me:

- [LinkedIn](https://linkedin.com/in/ritesh-singh-092b84340)  
- [GitHub](https://github.com/ritesh355)

Let’s grow together! 🔥  
#devops #linux #100daysofdevops #learninginpublic #selftaught #beginners
