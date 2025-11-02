# Day 67: Introduction to Ansible for Configuration Management

## Introduction

Welcome to Day 67 of my DevOps learning journey! Today, we’re diving into **Ansible**, a powerful open-source tool for configuration management, automation, and orchestration. Ansible simplifies the management of infrastructure by automating repetitive tasks, ensuring consistency, and reducing manual errors. Whether you’re configuring servers or deploying applications, Ansible is a go-to tool for DevOps engineers.

In this post, we’ll cover what Ansible is, why it’s used, how it compares to provisioning tools like Terraform, its core architecture, and a hands-on guide to installing Ansible on Ubuntu. If you missed Day 66 on Prometheus and Grafana, check it out [here](link-to-day-66-post). Let’s get started!

## What is Ansible & Why We Use It

**Ansible** is an open-source automation tool that manages configuration, application deployment, and task automation across servers. It uses a simple, human-readable language (YAML) and operates over SSH, requiring no agents on managed servers.

- **Why Use Ansible?**
  - **Simplicity**: Write automation tasks in YAML, which is easy to read and write.
  - **Agentless**: Uses SSH for communication, eliminating the need for client-side software.
  - **Idempotency**: Ensures tasks produce consistent results without unintended changes.
  - **Versatility**: Handles configuration management, application deployment, and orchestration.
  - **Extensibility**: Offers thousands of modules for interacting with various systems (e.g., cloud providers, databases).
  - **Community**: Backed by a large community and Red Hat, with extensive documentation and modules.

- **Use Cases**:
  - Configuring servers (e.g., installing packages, setting up users).
  - Deploying applications (e.g., copying files, restarting services).
  - Automating cloud infrastructure (e.g., AWS, GCP).
  - Managing Kubernetes clusters or network devices.

## Configuration Management vs Provisioning (Ansible vs Terraform)

- **Configuration Management (Ansible)**:
  - **Purpose**: Configures and manages existing resources (e.g., installing software, updating settings).
  - **How It Works**: Applies desired state configurations to servers or applications, ensuring consistency.
  - **Focus**: Post-provisioning tasks, such as setting up Nginx, managing users, or configuring databases.
  - **Execution**: Uses a push model, where the control node sends commands over SSH.
  - **Example**: Install Apache, configure firewall rules, or manage SSH keys on a server.

- **Provisioning (Terraform)**:
  - **Purpose**: Creates and provisions infrastructure resources (e.g., VMs, networks, cloud services).
  - **How It Works**: Defines infrastructure as code (HCL) and interacts with APIs to create or destroy resources.
  - **Focus**: Infrastructure setup, such as spinning up EC2 instances or VPCs.
  - **Execution**: Uses a pull model, interacting with provider APIs to manage resources.
  - **Example**: Create an AWS EC2 instance, set up a Kubernetes cluster, or provision a database.

- **Ansible vs Terraform**:
  | Feature                  | Ansible                          | Terraform                        |
  |--------------------------|----------------------------------|----------------------------------|
  | **Primary Use**          | Configuration Management         | Infrastructure Provisioning      |
  | **Language**             | YAML (Playbooks)                 | HCL (HashiCorp Configuration Language) |
  | **Agent Requirement**    | Agentless (SSH)                  | Agentless (API-based)            |
  | **State Management**     | Idempotent but stateless         | Maintains state files            |
  | **Execution Model**      | Push (control node to managed)   | Pull (interacts with provider APIs) |
  | **Best For**             | Server/Application Configuration | Infrastructure Creation          |

- **When to Use**:
  - Use **Ansible** for configuring servers, managing software, or automating repetitive tasks.
  - Use **Terraform** for provisioning infrastructure (e.g., creating VMs, networks).
  - Combine both for a complete workflow: Terraform to provision infrastructure, Ansible to configure it.

## Ansible Architecture

Ansible’s architecture is straightforward, relying on a few key components to automate tasks:

- **Control Node**:
  - The machine running Ansible, where playbooks are executed.
  - Requires Ansible installed and SSH access to managed nodes.
  - Can be a local machine, server, or CI/CD runner.

- **Managed Nodes**:
  - The target systems (servers, VMs, or devices) managed by Ansible.
  - No agent required; only SSH and Python are needed.
  - Can be on-premises, cloud-based, or hybrid.

- **Inventory**:
  - A file (or dynamic source) listing managed nodes (e.g., IP addresses, hostnames).
  - Static inventory example (`inventory.ini`):
    ```
    [webservers]
    192.168.1.10
    192.168.1.11

    [dbservers]
    192.168.1.12
    ```
  - Supports groups for organizing nodes and dynamic inventories for cloud environments.

- **Playbooks**:
  - YAML files defining automation tasks in a structured format.
  - Contain **plays** (sets of tasks) applied to specific hosts.
  - Example playbook:
    ```yaml
    - name: Configure web server
      hosts: webservers
      tasks:
        - name: Install Nginx
          apt:
            name: nginx
            state: present
    ```

- **Modules**:
  - Reusable units of work that perform specific tasks (e.g., `apt`, `copy`, `service`).
  - Ansible provides thousands of built-in modules (e.g., for package management, file operations, cloud services).
  - Example: The `apt` module installs packages on Debian-based systems.

- **How It Works**:
  1. The control node reads the inventory to identify managed nodes.
  2. Playbooks define tasks using modules.
  3. Ansible connects to managed nodes via SSH and executes tasks.
  4. Results are reported back to the control node.

## Hands-On: Install Ansible on Ubuntu

Let’s install Ansible on an Ubuntu 22.04 system (control node) and set up a basic playbook to configure a managed node. We’ll configure a web server (Nginx) on a managed node as a simple example.

### Step 1: Set Up the Environment

Ensure you have:
- An Ubuntu 22.04 system (control node).
- A second Ubuntu system (managed node) with SSH access.
- SSH key-based authentication configured between the control and managed nodes.

Generate an SSH key on the control node (if not already done):

```bash
ssh-keygen -t rsa -b 4096
ssh-copy-id user@managed-node-ip
```

Test SSH connectivity:

```bash
ssh user@managed-node-ip
```

### Step 2: Install Ansible on Ubuntu (Control Node)

Update the package index and install prerequisites:

```bash
sudo apt update
sudo apt install -y software-properties-common
```

Add the Ansible PPA for the latest version:

```bash
sudo add-apt-repository --yes --update ppa:ansible/ansible
```

Install Ansible:

```bash
sudo apt install -y ansible
```

Verify the installation:

```bash
ansible --version
```

Expected output:

```
ansible [core 2.16.1]
  config file = /etc/ansible/ansible.cfg
  ...
```

### Step 3: Configure the Inventory

Create an inventory file to define the managed node.

```bash
mkdir ansible-demo
cd ansible-demo
nano inventory.ini
```

Add the managed node:

```
[webservers]
managed-node ansible_host=192.168.1.10 ansible_user=user
```

Replace `192.168.1.10` with the managed node’s IP and `user` with the SSH username.

Test connectivity:

```bash
ansible -i inventory.ini webservers -m ping
```

Expected output:

```
managed-node | SUCCESS => {
    "ansible_facts": {...},
    "changed": false,
    "ping": "pong"
}
```

The `ping` module confirms SSH and Python are working on the managed node.

### Step 4: Create a Playbook

Create a playbook to install and configure Nginx on the managed node.

```yaml
# nginx-playbook.yaml
- name: Configure web server
  hosts: webservers
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
    - name: Install Nginx
      apt:
        name: nginx
        state: present
    - name: Start Nginx service
      service:
        name: nginx
        state: started
        enabled: true
    - name: Copy index.html
      copy:
        content: "<h1>Welcome to my Ansible-managed web server!</h1>"
        dest: /var/www/html/index.html
        mode: '0644'
```

- `become: true` enables sudo privileges.
- Tasks use the `apt`, `service`, and `copy` modules to install Nginx, start it, and deploy a custom webpage.

### Step 5: Run the Playbook

Execute the playbook:

```bash
ansible-playbook -i inventory.ini nginx-playbook.yaml
```

Expected output shows tasks completing successfully:

```
PLAY [Configure web server] ****************************************************

TASK [Gathering Facts] *********************************************************
ok: [managed-node]

TASK [Update apt cache] ********************************************************
ok: [managed-node]

TASK [Install Nginx] ***********************************************************
ok: [managed-node]

TASK [Start Nginx service] *****************************************************
ok: [managed-node]

TASK [Copy index.html] *********************************************************
changed: [managed-node]

PLAY RECAP *********************************************************************
managed-node : ok=5    changed=1    unreachable=0    failed=0
```

### Step 6: Test the Web Server

Access the managed node’s web server:

```bash
curl http://192.168.1.10
```

Expected output:

```html
<h1>Welcome to my Ansible-managed web server!</h1>
```

### Cleanup

Remove Nginx from the managed node (optional):

```yaml
# cleanup-playbook.yaml
- name: Remove Nginx
  hosts: webservers
  become: true
  tasks:
    - name: Stop and disable Nginx
      service:
        name: nginx
        state: stopped
        enabled: false
    - name: Uninstall Nginx
      apt:
        name: nginx
        state: absent
    - name: Remove index.html
      file:
        path: /var/www/html/index.html
        state: absent
```

Run:

```bash
ansible-playbook -i inventory.ini cleanup-playbook.yaml
```

Remove Ansible from the control node (optional):

```bash
sudo apt remove -y ansible
sudo add-apt-repository --remove ppa:ansible/ansible
```

This hands-on demo shows how to install Ansible and use it to configure a web server.

## Best Practices

- **Ansible**:
  - Store inventory and playbooks in version control for collaboration.
  - Use roles to organize complex playbooks for reusability.
  - Enable `become` only for tasks requiring elevated privileges.

- **Inventory**:
  - Use dynamic inventories for cloud environments (e.g., AWS, GCP).
  - Group hosts logically (e.g., `webservers`, `dbservers`) for targeted playbooks.

- **Playbooks**:
  - Write idempotent tasks to avoid unintended changes.
  - Use descriptive task names for clarity.
  - Validate playbooks with `ansible-playbook --check` before running.

- **General**:
  - Secure SSH keys and limit access to the control node.
  - Use Ansible Vault to encrypt sensitive data (e.g., passwords).
  - Monitor playbook runs with logging or tools like AWX/Ansible Tower.

## Conclusion

Ansible is a powerful, agentless tool for configuration management, making it easy to automate server setup and application deployment. By understanding its architecture and comparing it to provisioning tools like Terraform, you can leverage Ansible effectively in your DevOps workflows.

Stay tuned for Day 68, where we’ll explore advanced Ansible roles and AWX! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀

