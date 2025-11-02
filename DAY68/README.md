# Day 68: Ansible Inventory & Ad-hoc Commands

## Introduction

Welcome to Day 68 of my DevOps learning journey! Today, we’re exploring **Ansible Inventory** and **Ad-hoc Commands**, critical components for automating infrastructure management. The inventory defines the systems Ansible manages, while ad-hoc commands allow quick, one-off tasks without writing full playbooks. These features make Ansible flexible and efficient for both small tasks and large-scale automation.

In this post, we’ll cover static inventories in INI and YAML formats, how to use groups, aliases, and host variables, and how to run ad-hoc commands. We’ll also include a hands-on example to demonstrate these concepts. If you missed Day 67 on Ansible Introduction, check it out [here](link-to-day-67-post). Let’s get started!

## Understanding Ansible Inventory

The **Ansible Inventory** is a file or dynamic source that lists the managed nodes (servers, VMs, or devices) Ansible interacts with. It defines the hosts, groups them for organization, and allows customization through variables.

- **Why Use Inventory?**
  - **Organize Hosts**: Group servers by role (e.g., webservers, databases) for targeted automation.
  - **Flexibility**: Supports static files or dynamic sources (e.g., AWS, GCP).
  - **Customization**: Define host-specific or group-specific variables for tailored configurations.

- **Types of Inventory**:
  - **Static Inventory**: A manually defined file in INI or YAML format.
  - **Dynamic Inventory**: Scripts or plugins that fetch host data from cloud providers or CMDBs.

- **Default Inventory**:
  - Located at `/etc/ansible/hosts` (can be overridden with `-i` flag).
  - Can be customized per project or environment.

## Static Inventory (INI and YAML Format)

Static inventories are simple files listing hosts and their configurations. They can be written in **INI** or **YAML** format.

### INI Format

- Simple and widely used for small setups.
- Structure includes hosts, groups, and variables.
- Example (`inventory.ini`):
  ```
  [webservers]
  web1.example.com ansible_host=192.168.1.10 ansible_user=admin
  web2.example.com ansible_host=192.168.1.11 ansible_user=admin

  [dbservers]
  db1.example.com ansible_host=192.168.1.12 ansible_user=dbadmin

  [webservers:vars]
  http_port=80
  ```

  - `[webservers]` and `[dbservers]` are groups.
  - `ansible_host` specifies the IP address.
  - `ansible_user` defines the SSH user.
  - `[webservers:vars]` sets group variables.

### YAML Format

- More structured and readable for complex inventories.
- Example (`inventory.yaml`):
  ```yaml
  all:
    hosts:
      web1.example.com:
        ansible_host: 192.168.1.10
        ansible_user: admin
      web2.example.com:
        ansible_host: 192.168.1.11
        ansible_user: admin
    children:
      webservers:
        hosts:
          web1.example.com:
          web2.example.com:
        vars:
          http_port: 80
      dbservers:
        hosts:
          db1.example.com:
            ansible_host: 192.168.1.12
            ansible_user: dbadmin
  ```

  - `all`: The default top-level group containing all hosts.
  - `children`: Defines subgroups like `webservers` and `dbservers`.
  - `vars`: Sets group-level variables.

- **When to Use**:
  - **INI**: Simple setups, quick prototyping.
  - **YAML**: Complex inventories with nested groups or many variables.

## Groups, Aliases, and Host Variables

- **Groups**:
  - Organize hosts by role, environment, or location (e.g., `webservers`, `prod`, `us-east`).
  - Nested groups are possible for hierarchical organization.
  - Example (INI):
    ```
    [prod:children]
    webservers
    dbservers
    ```

- **Aliases**:
  - Friendly names for hosts, mapping to actual IPs or DNS names.
  - Example: `web1.example.com` is an alias for `192.168.1.10`.

- **Host Variables**:
  - Define host-specific configurations (e.g., `ansible_user`, `ansible_port`).
  - Example (YAML):
    ```yaml
    web1.example.com:
      ansible_host: 192.168.1.10
      ansible_user: admin
      custom_var: value1
    ```

- **Group Variables**:
  - Apply settings to all hosts in a group.
  - Example (INI):
    ```
    [webservers:vars]
    http_port=80
    app_version=1.2.3
    ```

## Ad-hoc Commands

**Ad-hoc commands** are one-line Ansible commands that execute a single task on managed nodes without requiring a playbook. They use the `ansible` command and are ideal for quick tasks like checking connectivity, gathering facts, or managing services.

- **Syntax**:
  ```bash
  ansible [host-or-group] -i inventory_file -m module_name -a "module_arguments"
  ```

- **Common Modules**:
  - `ping`: Tests connectivity to managed nodes.
  - `command`/`shell`: Runs arbitrary commands.
  - `file`: Manages files or directories.
  - `service`: Controls system services.
  - `apt`/`yum`: Manages packages.

- **Examples**:
  - Check connectivity:
    ```bash
    ansible webservers -m ping
    ```
  - Get system facts:
    ```bash
    ansible webservers -m setup
    ```
  - Install a package:
    ```bash
    ansible webservers -m apt -a "name=nginx state=present" --become
    ```
  - Restart a service:
    ```bash
    ansible webservers -m service -a "name=nginx state=restarted" --become
    ```

- **Why Use Ad-hoc Commands?**
  - Quick troubleshooting or one-off tasks.
  - Testing connectivity or module behavior.
  - Lightweight alternative to playbooks for simple operations.

## Hands-On: Using Ansible Inventory and Ad-hoc Commands

Let’s set up a static inventory, organize hosts into groups, define variables, and run ad-hoc commands to manage a web server on an Ubuntu managed node.

### Step 1: Set Up the Environment

Ensure you have:
- An Ubuntu 22.04 system (control node) with Ansible installed (see Day 67 for installation).
- An Ubuntu managed node with SSH access (e.g., `192.168.1.10`).
- SSH key-based authentication configured.

Test SSH:

```bash
ssh admin@192.168.1.10
```

### Step 2: Create a Static Inventory

Create a directory for the demo:

```bash
mkdir ansible-inventory-demo
cd ansible-inventory-demo
```

#### INI Inventory

Create `inventory.ini`:

```bash
nano inventory.ini
```

Add:

```
[webservers]
web1 ansible_host=192.168.1.10 ansible_user=admin

[dbservers]
db1 ansible_host=192.168.1.11 ansible_user=dbadmin

[prod:children]
webservers
dbservers

[webservers:vars]
http_port=80
app_version=1.2.3

[dbservers:vars]
db_port=3306
```

#### YAML Inventory (Alternative)

Alternatively, create `inventory.yaml`:

```bash
nano inventory.yaml
```

Add:

```yaml
all:
  hosts:
    web1:
      ansible_host: 192.168.1.10
      ansible_user: admin
    db1:
      ansible_host: 192.168.1.11
      ansible_user: dbadmin
  children:
    webservers:
      hosts:
        web1:
      vars:
        http_port: 80
        app_version: 1.2.3
    dbservers:
      hosts:
        db1:
      vars:
        db_port: 3306
    prod:
      children:
        webservers:
        dbservers:
```

For this demo, we’ll use the INI inventory.

### Step 3: Test the Inventory

Verify connectivity to the `webservers` group:

```bash
ansible -i inventory.ini webservers -m ping
```

Expected output:

```
web1 | SUCCESS => {
    "ansible_facts": {...},
    "changed": false,
    "ping": "pong"
}
```

Test group variables:

```bash
ansible -i inventory.ini webservers -m debug -a "var=http_port"
```

Expected output:

```
web1 | SUCCESS => {
    "http_port": "80"
}
```

### Step 4: Run Ad-hoc Commands

Perform some ad-hoc tasks on the `webservers` group:

1. **Update apt cache**:
   ```bash
   ansible -i inventory.ini webservers -m apt -a "update_cache=yes" --become
   ```

2. **Install Nginx**:
   ```bash
   ansible -i inventory.ini webservers -m apt -a "name=nginx state=present" --become
   ```

3. **Start Nginx service**:
   ```bash
   ansible -i inventory.ini webservers -m service -a "name=nginx state=started enabled=true" --become
   ```

4. **Copy a custom index.html**:
   ```bash
   ansible -i inventory.ini webservers -m copy -a "content='<h1>Welcome to my Ansible-managed server!</h1>' dest=/var/www/html/index.html mode=0644" --become
   ```

5. **Check disk usage**:
   ```bash
   ansible -i inventory.ini webservers -m command -a "df -h"
   ```

### Step 5: Test the Web Server

Access the web server:

```bash
curl http://192.168.1.10
```

Expected output:

```html
<h1>Welcome to my Ansible-managed server!</h1>
```

### Step 6: Explore Group and Host Variables

Run an ad-hoc command to display a host variable:

```bash
ansible -i inventory.ini web1 -m debug -a "var=ansible_user"
```

Expected output:

```
web1 | SUCCESS => {
    "ansible_user": "admin"
}
```

Test the `prod` group:

```bash
ansible -i inventory.ini prod -m ping
```

This pings both `web1` and `db1`, confirming the nested group structure.

### Cleanup

Remove Nginx from the managed node:

```bash
ansible -i inventory.ini webservers -m apt -a "name=nginx state=absent" --become
ansible -i inventory.ini webservers -m file -a "path=/var/www/html/index.html state=absent" --become
ansible -i inventory.ini webservers -m service -a "name=nginx state=stopped enabled=false" --become
```

Remove the demo directory (optional):

```bash
cd ..
rm -rf ansible-inventory-demo
```

This hands-on demo shows how to use a static inventory and ad-hoc commands to manage a web server.

## Best Practices

- **Inventory**:
  - Use meaningful group names (e.g., `webservers`, `prod`) for clarity.
  - Store inventories in version control for collaboration.
  - Use YAML for complex inventories with many variables or nested groups.

- **Ad-hoc Commands**:
  - Use for quick tasks or troubleshooting, but prefer playbooks for repeatable workflows.
  - Always specify the inventory file (`-i`) for clarity.
  - Use `--become` only when necessary for privileged tasks.

- **General**:
  - Test connectivity with `ping` before running complex tasks.
  - Use `ansible -m setup` to gather facts for debugging.
  - Secure inventory files containing sensitive variables with Ansible Vault.

## Conclusion

Ansible inventories and ad-hoc commands provide a flexible foundation for automating infrastructure tasks. Static inventories organize hosts and variables, while ad-hoc commands enable quick, one-off operations without the need for playbooks. These features make Ansible a powerful tool for both beginners and advanced users.

Stay tuned for Day 69, where we’ll explore Ansible Playbooks and Roles in depth! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

## 👨‍💻 Author

**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GITHUB](https://github.com/ritesh355/Devops-journal)
