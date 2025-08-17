# 📘 Day 43: DNS, DHCP, NAT & Firewall Basics  

Welcome to **Day 43** of my Networking & Security journey! 🚀 
Today, I explored four core networking concepts that power the internet and practiced **firewall configuration** hands-on. 

---

## 🌍 1. DNS (Domain Name System)  

- **Definition:** DNS translates **human-readable domain names** (e.g., `google.com`) into **IP addresses** (e.g., `142.250.182.78`) so computers can communicate.  
- **How it works:**  
  1. You type `example.com` in a browser.  
  2. A DNS resolver queries a DNS server.  
  3. The server responds with the correct IP address.  
  4. Your browser connects to that IP.  

🔑 **Types of DNS Records:**  
- **A Record:** Maps a domain → IPv4 address.  
- **AAAA Record:** Maps a domain → IPv6 address.  
- **CNAME:** Alias for another domain.  
- **MX Record:** Mail exchange (used for email).  

💡 **Analogy:** Think of DNS as the *phonebook of the internet*.  

---

## 📡 2. DHCP (Dynamic Host Configuration Protocol)  

- **Definition:** A network protocol that **automatically assigns IP addresses** and other network settings to devices.  
- **Why it’s needed:** Without DHCP, every device would need to be manually configured.  
- **How it works (DORA Process):**  
  1. **Discover** → Client broadcasts to find DHCP server.  
  2. **Offer** → DHCP server replies with an available IP.  
  3. **Request** → Client requests the offered IP.  
  4. **Acknowledge** → DHCP server confirms the assignment.  

💡 **Analogy:** Imagine entering a parking lot where the guard (DHCP server) assigns you an empty parking spot (IP address).  

---

## 🌐 3. NAT (Network Address Translation)  

- **Definition:** NAT allows multiple devices in a private network (e.g., `192.168.x.x`) to share a **single public IP** when accessing the internet.  
- **Types of NAT:**  
  - **Static NAT:** One private ↔ One public IP.  
  - **Dynamic NAT:** Many private ↔ Many public IPs (from a pool).  
  - **PAT (Port Address Translation):** Many private ↔ One public IP (most common, e.g., your home Wi-Fi).  

💡 **Real-life Example:** Your home Wi-Fi has multiple devices, but the ISP sees only one **public IP**.  

---

## 🔥 4. Firewalls  

A **firewall** is a security system that monitors and controls **incoming and outgoing traffic** based on defined rules.  

- **Types of Firewalls:**  
  - **Hardware Firewall:** Dedicated device (e.g., routers with firewall).  
  - **Software Firewall:** Installed on operating systems (Linux `ufw`, `iptables`).  

💡 **Analogy:** Think of a firewall as a **security guard** who checks ID cards before letting people (packets) enter a building (network).  

---

## 🛠 Hands-on Practice  

### Using `ufw` (Uncomplicated Firewall)  

```bash
# Enable UFW
sudo ufw enable

# Check status
sudo ufw status verbose

# Allow SSH (port 22)
sudo ufw allow 22

# Allow HTTP (port 80)
sudo ufw allow 80/tcp

# Deny a specific port (e.g., 23 - Telnet)
sudo ufw deny 23

# Delete a rule
sudo ufw delete allow 80/tcp

```

###Using iptables (Advanced Firewall Rules)

# View existing rules
sudo iptables -L -v

# Allow incoming HTTP traffic (port 80)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Block incoming traffic from a specific IP
sudo iptables -A INPUT -s 192.168.1.100 -j DROP

# Allow SSH from a specific subnet
sudo iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT

# Drop all incoming connections by default
sudo iptables -P INPUT DROP

# Save iptables rules (Debian/Ubuntu)
sudo sh -c "iptables-save > /etc/iptables/rules.v4"
#️⃣ Hashtags:
#100DaysOfDevOps #Networking #Security #Linux #CloudComputing #Firewalls #DNS #DHCP #NAT



