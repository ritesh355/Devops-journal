
# 💻 Day 14 – Log Management and Rotation

Welcome to Day 14 of my [100 Days of DevOps](https://github.com/ritesh355/Devops-journal) journey!  
Today I explored **log management** and **log rotation** — an essential DevOps skill for system stability, debugging, auditing, and monitoring.

---

## 📂 What Are Logs in Linux?

Logs are system-generated messages that record everything from boot information, user actions, process statuses, and service errors.

🗂️ Common Linux log files:
| Log File | Purpose |
|----------|---------|
| `/var/log/syslog` | General system activity logs |
| `/var/log/auth.log` | Authentication (login, sudo) logs |
| `/var/log/kern.log` | Kernel-related messages |
| `/var/log/dmesg` | Boot & hardware events |
| `/var/log/cron.log` | Scheduled job logs (if enabled) |

👀 View logs using:
```bash
sudo tail -f /var/log/syslog
sudo journalctl -u ssh.service
grep "error" /var/log/auth.log
```

---

## 🔁 Why Log Rotation Matters

Without rotation, log files can grow indefinitely and consume disk space.  
Log rotation helps by:
- Archiving old logs
- Compressing them to save space
- Automatically deleting older ones
- Keeping systems clean and readable

---

## 🔧 Tool: `logrotate`

Most Linux systems use [`logrotate`](https://linux.die.net/man/8/logrotate) to automate log rotation.

📌 Default config:
- Global: `/etc/logrotate.conf`
- Per-app: `/etc/logrotate.d/`

---

## 📐 My Custom Log Rotation Setup

### ✅ 1. Simulate a Log File
```bash
mkdir -p ~/logs
echo "Log started at $(date)" > ~/logs/myapp.log
```

Then simulate appending:
```bash
nohup bash -c 'while true; do echo "$(date): app log entry" >> ~/logs/myapp.log; sleep 2; done' &
```

---

### 📝 2. Create Logrotate Config

Create a file:
```bash
sudo nano /etc/logrotate.d/myapp
```

Paste:
```conf
/home/ritesh/logs/myapp.log {
    daily
    rotate 5
    compress
    missingok
    notifempty
    create 644 ritesh ritesh
    su ritesh ritesh
}
```

📌 Explanation:
- `daily`: rotate once per day
- `rotate 5`: keep 5 old logs
- `compress`: gzip old logs
- `create`: re-create log after rotation
- `su`: run rotation as my user

---

### 🧪 3. Test It

📌 Dry run:
```bash
sudo logrotate -d /etc/logrotate.d/myapp
```

📌 Force rotation:
```bash
sudo logrotate -f /etc/logrotate.d/myapp
```

📁 Result:
```bash
ls -lh ~/logs/
# myapp.log         -> current log file
# myapp.log.1.gz    -> rotated & compressed
```

---

## 🧠 Extras

🧹 Clean old systemd journal logs:
```bash
sudo journalctl --vacuum-time=2weeks
```

🧰 Useful tools:
- [`journalctl`](https://man7.org/linux/man-pages/man1/journalctl.1.html)
- [`logwatch`](https://sourceforge.net/projects/logwatch/)
- [`GoAccess`](https://goaccess.io/) – web log analyzer
- [`ELK Stack`](https://www.elastic.co/what-is/elk-stack) – advanced log management

---

## 📌 Key Learnings

✅ Understood core Linux logs and their importance  
✅ Learned how to manage logs using `logrotate`  
✅ Created a real-time rotating app log  
✅ Prepared for production-grade log hygiene

---

📚 References:
- [Linux Log Files – The Ultimate Guide](https://www.loggly.com/ultimate-guide/linux-logs/)
- [Logrotate Man Page](https://linux.die.net/man/8/logrotate)
- [Journalctl Cheatsheet](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546)

---

🔗 **Hashnode Blog:** [Day 14 – Log Management and Rotation](https://ritesh-devops.hashnode.dev)  
📘 **GitHub Repo:** [DevOps Journal](https://github.com/ritesh355/Devops-journal)

---

✍️ Next: [Day 15 – Networking Basics](https://github.com/ritesh355/Devops-journal)
