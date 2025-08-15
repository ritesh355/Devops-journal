# 📅 Day 41 – Networking Basics (Cloud & DevOps Foundations)

Welcome to **Day 41** of our journey to master **Cloud & DevOps**!  
Today we dive deep into **Networking**, the backbone of every cloud infrastructure and DevOps pipeline.

---

## 🌐 What is Networking?
Networking is the practice of connecting computers, servers, and other devices so they can **communicate** and **share resources** over a network (like the internet or local network).

In Cloud & DevOps, networking is **essential** because:
- All cloud services interact via network protocols.
- CI/CD pipelines communicate with servers.
- Applications depend on APIs, DNS, and IP addresses.

---

## 📌 Key Networking Concepts for Beginners

### 1. **IP Address**
- A **unique identifier** for a device on a network.
- **IPv4 Example**: `192.168.1.1`
- **IPv6 Example**: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`
- Types:
  - **Public IP** → Accessible from the internet.
  - **Private IP** → Used inside private networks.

---

### 2. **MAC Address**
- Physical address assigned to your network interface card.
- Example: `00:1A:2B:3C:4D:5E`
- Used for identifying devices on a local network.

---

### 3. **Ports**
- Virtual doors through which data enters and leaves.
- Example:  
  - **Port 80** → HTTP (Web traffic)  
  - **Port 443** → HTTPS (Secure web traffic)

---

### 4. **Protocols**
- Rules for communication between devices.
- Examples:
  - **HTTP/HTTPS** → Web communication
  - **FTP/SFTP** → File transfer
  - **SMTP** → Email
  - **SSH** → Secure remote login

---

### 5. **DNS (Domain Name System)**
- Converts human-readable names into IP addresses.
- Example:
  - `www.google.com` → `142.250.190.46`

---

### 6. **Ping & Latency**
- **Ping** → Test if a device is reachable.
- **Latency** → Time it takes for data to travel.

---

### 7. **Subnetting**
- Dividing a network into smaller networks for efficiency and security.
- Example: `192.168.1.0/24`

---

## 🛠 Hands-On Commands (Linux/Ubuntu)

```bash
# Check your IP address
ip addr show

# Check internet connectivity
ping google.com

# Display DNS resolution
nslookup google.com

# Display routing table
route -n

# Display active connections and listening ports
netstat -tulnp

```
---

### 🔗 Connect with Me

- 📘 [GitHub: ritesh355](https://github.com/ritesh355)
- ✍️ [Hashnode: ritesh-devops.hashnode.dev](https://ritesh-devops.hashnode.dev)
- 💼 [LinkedIn: ritesh-singh-092b84340](https://www.linkedin.com/in/ritesh-singh-092b84340)



Built as part of a 40-day Containers & Automation journey. Let’s containerize the world! 🚢
