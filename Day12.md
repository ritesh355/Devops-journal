
# ⚙️ Day 12 – Systemd and Linux Services

Welcome to Day 11 of my [100 Days of DevOps](https://github.com/ritesh355/Devops-journal) journey!  
Today, I explored how to manage services in Linux using `systemd`. This is a crucial skill for maintaining and deploying applications in production environments.

---

## 🧠 What is `systemd`?

`systemd` is the modern init system for most Linux distributions. It handles:
- Boot process
- Background services (daemons)
- Logging with `journald`
- Resource control and service dependencies

---

## 🔧 Common Commands

| Task | Command |
|------|---------|
| Check service status | `systemctl status nginx` |
| Start a service | `sudo systemctl start nginx` |
| Stop a service | `sudo systemctl stop nginx` |
| Restart a service | `sudo systemctl restart nginx` |
| Enable on boot | `sudo systemctl enable nginx` |
| Disable on boot | `sudo systemctl disable nginx` |
| Reload daemon configs | `sudo systemctl daemon-reload` |

---

## 🛠️ Real Example: Custom Background App with `systemd`

## code 
- [myapp](https://github.com/ritesh355/myapp)

### ✅ Step 1: Create a Simple Script

```bash
mkdir -p ~/myapp
nano ~/myapp/app.sh
```

Paste:
```bash
#!/bin/bash
while true; do
  echo "$(date) - My custom app is running..." >> /home/ritesh/myapp/app.log
  sleep 10
done
```

Make it executable:
```bash
chmod +x ~/myapp/app.sh
```

---

### ✅ Step 2: Create a Systemd Unit File

```bash
sudo nano /etc/systemd/system/myapp.service
```

Paste:
```ini
[Unit]
Description=My Custom App Service
After=network.target

[Service]
ExecStart=/home/ritesh/myapp/app.sh
Restart=always
User=ritesh

[Install]
WantedBy=multi-user.target
```

---

### ✅ Step 3: Start and Enable the Service

```bash
sudo systemctl daemon-reload
sudo systemctl start myapp.service
sudo systemctl enable myapp.service
```

---

### 🔍 Step 4: Check Logs and Status

```bash
systemctl status myapp.service
journalctl -u myapp.service -f
tail -f ~/myapp/app.log
```

---

### ❌ Step 5: Stop and Clean Up

```bash
sudo systemctl stop myapp.service
sudo systemctl disable myapp.service
sudo rm /etc/systemd/system/myapp.service
sudo systemctl daemon-reload
```

---

## 📌 Summary

✅ Learned `systemd` and unit file structure  
✅ Created a persistent, restartable custom service  
✅ Managed logs and service status with `journalctl` and `systemctl`  
✅ Prepared for production-level Linux service management

---

📚 References:
- [Systemd Cheat Sheet](https://www.freedesktop.org/software/systemd/man/systemctl.html)
- [Understanding systemd Units](https://wiki.archlinux.org/title/systemd)
- [Journalctl Guide](https://man7.org/linux/man-pages/man1/journalctl.1.html)

---

🔗 **GitHub Repo:** [DevOps Journal](https://github.com/ritesh355/Devops-journal)  
✍️ **Hashnode Blog:** [Day 11 – Systemd and Linux Services](https://ritesh-devops.hashnode.dev)
