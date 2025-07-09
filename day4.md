

# 🔐 Day 4 – Linux User and Group Management

Today, I focused on mastering **Linux user and group management**, a critical skill for DevOps to secure systems and enable team collaboration.

---

## 👤 Creating and Managing Users

Create a new user `ravi` with a home directory and password:

```bash
sudo adduser ravi
sudo passwd ravi

    adduser: Creates the user ravi, a home directory, and default group.

    passwd: Sets or updates the user password.

🔁 Switching Users and Verifying Identity

Test user access and verify identity:

su - ravi
whoami
id

    su - ravi: Switches to the ravi user with login environment.

    whoami: Displays current user.

    id: Shows user ID and group membership.

🔐 Granting Sudo Access

Give ravi sudo privileges:

sudo usermod -aG sudo ravi

    usermod -aG sudo ravi: Adds ravi to the sudo group for administrative tasks.

👥 Working with Groups

Create a shared group and add ravi:

sudo groupadd devs
sudo usermod -aG devs ravi
groups ravi

    groupadd devs: Creates a new group devs.

    usermod -aG devs ravi: Adds user to the devs group.

    groups ravi: Lists all groups for ravi.

📂 Changing Group Ownership of Files/Folders

Assign group ownership to a file or directory:

sudo chgrp devs filename
sudo chgrp -R devs /home/ritesh/shared_folder

    chgrp devs: Changes the group ownership to devs.

    -R: Applies changes recursively.

📁 Creating a Shared Folder with Proper Permissions

Create a team-shared folder with permission control and group inheritance:

sudo mkdir /home/ritesh/shared_folder
sudo chgrp devs /home/ritesh/shared_folder
sudo chmod 770 /home/ritesh/shared_folder
sudo chmod g+s /home/ritesh/shared_folder

    chmod 770: Owner and group have full access; others have none.

    chmod g+s: Ensures all new files inherit the devs group automatically.

✅ What I Learned

    Creating users and assigning passwords.

    Granting sudo access using usermod.

    Creating and managing groups for collaborative environments.

    Modifying file/folder group ownership and permissions.

    Creating shared folders with inherited access rules.

📘 Commands Summary
Command	Purpose
adduser	Create a new user with a home directory
passwd	Set or change a user’s password
usermod -aG	Add a user to a group
groupadd	Create a new group
chgrp	Change group ownership of a file/folder
chmod	Set file or directory permissions
chmod g+s	Enable group inheritance on directories
🔗 Resources

    📘 GitHub Repo – ritesh355/devops-journal

    👨‍💼 LinkedIn – Ritesh Singh
