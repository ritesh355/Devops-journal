# 📘 Day 6 Cheatsheet – Bash Automation Script

## 🎯 Goal:
Automate a system health report using Bash scripting, including disk usage, memory, CPU, users, and IP.

---

## 🛠 Commands Used:

| Command | Purpose |
|--------|---------|
| `date` | Show current date and time |
| `uptime` | Show system uptime |
| `df -h` | Display disk usage in human-readable format |
| `free -h` | Show memory usage |
| `ps aux --sort=-%cpu \| head -n 6` | Top 5 CPU-heavy processes |
| `ps aux --sort=-%mem \| head -n 6` | Top 5 memory-heavy processes |
| `who` | List currently logged-in users |
| `hostname -I` | Show IP address(es) of the system |

---

## 🧠 Concepts Practiced:

- Shebang: `#!/bin/bash`
- Variables: (used for report sections)
- Output formatting: `echo`, line separators
- System monitoring commands
- Permissions: `chmod +x automation.sh`
- Script execution: `./automation.sh`

---

## ✅ Sample Output (snippet):

```
📅 Date and Time: Thu Jul 11 18:00:22 IST 2025
🔄 System Uptime:
 18:00:22 up  2:01,  2 users,  load average: 0.58, 0.47, 0.35
💽 Disk Usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   10G   37G  22% /
...
```

---

## 🔄 How to Run the Script

```bash
chmod +x automation.sh
./automation.sh
```

---
## make sure you are in currect folder when run this script
