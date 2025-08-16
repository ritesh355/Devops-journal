# 🚀 Day 42: OSI & TCP/IP Models in Practice

Today I explored two fundamental networking models that every DevOps & Cloud Engineer must understand:
- **OSI (Open Systems Interconnection) Model**
- **TCP/IP (Transmission Control Protocol / Internet Protocol) Model**

Along with theory, I also practiced important hands-on networking commands.

## 🧠 Conceptual Understanding

### 🔹 OSI Model – 7 Layers
1. **Physical Layer** → Deals with hardware, cables, signals, binary transmission.
2. **Data Link Layer** → Ensures error-free delivery between nodes (MAC addresses, switches).
3. **Network Layer** → Handles logical addressing & routing (IP addresses, routers).
4. **Transport Layer** → Ensures reliable delivery (TCP/UDP, ports).
5. **Session Layer** → Manages communication sessions.
6. **Presentation Layer** → Data formatting, encryption, compression.
7. **Application Layer** → End-user interaction (HTTP, FTP, DNS).

### 🔹 TCP/IP Model – 4 Layers
1. **Link Layer** → Physical + Data Link (Ethernet, Wi-Fi).
2. **Internet Layer** → Network (IP, ICMP).
3. **Transport Layer** → TCP, UDP.
4. **Application Layer** → HTTP, DNS, SSH, etc.

📌 **Key Difference:**
- OSI is a **theoretical reference model**.
- TCP/IP is **practical & widely used on the internet**.

## 🛠️ Hands-on Practice

I used common Linux networking tools to connect theory with practice:

### 1️⃣ `ping` – Check connectivity
```bash
ping google.com
```
- Sends ICMP echo requests.
- Helps verify if a host is reachable.

### 2️⃣ `traceroute` – Track packet path
```bash
traceroute google.com
```
- Shows all intermediate hops between source & destination.
- Useful to troubleshoot latency & routing issues.

### 3️⃣ `netstat` – Network statistics
```bash
netstat -tulnp
```
- Displays open ports, listening services, and connections.

### 4️⃣ `ss` – Modern alternative to netstat
```bash
ss -tulnp
```
- Faster and more detailed than netstat.

### 5️⃣ `nmap` – Network mapper
```bash
nmap -sV localhost
```
- Scans open ports & identifies services running.
- Used for security auditing.

## 🔎 Reflection
- The OSI/TCP-IP models gave me a structured way to think about networking.
- The hands-on commands showed me how to observe real traffic on my machine.
- Now I understand how theory maps to practical tools in DevOps & Cloud.

## 👨‍💻 Author
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GitHub](https://github.com/ritesh355/Devops-journal)

#100DaysOfDevOps #CICD #GitHubActions #DevOps #Beginner #networking #OSI #TCP/IP

