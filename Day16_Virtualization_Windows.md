
# 💻 Day 16 – Intro to Virtualization on Windows using VirtualBox | 100 Days of DevOps

Welcome to Day 16 of my [100 Days of DevOps](https://github.com/ritesh355/Devops-journal) journey!

Today, I learned how to create virtual machines using **VirtualBox** on **Windows** — a critical skill for testing DevOps tools, creating isolated environments, and running multiple OSs safely.

---

## 🧠 What is Virtualization?

**Virtualization** allows you to run multiple OS environments (called virtual machines) on a single physical machine by abstracting hardware resources.
### 🧾 Key Terms
| Term                     | Explanation                                               |
| ------------------------ | --------------------------------------------------------- |
| **Hypervisor**           | Software that manages VMs (e.g., VirtualBox, VMware, KVM) |
| **Host OS**              | The physical machine's operating system                   |
| **Guest OS**             | The virtual machine's operating system                    |
| **VM (Virtual Machine)** | A simulated computer inside another computer              |
| **Snapshots**            | Saved states of a VM to roll back if needed               |


## 🧠 What is a Virtual Machine (VM)?

A **Virtual Machine (VM)** is a simulated computer running inside your actual computer (called the **host**).  
It has its own virtual CPU, RAM, storage, and OS, all managed by a **hypervisor** like VirtualBox.

---

## ✅ Step-by-Step Guide: Create Your First VM on Windows

### 1. Install VirtualBox on Windows

- 🔗 Download from: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- Install the version for **Windows hosts**
- (Optional) Install the **Extension Pack** for better device support

---

### 2. Download a Guest OS ISO

Choose your virtual OS:

- **Ubuntu Desktop ISO**: [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop)
- **Ubuntu Server ISO (lighter)**: [https://ubuntu.com/download/server](https://ubuntu.com/download/server)

Save it in your `Downloads` folder.

---

### 3. Create a New Virtual Machine

1. Open VirtualBox → Click **New**
2. Name: `DevOpsLab`
3. Type: `Linux`
4. Version: `Ubuntu (64-bit)`
5. Assign 2048 MB (2 GB) RAM
6. Create a **VDI disk**, dynamically allocated (20 GB recommended)

---

### 4. Boot the VM and Install Ubuntu

1. Select the VM → Click **Start**
2. Browse and select your `.iso` file
3. Install Ubuntu just like you would on a real machine
4. Set username, password, and timezone
5. Reboot once done

---

### 5. Update & Install DevOps Tools

Once Ubuntu is running:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git curl vim docker.io
```

You now have a fully working Linux lab inside Windows!

---

### 6. Optional: Enable Clipboard and Guest Additions

To improve your experience:
- Go to **Devices > Insert Guest Additions CD Image**
- Follow the on-screen instructions to install

---

## 📚 Key Terms

| Term         | Description                              |
|--------------|------------------------------------------|
| Host OS      | Your main OS (Windows in this case)      |
| Guest OS     | The OS inside the VM (e.g., Ubuntu)      |
| Hypervisor   | Software that manages VMs (e.g., VirtualBox) |
| VM Snapshot  | Save point to restore system state       |

---

## 🔗 Useful Links

- 🔗 VirtualBox: [https://www.virtualbox.org/](https://www.virtualbox.org/)
- 🔗 Ubuntu ISO: [https://ubuntu.com/download](https://ubuntu.com/download)
- 🔗 VirtualBox Manual: [https://www.virtualbox.org/manual/](https://www.virtualbox.org/manual/)

---

## ✅ Summary

✅ Installed VirtualBox on Windows  
✅ Created a new VM with Ubuntu  
✅ Installed DevOps tools in an isolated test lab  
✅ Learned key concepts of host, guest, hypervisor, and snapshots

---

📘 GitHub Repo: [DevOps Journal](https://github.com/ritesh355/Devops-journal)  
📝 Hashnode Blog: [ritesh-devops.hashnode.dev](https://ritesh-devops.hashnode.dev)
