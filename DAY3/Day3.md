 # 🚀 Day 3 of My DevOps Journey – Linux Process Management & System Monitoring

## 👋 Recap & Focus

Today’s goal was to understand how Linux handles processes and how to monitor system resources. I learned how to start, stop, observe, and manage processes using tools like `ps`, `top`, `htop`, and more.

I also practiced running CPU-intensive processes in the background and saw how to manage them using `jobs`, `fg`, `bg`, and `kill`. This is core to DevOps work when dealing with real-world servers and services.

---

## ✅ Step 1: Viewing Running Processes

I started by exploring how to view all active processes:

```bash
ps aux          # See all processes
top             # Live process monitor
htop            # (installed with sudo apt install htop)
```

- `ps aux` gave me a static snapshot.
- `top` and `htop` helped me monitor CPU and memory usage in real time.

---

## ✅ Step 2: Killing Processes

I tested how to terminate processes using:

```bash
kill <PID>        # Kill by Process ID
pkill <name>      # Kill by process name
killall <name>    # Kill all instances of a process
```

### ❌ Where I Got Stuck

At one point, I ran:
```bash
ps aux | grep firefox
kill 8535
```
But it returned:
```
bash: kill: (8535) - No such process
```
🔍 I realized I was trying to kill the **grep** command itself, not Firefox! The correct way was to look for the real Firefox PID (not the `grep` line) or use `pgrep firefox`.

---

## ✅ Step 3: Background & Foreground Jobs

I used `sleep` and `yes` to test background processes:

```bash
sleep 300 &
jobs
fg %1
bg %1
kill %1
```

### ❌ What Tripped Me Up

After running multiple `sleep 300 &`, I had jobs [1] and [2]. When I ran `fg %1`, it said:

```
bash: fg: job has terminated
```
Then `kill %1` gave:
```
no such job
```

✔️ The reason? That sleep process already ended before I could bring it to foreground or kill it.

---

## ✅ Step 4: System Info Commands

I used the following to get memory, CPU, and disk stats:

```bash
df -h          # Disk space
free -m        # RAM usage
uptime         # Load average and uptime
hostname       # Hostname
uname -a       # Kernel info
```

📊 These commands will be very useful later when monitoring cloud VMs or CI/CD agents.

---

## ✅ Step 5: Run & Monitor a CPU-Heavy Process

I ran:

```bash
yes > /dev/null &
```

This command runs a loop printing "y" forever, using almost 100% CPU.

### 🔍 Observation:
Using `top`, I saw it quickly jumped to the top of the process list.

```bash
pkill yes     # To kill it quickly
```

✅ I also learned to kill individual PIDs using `kill <PID>` and confirm with `pgrep yes`.

---

## ✅ Where I Got Stuck Again

When I tried this:

```bash
kill yes
```

It failed with: 
```
bash: kill: yes: arguments must be process or job IDs
```

✔️ I fixed it by using either `pkill yes` or `kill <PID>` after finding the process with `ps aux | grep yes`.

---

## ✅ Sleep Duration Confusion

I tested with different sleep times :

```bash
sleep 300 &     # 5 minutes (300 sec)
sleep 9000 &    # 2.5 hours (9000 sec)
sleep 9999 &    # 2 hours 46 min (9999 sec)
```

✔️ All work the same — just different durations. Great way to simulate long-running background processes.

---

## 📘 Final Commands Reference

| Command       | Description                        |
|---------------|------------------------------------|
| `ps aux`      | List all running processes         |
| `top`, `htop` | Live CPU/memory monitor            |
| `kill <PID>`  | Kill a specific process            |
| `pkill name`  | Kill process by name               |
| `jobs`        | Show background jobs               |
| `fg`, `bg`    | Bring to foreground/background     |
| `df -h`       | Disk usage                         |
| `free -m`     | RAM usage                          |
| `uptime`      | Load average & uptime              |
| `uname -a`    | Kernel and system info             |

---

## 📦 GitHub Repo

📍 [DevOps Journal – Day3.md](https://github.com/ritesh355/Devops-journal/edit/main/Day3.md)

---

## 🧠 Reflection

> “Today I learned how to observe, control, and kill processes — and how real Linux systems behave under pressure. It felt like looking under the hood of the operating system.”

---

## 🙌 Let's Connect

- 💼 [LinkedIn](https://linkedin.com/in/ritesh-singh-092b84340)
- 💻 [GitHub](https://github.com/ritesh355)

---

#devops #linux #processmanagement #100DaysOfDevOps #learninginpublic #top #kill #htop
