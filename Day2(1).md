# 🚀 Day 2 of My DevOps Journey – File Permissions, Ownership, and First GitHub Push

## ✅ 1. Learn chmod (permissions)
`chmod` stands for Change Mode — used to modify permissions (read, write, execute) of files and directories.

### Linux Permissions Basics:
- **User (u)** – file owner
- **Group (g)** – group assigned to the file
- **Others (o)** – everyone else

### Permission Types:
- **r** – read (4)
- **w** – write (2)
- **x** – execute (1)

### Syntax:
```bash
chmod [permissions] [file]
```

### Examples:
```bash
chmod +x myscript.sh       # Add execute permission for everyone
chmod u+x myscript.sh      # Execute for user only
chmod 755 myscript.sh      # rwxr-xr-x (user/group/others)
```

### Try it:
```bash
touch test.sh
chmod +x test.sh
ls -l test.sh
chmod 644 test.sh
ls -l test.sh
```

---

## ✅ 2. Learn chown (ownership)
`chown` is used to change the **owner** and/or **group** of a file.

### Syntax:
```bash
chown user file
chown user:group file
```

### Examples:
```bash
sudo chown ritesh myfile.txt
sudo chown ritesh:devops myfile.txt
sudo chown -R ritesh:devops myfolder/
```

### Try it:
```bash
touch sample.txt
sudo adduser testuser
sudo chown testuser sample.txt
```

---

## ✅ 3. Practice with Fake Users
Understand how different users interact with file permissions.

### Commands:
```bash
sudo adduser devuser
su - devuser
whoami
id
exit
touch ownerfile.txt
chmod 700 ownerfile.txt
su - devuser
cat /home/ritesh/ownerfile.txt
sudo chown devuser ownerfile.txt
```

---

## ✅ 4. Group and Permission Experiments

### Commands:
```bash
groups
sudo groupadd devops
sudo usermod -aG devops devuser
groups devuser
touch groupfile.txt
sudo chgrp devops groupfile.txt
chmod 770 groupfile.txt
su - devuser
cat /home/ritesh/groupfile.txt
umask
umask 007
touch newfile.txt
ls -l newfile.txt
```

---

## ✅ 5. Permissions Lab

### Setup:
```bash
sudo adduser alice
sudo adduser bob
mkdir /home/ritesh/shared_folder
sudo groupadd team
sudo usermod -aG team alice
sudo usermod -aG team bob
sudo chgrp team /home/ritesh/shared_folder
chmod 770 /home/ritesh/shared_folder
chmod g+s /home/ritesh/shared_folder
```

### Test Access:
```bash
su - alice
cd /home/ritesh/shared_folder
touch file_by_alice.txt
exit

su - bob
cd /home/ritesh/shared_folder
ls -l
echo "Hi Alice" >> file_by_alice.txt
```

---

## ✅ Summary:
All commands, permission effects, and user access tests are now clear. Permissions management is a core DevOps skill I now understand practically.
