🔐 Day 4 – Linux User and Group Management

Today, I focused on mastering Linux user and group management, a critical skill for DevOps to secure systems and enable team collaboration.



👤 Creating and Managing Users

To create a new user named ravi with a home directory and set their password:

sudo adduser ravi
sudo passwd ravi

These commands create the user ravi, set their password, and automatically configure a home directory and default user group.



🔁 Switching Users and Verifying Identity

To switch to the user ravi and verify their identity:

su - ravi
whoami
id





su - ravi: Switches to the ravi user with their environment.



whoami: Displays the current user.



id: Shows user and group associations for ravi.

This is useful for testing login functionality and confirming user setup.



🔐 Granting Sudo Access

To allow ravi to run administrative commands with sudo:

sudo usermod -aG sudo ravi

The -aG flag appends ravi to the sudo group, enabling secure administrative tasks without modifying existing group memberships.



👥 Working with Groups

To create a shared group for team collaboration and add ravi to it:

sudo groupadd devs
sudo usermod -aG devs ravi
groups ravi





groupadd devs: Creates a new group named devs.



usermod -aG devs ravi: Adds ravi to the devs group.



groups ravi: Lists all groups ravi belongs to.

This setup is ideal for managing permissions for multiple users in a team.



📂 Changing Group Ownership of Files/Folders

To assign group ownership to files or directories:

sudo chgrp devs filename
sudo chgrp -R devs /home/ritesh/shared_folder





chgrp devs filename: Changes the group ownership of a specific file to devs.



-R: Applies the group change recursively to directories and their contents.



📁 Creating a Shared Folder with Proper Permissions

To create a shared folder accessible only to the owner and group, with group inheritance for new files:

sudo mkdir /home/ritesh/shared_folder
sudo chgrp devs /home/ritesh/shared_folder
sudo chmod 770 /home/ritesh/shared_folder
sudo chmod g+s /home/ritesh/shared_folder

This ensures:





770 permissions: Only the owner and devs group members have read/write/execute access; others have none.



g+s (setgid): New files in the folder inherit the devs group, ensuring consistent group ownership.



✅ What I Learned





How to create and manage users with adduser and set passwords with passwd.



Adding users to groups using usermod -aG for role-based access control.



Granting sudo access for administrative tasks.



Managing file and folder permissions with chgrp and chmod.



Setting up shared team folders with proper access control and group inheritance.



📘 Commands Summary







Command



Purpose





adduser



Create a new user with home directory





passwd



Set or change a user’s password





usermod -aG



Add a user to a group





groupadd



Create a new group





chgrp



Change group ownership of a file/directory





chmod



Set file or directory permissions





chmod g+s



Enable group inheritance on directories



🔗 Resources





GitHub Repo: ritesh355/devops-journal



LinkedIn: ritesh-singh-092b84340
