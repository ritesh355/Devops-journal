# 🚀 Day 15 of My DevOps Journey: Network Configuration and Troubleshooting in Linux


Today was all about understanding how to troubleshoot network issues in Linux. I dove into useful commands like `ping`, `ss`, `nmap`, and `curl` to simulate real-world problems and resolve them step-by-step.

---

## 🧪 Practice Lab: Network Troubleshooting (Step-by-Step)

### 🛠️ Objective:
Learn how to **simulate a network issue** and use **Linux networking commands** to **diagnose and fix** it.

---

### ✅ 1. Turn Off Wi-Fi

```bash
nmcli radio wifi off
```
> OR disable it using the Wi-Fi icon in your system GUI.

---

### ✅ 2. Check Internet Connectivity (Fail Expected)

```bash
ping 8.8.8.8
```

**Expected Output:**
```
ping: connect: Network is unreachable
```

---

### ✅ 3. Turn Wi-Fi Back On

```bash
nmcli radio wifi on
```

---

### ✅ 4. Check Internet Connectivity Again

```bash
curl ifconfig.me
```

**Expected Output:**
```
Your public IP address (e.g., 103.87.46.5)
```

---

### ✅ 5. Check if SSH is Running

```bash
ss -tuln | grep :22
```

**Expected Output:**
```
LISTEN 0 128 0.0.0.0:22 0.0.0.0:*  
```

---

### ✅ 6. Scan for Open Ports

```bash
nmap 127.0.0.1
```

**Expected Output:**
```
PORT     STATE SERVICE
22/tcp   open  ssh
631/tcp  open  ipp
```

---

## 💡 Takeaways

| Step | Skill Practiced |
|------|------------------|
| Wi-Fi control | Managing network state |
| ping | Checking connectivity |
| curl | Verifying internet access |
| ss | Checking running services |
| nmap | Scanning local ports |

---

## 🔚 Summary

- Learned key Linux network commands
- Simulated connection loss and recovery
- Practiced troubleshooting SSH and port access

---

🔗 **Connect With Me**
- 🧑‍💼 [LinkedIn](https://linkedin.com/in/ritesh-singh-092b84340)
- 💻 [GitHub](https://github.com/ritesh355)

