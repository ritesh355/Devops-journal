# ⏰ Day 13: Cron Jobs and Scheduling Tasks

Welcome to Day 12 of my **#100DaysOfDevOps** journey!  
Today I explored how to **automate repetitive tasks in Linux** using **cron jobs**, a fundamental skill for any DevOps engineer. 🛠️

---

## 📌 What is a Cron Job?

A **cron job** is a time-based job scheduler in Unix-like systems that allows users to run scripts or commands at scheduled times and intervals.

---

## 🧠 Key Concepts

- **crontab**: Command-line tool to manage cron jobs
- **Cron expression**: The schedule format used to specify timing
- **cron daemon (crond)**: Background service that triggers jobs

---

## 🧮 Cron Syntax (5 Fields)

```bash
* * * * * command_to_execute
│ │ │ │ │
│ │ │ │ └─── Day of the week (0 - 6) (Sunday=0)
│ │ │ └───── Month (1 - 12)
│ │ └─────── Day of the month (1 - 31)
│ └───────── Hour (0 - 23)
└─────────── Minute (0 - 59)
---

##🔧 Examples
###✅ Run a script every day at 5 PM:

```bash
0 17 * * * /home/ritesh/scripts/backup.sh
```
###✅ Run a command every minute:

```bash
* * * * * echo "Hello from cron!" >> /home/ritesh/cron.log
```

### Compress old logs daily at 2 AM
```bash
0 2 * * * /home/ritesh/cron-job-projects/clean-logs.sh
```
### Backup DevOps journal daily at 8 PM

```bash
0 20 * * * /home/ritesh/cron-job-projects/backup-devops.sh
```
### Log uptime every hour

```bash
0 * * * * /home/ritesh/cron-job-projects/log-uptime.sh
```
### Auto git push every 30 minutes
```bash
*/30 * * * * /home/ritesh/cron-job-projects/auto-git-push.sh
```
---

## 📋 Crontab Commands

| Command      | Description             |
| ------------ | ----------------------- |
| `crontab -e` | Edit user's cron jobs   |
| `crontab -l` | List current cron jobs  |
| `crontab -r` | Remove user's cron jobs |

---

### ✅ Real-Life Use Cases

   - Automated backups

   - Sending reminders or alerts

   - Log file rotation

   - System cleanup tasks

   - Scheduled syncs or updates
---   


# My all project 

📂 GitHub Repo:[project link](https://github.com/ritesh355/cron-job-projects)

## 🔒 Permissions & Logs

   ### Cron logs can be viewed with:
```bash
cat /var/log/syslog | grep CRON
```
(Use sudo if needed.)

   - Make sure your script is executable:
```bash
chmod +x script.sh
```
🧠 What I Learned

    How to write cron expressions

    How to schedule tasks at different intervals

    Debugging cron jobs using log files

    Making scripts cron-compatible

🔗 My Work
## 🔗 My Work

📂 GitHub Repo: [DevOps Journal](https://github.com/ritesh355/Devops-journal)  
✍️ Blog Post: [Hashnode DevOps Blog](https://ritesh-devops.hashnode.dev)  
🔗 LinkedIn: [Ritesh Singh](https://www.linkedin.com/in/ritesh-singh-092b84340/)

---

💬 Final Thoughts

Cron is simple yet powerful — a must-have in your DevOps toolkit!
I now feel confident scheduling tasks to run automatically on any Linux system.

#100DaysOfDevOps #Linux #Cron #Automation #Bash #DevOpsTools
