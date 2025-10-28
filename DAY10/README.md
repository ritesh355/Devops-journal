📘 Day10.md – SSH and Secure File Transfer

# 🔐 Day 10 – SSH, Key-Based Authentication, and Secure File Transfer

## ✅ What I Practiced Today

### 1. SSH Key Generation (as ritesh)

```bash
ssh-keygen -t rsa -b 4096 -C "ritesh@localhost"

    Chose the default path: /home/ritesh/.ssh/id_rsa

    Skipped the passphrase for automation-friendly access
```
###2. Public Key Transfer to Local User ravi
```bash
sudo mkdir -p /home/ravi/.ssh
sudo cp ~/.ssh/id_rsa.pub /home/ravi/.ssh/authorized_keys
sudo chown -R ravi:ravi /home/ravi/.ssh
sudo chmod 700 /home/ravi/.ssh
sudo chmod 600 /home/ravi/.ssh/authorized_keys
```
##✅ This enabled passwordless SSH login from ritesh to ravi.
###3. SSH Login Test
```bash
ssh ravi@localhost

Output:

Are you sure you want to continue connecting (yes/no)? yes
ravi@ritesh-pc:~$

Success! Logged in without needing ravi’s password.
```
###4. Secure File Transfer using scp

- Created a file as ritesh:
```bash
echo "This file will be copied to ravi." > hello.txt
```
- Transferred it to ravi's home:
```bash
scp hello.txt ravi@localhost:/home/ravi/
```
- Verified the file as ravi:
```bash
cat hello.txt
```
- Output:

This file will be copied to ravi.

##🧠 What I Learned

    SSH is essential for DevOps to manage servers securely.

    Key-based auth is preferred over password logins.

    scp enables encrypted file transfers between local or remote users.

    Correct file and folder permissions are key to making SSH work:

        .ssh must be 700

        authorized_keys must be 600

##📘 Next Steps

    Learn to configure ~/.ssh/config to simplify connections.

    Try SSH into a cloud server (AWS EC2).

    Practice rsync for efficient large file syncs.

 [Github](https://github.com/ritesh355/Devops-journal)
 [linkdin](https://www.linkedin.com/in/ritesh-singh-092b84340)
## for more detail
 [hashnode](https://ritesh-devops.hashnode.dev/)

