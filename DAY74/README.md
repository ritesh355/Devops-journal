#  Launch an EC2 Instance

## 🎯 Objective
Learn how to launch, configure, and connect to an Amazon EC2 instance.  
This project will give you hands-on experience with AWS compute services and basic networking.

---

## 🛠️ AWS Services Used
- **EC2 (Elastic Compute Cloud):** Virtual server hosting
- **IAM:** Secure access with least privilege
- **Security Groups:** Firewall rules
- **Key Pairs:** Secure SSH login

---

## 📋 Steps

---

### 1. Launch an EC2 Instance
1. Go to **EC2 Console .
![Bucket Creation](images/console.png)
---
2.  **write the name of server**.
![Bucket Creation](images/name.png)   
---
3. Choose **Amazon Linux 2 AMI (Free Tier Eligible)**.
4.  4. Select instance type: **t2.micro** (Free Tier).

   ![Bucket Creation](images/name.png)   
---
   
5. Create a new **Key Pair** →
      ![Bucket Creation](images/key.png)   
---
6. write the **key pair** name according to you
         ![Bucket Creation](images/keyname.png)   

8. Configure **Security Group**:
   - Allow **SSH (22)** from My IP
   - (Optional) Allow **HTTP (80)** for web access
      ![Bucket Creation](images/launch2.png)   

     
9. Launch instance.

---

### 3. Connect to Instance
1. go to the **ec2 server and connet**
         ![Bucket Creation](images/connect.png)

2. click on **sshclient**
      ![Bucket Creation](images/ssh.png)
 
 3. open you **laptop terminal** and set correct permissions for key:
    **note**-> make sure your key is in same directly

 ```bash
   chmod 400 awskey.pem
  ```
---
![Bucket Creation](images/copycommand.png)


 ![Bucket Creation](images/ec2connect.png)


---

## 4. Install Apache and Host a Web Page
 **Update packages:**

 ```bash
 sudo yum update -y
```

**Install Apache:**
```bash
sudo yum install -y httpd
```
---
 ![Bucket Creation](images/yum.png)


**Start service:**
```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```
**Create index.html:**
 ``` bash
echo "Hello from my EC2 instance 🚀" | sudo tee /var/www/html/index.html
```

 ![Bucket Creation](images/live.png)

**Open browser → http://<EC2-Public-IP> → You should see your page.**

 ![Bucket Creation](images/output.png)


 ---
 ## 📢 Connect With Me
- 💼 [LinkedIn](https://linkedin.com/in/ritesh-singh-092b84340)  
- 📝 [Hashnode Blog](https://ritesh-devops.hashnode.dev)  
- 💻 [GitHub](https://github.com/ritesh355)
   






