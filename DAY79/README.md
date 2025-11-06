 
## 🚀 Jenkins CI/CD Pipeline with Docker & Node.js

This project demonstrates a **Jenkins CI/CD pipeline** running on **AWS EC2**, which builds and deploys a simple **Node.js app** inside a **Docker container**, and pushes the image to **Docker Hub**.

## 📌 Features

* Node.js sample app (`Hello from Jenkins CI/CD + Docker + Node.js!`)
* Jenkins pipeline using **Jenkinsfile**
* Automated build & deployment with Docker
* Push Docker images to Docker Hub
* GitHub Webhook integration for auto builds

---
## 🛠️ Tech Stack

* **Node.js** – Application
* **Docker** – Containerization
* **Jenkins** – CI/CD pipeline
* **AWS EC2** – Jenkins & Docker host
* **Docker Hub** – Image registry
* **GitHub** – Source code repository

---

## First Setting Up Jenkins on an AWS EC2 Instance

This guide provides step-by-step instructions to launch an AWS EC2 instance, install Jenkins, and access the Jenkins server. Follow these steps to set up a Jenkins server using Amazon Linux 2 on a `t2.micro` instance.

## Prerequisites
- An AWS account with appropriate permissions.
- Basic knowledge of SSH and terminal commands.
- A web browser to access the Jenkins dashboard.

---

## Step 1: Log in to an AWS Account
1. Navigate to the [AWS Management Console](https://aws.amazon.com/console/).
2. Log in with your AWS credentials (username, password, and MFA if enabled).
3. In the AWS Console, locate the **EC2** service under the "Compute" section or use the search bar to find "EC2."
4. Click **EC2** to access the EC2 Dashboard.

---

## Step 2: Navigate to EC2 Dashboard
1. In the EC2 Dashboard, select **Instances** from the left-hand menu.
2. Click **Launch instances** to start creating a new EC2 instance.
3.
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gs62rvn8g73sag7mpmfy.png) 


---

## Step 3: Launch Instance
1. In the "Launch an instance" wizard, configure the following:
   - **Name**: Enter `my_jenkins_server`.
   - **Number of instances**: Set to `1`.
   - **Amazon Machine Image (AMI)**: Choose **Amazon Linux 2 AMI (HVM), SSD Volume Type** (select the latest version available in your region).
   - **Architecture**: Select **64-bit (x86)**.
2. Proceed to configure instance details.

---

## Step 4: Configure Instance
1. **Instance Type**: Select **t2.micro** (Free Tier eligible, 1 vCPU, 1 GiB memory).
2. **Key Pair**:
   - If you have an existing key pair, select it from the dropdown.
   - If not, click **Create new key pair**, name it (e.g., `jenkins-key`), choose **RSA** and **.pem** format, and download the key pair. Store it securely.
3. Leave default settings for storage unless specific requirements exist.
4. Proceed to configure network settings.
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c8m1gv07qz9ohzrybhje.png) 


---

## Step 5: Configure Network Security Groups
1. In the **Network settings** section:
   - Choose **Create security group** or select an existing one.
   - Add the following inbound rules:
     - **Type**: HTTP, **Protocol**: TCP, **Port Range**: 8080, **Source**: Anywhere (0.0.0.0/0) for Jenkins web access.
     - **Type**: SSH, **Protocol**: TCP, **Port Range**: 22, **Source**: Your IP or Anywhere (0.0.0.0/0) for SSH access.
   - **Security Note**: Allowing all traffic (0.0.0.0/0) for all ports is insecure. For production, restrict SSH to your IP and limit other traffic.
2. Ensure port 8080 (Jenkins) and port 22 (SSH) are open.

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4nspab1r6mgbkgdia8kl.png) 


---

## Step 6: Review and Launch Instance
1. Review the configuration (instance type, AMI, key pair, security group).
2. Click **Launch instance** to provision the instance.
3. Note the instance ID from the confirmation message.

---

## Step 7: Connect to EC2 Instance
1. In the EC2 Dashboard, go to **Instances** and wait for the instance to reach the **Running** state (verify "Status Checks" pass).
2. Select the instance (`my_jenkins_server`) and click **Connect**.


![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ado85fgrrl2aqp0isyrg.png) 

4. In the **Connect to instance** window, select the **SSH client** tab.

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/b17qtb59rjbnm6p18o02.png)

6. Use the provided SSH command, e.g.:
   ```bash
   ssh -i "jenkins-key.pem" ec2-user@<Public_IP_or_DNS>

   ```
   
    



![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c6so9lfzgovtxlcn9pti.png)
  -   Replace <Public_IP_or_DNS> with the instance’s public IP or DNS (found in instance details).
  - Ensure the .pem file permissions are restricted:

## Step 8: Install Jenkins 
1. Connect to the instance via SSH, then run:
  
 - Update
 ```
sudo apt update -y
```
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3xojmetr08peag0luz5y.png)

  


 - Install Java (Jenkins needs Java)
 ```
sudo apt install openjdk-17-jdk -y
```
 
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rgjmfo70ychncqnr6dur.png)

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zlos0gqj54n6dfgb2h9j.png)

   


- Add Jenkins repository
  
 ```
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

- Install Jenkins
sudo apt update -y
sudo apt install jenkins -y
```
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/m4ygb3h7xqelrzg6wol5.png)

  ---
  

-  Start Jenkins

```
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
👉 Jenkins runs on http://<EC2-Public-IP>:8080

---
## Step 9: Configure Jenkins
1. Open browser → http://<EC2-Public-IP>:8080
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pqu5juignp4l8nrw7n3f.png)


2. Get initial password:

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/cofxxt7qpiytr722z15m.png)

3. Paste password in Jenkins UI.


4. Install suggested plugins.

    
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/krunx1jp30v1n93jdws1.png)
     
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/if6jng4z031y45osrr8k.png)


6. Create admin user.

  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3lt3c32gh49ach9erajp.png)

7. instance configuration

   
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i28ruf3g8o4e64zhrcpy.png)

8. jenkins is ready now
      
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hpt00z5ac9mvbjfmmeig.png)

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3de5pfdrf26dubvsaq43.png)
   
  

 

  ---
## Step 5: Install Docker on EC2
```
sudo apt install docker.io -y

```
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qcfi2cbq3ma94ln2ce2g.png)

  👉 Restart Jenkins so it can use Docker:

  ``` 
sudo usermod -aG docker jenkins
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl restart jenkins
```
  
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/eob7f6564kub2gqj8y18.png)


  ---
  ##  Create a GitHub Repository
  ### Folder structure 
 ```
Docker-Jenkins-app/
│-- app.js
│-- package.json
│-- Dockerfile
│-- Jenkinsfile
│-- README.md
```


---
## Configure Jenkins Pipeline
- Push your Docker-Jenkins-app repo to GitHub.
- In Jenkins UI:
  - New Item → Name: docker-pipeline-ec2 → Select Pipeline
      
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/oni14l3j32s5qzntet7d.png)

  - In Pipeline → Select Pipeline script from SCM
      
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1wq63vjxkvenlzcmkuaa.png)

  - SCM: Git

  - Repo URL: https://github.com/ritesh355/Docker-Jenkins-app.git
  - Branch: main
      
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ikpb3jvqipe9qgptk1uv.png)

   ---
   
## Setup GitHub Webhook
1. Go to your repo → Settings → Webhooks → Add webhook. 
        
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8yg97rr75dd2ubjeqi0t.png)

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/0urn2xc99kbk00x84qpr.png)



2. Payload URL:
```
http://<EC2-Public-IP>:8080/github-webhook/
```

3. Content type: application/json
4. Event: Just the push event
         
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9537svh1t7nlaqvbxyme.png)

5. save
   
---

## Add Docker Hub Credentials in Jenkins
Open Jenkins Dashboard → Manage Jenkins → Credentials.
         
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/excippfeijz8q750ny1f.png)

Click System → Global credentials (unrestricted) → Add Credentials.
         
          
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ep05zuxrmmimg8gh72m8.png)

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tln8fqxc90ap7c43bswj.png)


Select Kind = Username with password.
           
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tjxi2hn5zim8r1ysqv9p.png)

 - Username = Your Docker Hub username

- Password = Your Docker Hub password or personal access token
   how to create docker hub tokens
             
![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ez01dfs2d8aejo4fqyuw.png)

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/srs5abg65yenz7crc0iz.png)

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/z2id27d6r689hrendgih.png)
               




- ID = dockerhub-creds (you will use this ID in Jenkinsfile)

- Description = Docker Hub Credentials

   

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2q8xakz5ycyw3h2xytah.png)

  
---


## Test
1. Commit & push a small change to your repo (e.g., update app.js message).
2. GitHub → Sends webhook → Jenkins job auto-triggers.
3. Jenkins builds Docker image + runs container on EC2 And push the image into the docker hub
      ![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/s83u3rte450leo821eib.png)


![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8tx21zzvlzjmeln9fxyr.png)
     

5. Access app at:
```
http://<EC2-Public-IP>:4000
```

5. ✅ Now you’ll have a fully automated CI/CD pipeline on EC2 with webhooks.


## 📢 Follow My Journey
 
[github](https://github.com/ritesh355)

[linkdin](https://www.linkedin.com/in/ritesh-singh-092b84340/)
