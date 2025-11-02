# 🚀 Day 45: VPNs, SSH, SFTP, and Bastion Hosts

This guide introduces key network access tools and patterns essential for Cloud/DevOps engineers: **VPNs**, **SSH**, **SFTP**, and **Bastion Hosts**. The hands-on focus is on setting up **SSH key-based authentication** securely on an Ubuntu system, a critical skill for managing production environments. Each section includes explanations, practical examples, and cloud-specific considerations.

---

## 🔎 Why This Matters

As a Cloud/DevOps engineer, you'll use these tools daily to securely manage remote servers and networks:

- **VPNs**: Securely connect remote clients or sites to private networks.
- **SSH**: The standard for secure remote shell access to Linux servers.
- **SFTP**: A secure file transfer protocol leveraging SSH, safer than plain FTP.
- **Bastion Hosts**: Hardened gateways for accessing private servers, centralizing security and auditing.
- **SSH Key-Based Authentication**: A secure, password-free method for authentication, widely used in production.

This guide provides a conceptual overview and a detailed, hands-on setup for SSH key-based authentication.

---

## 1. VPNs: Conceptual Summary

### What is a VPN?
A **Virtual Private Network (VPN)** creates an encrypted tunnel to connect:
- **Client-to-Site**: Remote users (e.g., admins) to a private network.
- **Site-to-Site**: Branch offices or cloud VPCs to a central network.

### Why Use VPNs?
- Access private servers without public IPs.
- Secure data transmission over untrusted networks (e.g., public Wi-Fi).
- Common in cloud environments (e.g., AWS VPN, Azure VPN Gateway, Google Cloud VPN).

### Popular Protocols/Tools
- **IPSec**: Traditional, widely supported, used in enterprise VPNs.
- **OpenVPN**: Flexible, open-source, cross-platform.
- **WireGuard**: Modern, lightweight, high-performance (gaining popularity in cloud setups).

### Cloud Context
Cloud providers offer managed VPN services (e.g., AWS Site-to-Site VPN, Azure VPN Gateway). For example, you can configure a WireGuard VPN to connect on-premises networks to a VPC or between VPCs for secure communication.

**Note**: No VPN setup is required for this hands-on guide. Understand that a VPN places your client inside the private network, enabling SSH access to private servers.

---

## 2. SSH: Secure Shell Overview

### What is SSH?
**Secure Shell (SSH)** is a protocol for secure remote command execution, port forwarding, and file transfers. It’s the de-facto standard for managing Linux servers.

### Key Features
- **Strong Encryption**: Protects data in transit.
- **Public Key Authentication**: Secure, password-free login (covered in detail below).
- **Port Forwarding/Tunnels**: Securely forward traffic through SSH.
- **File Transfers**: Supports SCP and SFTP for secure file transfers.
- **SSH Agent**: Manages keys for seamless authentication.
- **Default Port**: TCP 22 (can be changed for obscurity, not security).

### Why Use SSH?
- Securely manage servers in cloud environments (e.g., EC2, Azure VMs).
- Automate tasks via scripts or CI/CD pipelines.
- Enable secure file transfers and tunneling.

---

## 3. SFTP and SCP: Secure File Transfers

### SFTP (SSH File Transfer Protocol)
- **What**: A secure, interactive, or scripted file transfer protocol over SSH.
- **Why**: Safer than FTP, leveraging SSH’s encryption and authentication.
- **Example Commands**:
  - Interactive mode:
    ```bash
    sftp user@host
    sftp> put localfile.txt /remote/path/
    sftp> get /remote/path/remotefile.txt .
    sftp> ls
    sftp> cd /remote/path
    ```
  - Batch mode (non-interactive):
    ```bash
    echo "put localfile.txt /remote/path/" > batchfile
    sftp -b batchfile user@host
    ```

### SCP (Secure Copy)
- **What**: A simpler tool for copying files over SSH.
- **Example Commands**:
  - Copy a file:
    ```bash
    scp localfile.txt user@host:/remote/path/
    ```
  - Copy a directory:
    ```bash
    scp -r localdir user@host:/remote/path/
    ```

### rsync over SSH
- **What**: A powerful tool for efficient file synchronization over SSH.
- **Example**:
  ```bash
  rsync -avz -e "ssh -i ~/.ssh/id_rsa" localdir/ user@host:/remote/path/
  ```
- **Why**: Faster than SCP for large datasets due to incremental transfers.

**Note**: SFTP and SCP use the same SSH key-based authentication configured below.

---

## 4. Bastion Hosts: Secure Gateways

### What is a Bastion Host?
A **bastion host** (or jump host) is a hardened server with a public IP that acts as a gateway to access private servers in a network. It centralizes access and minimizes the attack surface.

### Why Use a Bastion Host?
- Private servers have no public IPs, reducing exposure to the internet.
- Centralizes auditing and access control.
- Common in cloud environments (e.g., AWS, Azure, GCP).

### Secure Pattern
- **Security Groups** (Cloud Context):
  - Bastion Security Group: Allow SSH (port 22) from admin IPs only.
  - Private Server Security Group: Allow SSH (port 22) only from the Bastion’s Security Group.
- **Access Pattern**:
  Use `ProxyJump` or `ProxyCommand` to connect through the bastion to private servers:
  ```bash
  ssh -J user@bastion_host user@private_server
  ```

### Example SSH Config
Simplify bastion access by adding to `~/.ssh/config`:
```bash
Host bastion
    HostName bastion_public_ip
    User user
    IdentityFile ~/.ssh/id_rsa

Host private_server
    HostName private_server_ip
    User user
    IdentityFile ~/.ssh/id_rsa
    ProxyJump bastion
```
Then connect with:
```bash
ssh private_server
```

**Security Note**: Avoid SSH agent forwarding (`-A`) due to risks (e.g., key exposure on compromised bastions). Use `ProxyJump` or cloud-native solutions like AWS SSM Session Manager instead.

---

## 5. Hands-On: SSH Key-Based Authentication Setup

SSH key-based authentication replaces passwords with a cryptographic key pair, offering stronger security and automation-friendly access. Below is a step-by-step guide to set up SSH key-based authentication on an Ubuntu client and server.

### Prerequisites
- Client: Ubuntu/macOS/Windows with OpenSSH (or PuTTY for Windows).
- Server: Ubuntu with OpenSSH server (`sudo apt install openssh-server`).
- Network access: Client can reach the server (via VPN or public IP).
- User credentials: A user account on the server with password access (initially).

### Step 1: Generate SSH Key Pair on the Client
1. Open a terminal on the client.
2. Generate an RSA key pair:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   - `-t rsa`: Uses RSA algorithm.
   - `-b 4096`: Sets 4096-bit key length for security.
   - `-C`: Adds a comment (e.g., your email for identification).
3. Accept the default file location (`~/.ssh/id_rsa`) by pressing Enter.
4. Set a passphrase (recommended for security) or press Enter for none.
5. Output files:
   - Private key: `~/.ssh/id_rsa`
   - Public key: `~/.ssh/id_rsa.pub`

**Example Output**:
```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/user/.ssh/id_rsa
Your public key has been saved in /home/user/.ssh/id_rsa.pub
```

### Step 2: Copy the Public Key to the Server
1. Verify SSH access to the server with a password:
   ```bash
   ssh user@remote_server_ip
   ```
2. Use `ssh-copy-id` to copy the public key:
   ```bash
   ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote_server_ip
   ```
   - Enter the server’s password when prompted.
   - This appends the public key to `~/.ssh/authorized_keys` on the server.
3. **Manual Alternative** (if `ssh-copy-id` is unavailable):
   - Display the public key:
     ```bash
     cat ~/.ssh/id_rsa.pub
     ```
     Example output:
     ```bash
     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD... your_email@example.com
     ```
   - SSH to the server and append the key:
     ```bash
     ssh user@remote_server_ip
     mkdir -p ~/.ssh
     echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD... your_email@example.com" >> ~/.ssh/authorized_keys
     chmod 600 ~/.ssh/authorized_keys
     chmod 700 ~/.ssh
     ```

### Step 3: Test SSH Key-Based Authentication
1. From the client, SSH to the server:
   ```bash
   ssh user@remote_server_ip
   ```
2. If a passphrase was set, enter it. You should log in without the server’s password.
3. If login fails, troubleshoot:
   - Verify the public key in `~/.ssh/authorized_keys`.
   - Check permissions: `chmod 700 ~/.ssh`, `chmod 600 ~/.ssh/authorized_keys`.
   - Ensure `PubkeyAuthentication yes` in `/etc/ssh/sshd_config` on the server.
   - Restart the SSH service: `sudo systemctl restart sshd`.

### Step 4: Enhance Security (Optional)
- **Disable Password Authentication**:
  Edit `/etc/ssh/sshd_config`:
  ```bash
  sudo nano /etc/ssh/sshd_config
  ```
  Set:
  ```bash
  PasswordAuthentication no
  PubkeyAuthentication yes
  ```
  Restart SSH:
  ```bash
  sudo systemctl restart sshd
  ```
- **Restrict Key Usage**:
  Add restrictions to `~/.ssh/authorized_keys`:
  ```bash
  from="client_ip",no-port-forwarding ssh-rsa AAAAB3NzaC... your_email@example.com
  ```
  - `from="client_ip"`: Restricts key usage to specific client IPs.
  - `no-port-forwarding`: Disables SSH tunneling.

### Step 5: Use SSH Agent (Optional)
To avoid entering the passphrase repeatedly:
1. Start the SSH agent:
   ```bash
   eval "$(ssh-agent -s)"
   ```
2. Add the private key:
   ```bash
   ssh-add ~/.ssh/id_rsa
   ```
   Enter the passphrase when prompted. Subsequent SSH/SFTP connections won’t require it until the agent stops.

### Step 6: Test with SFTP and Bastion Host
- **SFTP**:
  ```bash
  sftp user@remote_server_ip
  sftp> put localfile.txt /remote/path/
  ```
- **Bastion Host**:
  Use the SSH config from Section 4 or:
  ```bash
  ssh -J user@bastion_host user@private_server_ip
  ```

---

## Security Best Practices
1. **Use Strong Keys**: Prefer RSA 4096-bit or Ed25519 keys.
2. **Protect Private Keys**:
   - Use a passphrase.
   - Set permissions: `chmod 600 ~/.ssh/id_rsa`.
   - Never share or copy private keys.
3. **Restrict Access**:
   - Limit SSH access to specific IPs via Security Groups or `from` in `authorized_keys`.
   - Use bastion hosts for private servers.
4. **Rotate Keys**: Generate new keys periodically and remove old ones.
5. **Monitor Logs**: Check `/var/log/auth.log` or `/var/log/secure` for unauthorized attempts.
6. **Use Cloud-Native Tools**: For cloud environments, consider AWS SSM Session Manager or Azure Bastion for managed access.

---

## Troubleshooting
- **Permission Denied (publickey)**:
  - Verify `~/.ssh/authorized_keys` contains the correct public key.
  - Check permissions: `chmod 700 ~/.ssh`, `chmod 600 ~/.ssh/authorized_keys`.
  - Ensure `PubkeyAuthentication yes` in `/etc/ssh/sshd_config`.
- **Connection Refused**:
  - Check SSH service: `sudo systemctl status sshd`.
  - Verify firewall rules: `sudo ufw allow 22`.
- **Passphrase Prompted Repeatedly**:
  - Use `ssh-agent` (Step 5).
  - Verify `IdentityFile` in `~/.ssh/config` if used.

---

## Cloud-Specific Notes
- **AWS EC2**:
  - Use Security Groups to restrict SSH access.
  - Store private keys securely (e.g., AWS Secrets Manager).
  - Consider AWS SSM Session Manager for passwordless, audited access.
- **Azure/GCP**:
  - Configure Network Security Groups (NSGs) or Firewall Rules to allow SSH only from trusted IPs or bastions.
  - Use managed bastion services (e.g., Azure Bastion).
- **VPN Integration**:
  - Ensure your client is connected to the VPN to access private servers.
  - Example: AWS Client VPN or WireGuard for VPC access.

---

## Additional Resources
- [OpenSSH Manual](https://www.openssh.com/manual.html)
- [Ubuntu SSH Guide](https://help.ubuntu.com/community/SSH/OpenSSH/Keys)
- [AWS EC2 SSH Setup](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
- [WireGuard VPN Guide](https://www.wireguard.com/)

For further assistance, consult your cloud provider’s documentation or system administrator.

---

## 👨‍💻 Author
**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GitHub](https://github.com/ritesh355/Devops-journal)

#100DaysOfDevOps #CICD #GitHubActions #DevOps #Beginner
#100DaysOfDevOps #Networking #Security #Linux #CloudComputing #Firewalls #DNS #DHCP #NAT


