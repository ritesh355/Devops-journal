# 🐚 Day 5 – Bash Scripting (Beginner to Advanced)

Today I explored Bash scripting in depth — an essential DevOps skill for automating tasks, configuring environments, and building tools.

---

## 🧠 What is a Bash Script?

A Bash script is a plain text file that contains a series of Linux commands.  
It helps you automate repetitive tasks like backups, monitoring, deployments, etc.

---

## ✅ Step 1: Create and Run Your First Script

```bash
touch hello.sh
chmod +x hello.sh
```

Inside `hello.sh`:

```bash
#!/bin/bash
echo "Hello, DevOps World!"
```

Run it:

```bash
./hello.sh
```

---

## ✅ Step 2: Use Variables

```bash
#!/bin/bash
name="ritesh"
echo "Welcome, $name!"
```

---

## ✅ Step 3: Read User Input

```bash
#!/bin/bash
echo "Enter your name:"
read name
echo "Hello, $name!"
```

---

## ✅ Step 4: If/Else Statements

```bash
#!/bin/bash
echo "Enter a number:"
read num
if [ "$num" -gt 10 ]; then
  echo "Greater than 10"
else
  echo "10 or less"
fi
```

---

## ✅ Step 5: Loops in Bash

### For Loop

```bash
for i in 1 2 3 4 5
do
  echo "Counting: $i"
done
```

### While Loop

```bash
i=1
while [ $i -le 5 ]
do
  echo "Step $i"
  ((i++))
done
```

---

## ✅ Step 6: Functions

```bash
greet() {
  echo "Hi $1, welcome to scripting!"
}
greet ritesh
```

---

## ✅ Step 7: Script Arguments

```bash
#!/bin/bash
echo "Script name: $0"
echo "First arg: $1"
```

Run with:

```bash
./myscript.sh hello
```

---

## ✅ Step 8: Error Handling and Exit Codes

```bash
mkdir /tmp/myfolder || {
  echo "Failed to create folder"
  exit 1
}
```

---

## 🔧 Mini Project Ideas

| Script | Description |
|--------|-------------|
| `user-check.sh` | Check if a Linux user exists |
| `disk-check.sh` | Warn if disk usage > 80% |
| `backup.sh` | Backup a folder into .tar.gz |

---

## 📘 Summary

Today I learned:
- How to create and run Bash scripts
- How to use variables, conditions, loops, and functions
- How to accept input and arguments
- How to use exit codes and write reusable scripts

✅ I’m now confident automating Linux tasks using shell scripts — and will start creating small tools for daily use!

---

🔗 GitHub Journal: [https://github.com/ritesh355/devops-journal](https://github.com/ritesh355/devops-journal)  
🔗 LinkedIn: [https://linkedin.com/in/ritesh-singh-092b84340](https://linkedin.com/in/ritesh-singh-092b84340)
