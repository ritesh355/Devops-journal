# Project 4: Mounting an EBS Volume on EC2

## 🎯 Objective
Learn how to **attach, mount, and use an EBS volume** with an EC2 instance for persistent storage in AWS.

---

## 🛠️ AWS Services Used
- **EC2 (Elastic Compute Cloud)**: Instance to attach volume  
- **EBS (Elastic Block Store)**: Persistent block storage  
- **IAM**: Proper permissions for EC2 access  

---

## 📋 Steps

### 1. Create an EBS Volume
1. Go to **AWS Console → EC2 → Elastic Block Store → Volumes → Create Volume**
2. ![Create EBS Volume](https://cdn.hashnode.com/res/hashnode/image/upload/v1759417635503/4bf40ca5-547c-4cea-a239-ad112c5a5369.png?auto=compress,format&format=webp)

3. Choose **Volume type** (e.g., General Purpose SSD `gp3`)  
4. Set **Size** (e.g., 1 GB for testing)
5.  ![Attach Volume](https://cdn.hashnode.com/res/hashnode/image/upload/v1759417739275/e6aa388e-ec57-40c1-86b9-f2dcc6ace340.png?auto=compress,format&format=webp)

6. Select the **same Availability Zone** as your EC2 instance  
7. Click **Create Volume**  

**Screenshot: Create EBS Volume**  

---

### 2. Attach Volume to EC2
1. Select the volume → **Actions → Attach Volume**
2. ![Attach Volume](https://cdn.hashnode.com/res/hashnode/image/upload/v1759418050560/6e51bfb9-57ad-47b1-8af8-3748d1a55d07.png?auto=compress,format&format=webp)

3. Choose the **EC2 instance**  
4. Click **Attach**
5.   ![Attach Volume](https://cdn.hashnode.com/res/hashnode/image/upload/v1759418074291/b9c80494-a812-4b68-981a-bb8043c004f3.png?auto=compress,format&format=webp)




---

### 3. Connect to EC2 & Mount Volume
1. SSH into your EC2 instance:  
```bash
ssh -i mykey.pem ec2-user@<EC2-Public-IP>
```
![Attach Volume](https://cdn.hashnode.com/res/hashnode/image/upload/v1759418318015/1e9628c6-10df-43b1-a9c2-f0f6e2a93d83.png?auto=compress,format&format=webp)


2.  After ssh switch into root user
```
sudo su -
```
3.    List block devices to identify your new volume: 
```
df -h
```
or 
```
lsblk
```
4. Format the Volume (if needed)
Check if filesystem exists:

```
sudo file -s /dev/nvme1n1
```
If output shows data, format it:

```
sudo mkfs -t ext4 /dev/nvme1n1
```
***Note —> replace with your disk name like /dev/xvdf in my case it is not xvdf it is nvme1n1***

### 4. Mount the Volume


Create a mount point:

    sudo mkdir /mnt/myvolume
  
   
 Mount it:
 
    sudo mount /dev/nvme1n1 /mnt/myvolume
 
 Verify

    
    df -h 
    lsblk

---

    
 ![Attach Volume](https://cdn.hashnode.com/res/hashnode/image/upload/v1759419506610/7160c0f9-5438-429f-8f06-4e43d488d0ae.png?auto=compress,format&format=webp)
   
[visit](https://dev.to/ritesh355/mounting-an-ebs-volume-on-ec2-45n5)
    

    
    
    
    

    
 



