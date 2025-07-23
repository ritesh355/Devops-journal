# 🔁 Day 18 – Review + Lab Day | 100 Days of DevOps

Welcome to Day 18 of my [100 Days of DevOps](https://github.com/ritesh355/Devops-journal) journey!

Today was a **Review + Lab Day**, where I practiced everything I’ve learned so far about Git, Bash scripting, and Linux administration — all essential for upcoming projects.

---

## 🎯 Goals

- Reinforce Git basics, Bash scripting, and Linux commands  
- Complete mini-labs for each topic  
- Prepare for automation project (Day 19)

---

## 🧠 Topics Reviewed

| Area     | Topics                                   |
|----------|-------------------------------------------|
| Linux    | Permissions, users/groups, logs, journalctl |
| Git      | init, add, commit, branch, merge, push    |
| Bash     | Variables, loops, conditions, file ops     |

---

## 🧪 Lab Exercises

### ✅ Linux Lab

```bash
# File operations
mkdir lab_dir && cd lab_dir
touch file1.txt && chmod 640 file1.txt

# User management
sudo adduser devuser
sudo passwd devuser
sudo usermod -aG sudo devuser

# Logs
sudo tail -n 50 /var/log/syslog
journalctl -xe

---
### ✅ Git Lab
# Init and commit
mkdir git-lab && cd git-lab
git init
echo "# Git Lab" > README.md
git add . && git commit -m "Initial commit"

# Branching and merging
git checkout -b dev
echo "New line" >> README.md
git add . && git commit -m "Dev update"
git checkout main
git merge dev

---

### ✅ Bash Lab

# Basic script
echo -e '#!/bin/bash\necho "Hello, $USER. Today is $(date)."' > hello.sh
chmod +x hello.sh
./hello.sh

# Logic script
cat <<EOF > check_even.sh
#!/bin/bash
read -p "Enter a number: " num
if (( num % 2 == 0 )); then
  echo "\$num is even"
else
  echo "\$num is odd"
fi
EOF
chmod +x check_even.sh
./check_even.sh

---


###🎯 Bonus Challenge

Build a script that:

    Initializes a Git repo

    Creates a branch

    Adds a file and commits

    Pushes it (for Day 19 foundation)
---

###✅ Summary

✅ Reviewed Linux, Git, Bash
✅ Completed 7+ real-world lab tasks
✅ Ready for Day 19’s automation project!

---


[GitHub Journal](https://github.com/ritesh355/Devops-journal)
[📝 Hashnode Blog](https://ritesh-devops.hashnode.dev)

---

  #linux #git #github #bash #  shellscript #devops






