# 📝 DevOps Linux Permissions Cheatsheet
# Linux File Permissions, Ownership, and User Management

## chmod - Change Permissions
- chmod +x file
- chmod u+x file
- chmod 755 file

## chown - Change Ownership
- chown user file
- chown user:group file
- chown -R user:group dir/

## User Management
- adduser username
- su - username
- whoami
- id

## Group Management
- groupadd groupname
- usermod -aG groupname user
- groups username
- chgrp groupname file.txt

## umask - Default Permissions
- umask
- umask 007

## Permission Reference Table

| Symbolic | Numeric | Description             |
|----------|---------|-------------------------|
| rwx------ | 700     | Owner full              |
| rwxr-xr-x | 755     | Owner full, others read |
| rw-rw---- | 660     | Owner & group RW        |
| rw-r--r-- | 644     | Owner write, others R   |

