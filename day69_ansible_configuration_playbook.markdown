# Day 69: Ansible Configuration, Modules, and Writing Your First Playbook

## Introduction

Welcome to Day 69 of my DevOps learning journey! Today, we’re diving deeper into **Ansible** by exploring its configuration, core modules, and how to write your first playbook. Playbooks are the heart of Ansible automation, allowing you to define complex, repeatable tasks in a structured YAML format. We’ll cover the structure of a playbook, key Ansible modules, and a hands-on example of writing a playbook to deploy a simple web server.

If you missed Day 68 on Ansible Inventory and Ad-hoc Commands, check it out [here](link-to-day-68-post). Let’s get started!

## Ansible Configuration

Ansible’s configuration defines how the tool behaves, including defaults for inventory, SSH settings, and module behavior. The main configuration file is `ansible.cfg`.

- **Location**:
  - Default: `/etc/ansible/ansible.cfg`
  - Project-specific: Create an `ansible.cfg` in your working directory to override defaults.
  - Environment variable: Set `ANSIBLE_CONFIG` to point to a custom config file.

- **Key Settings**:
  - `inventory`: Path to the default inventory file (e.g., `./inventory.ini`).
  - `remote_user`: Default SSH user for managed nodes.
  - `become`: Enable privilege escalation (e.g., sudo) by default.
  - `host_key_checking`: Disable SSH host key checking for faster setup (use cautiously).
  - Example `ansible.cfg`:
    ```ini
    [defaults]
    inventory = ./inventory.ini
    remote_user = admin
    host_key_checking = False
    ```

- **Why Customize?**
  - Tailor Ansible to your environment (e.g., custom inventory paths).
  - Improve security by setting secure defaults (e.g., enabling `vault_password_file`).
  - Optimize performance (e.g., adjusting `forks` for parallel execution).

- **Best Practice**:
  - Create a project-specific `ansible.cfg` in your working directory.
  - Avoid editing the global `/etc/ansible/ansible.cfg` to keep changes portable.

## Ansible Modules

**Modules** are reusable units of work in Ansible that perform specific tasks, such as managing files, installing packages, or interacting with cloud services. Ansible includes thousands of built-in modules, and you can write custom ones.

- **Common Modules**:
  - `apt`/`yum`/`dnf`: Manage packages on Debian/Red Hat systems.
  - `file`: Create, modify, or delete files and directories.
  - `copy`: Copy files to managed nodes.
  - `service`/`systemd`: Control services (start, stop, enable).
  - `user`: Manage user accounts.
  - `shell`/`command`: Run arbitrary commands.
  - `template`: Copy templated files with Jinja2 variables.
  - `cloud` (e.g., `aws_s3`, `ec2_instance`): Interact with cloud providers.

- **Module Usage**:
  - Modules are used in playbooks or ad-hoc commands.
  - Example ad-hoc command:
    ```bash
    ansible webservers -m apt -a "name=nginx state=present" --become
    ```
  - Example in a playbook:
    ```yaml
    - name: Install Nginx
      apt:
        name: nginx
        state: present
    ```

- **Idempotency**:
  - Most modules are idempotent, meaning they only make changes if needed (e.g., `apt` won’t reinstall a package if it’s already present).
  - Non-idempotent modules like `shell`/`command` should be used carefully.

- **Finding Modules**:
  - Browse the [Ansible module documentation](https://docs.ansible.com/ansible/latest/collections/index_module.html).
  - Use `ansible-doc -l` to list all modules or `ansible-doc <module>` for details.

## Structure of a Playbook

A **playbook** is a YAML file that defines a set of tasks to be executed on managed nodes. It consists of one or more **plays**, each targeting specific hosts and containing tasks.

- **Key Components**:
  - **hosts**: Specifies the target hosts or groups from the inventory.
  - **name**: A descriptive name for the play or task.
  - **become**: Enables privilege escalation (e.g., sudo).
  - **tasks**: A list of actions using modules.
  - **vars**: Defines variables for the play.
  - **handlers**: Tasks triggered by events (e.g., restart a service after a config change).

- **Basic Playbook Structure**:
  ```yaml
  - name: Example Playbook
    hosts: webservers
    become: true
    vars:
      http_port: 80
    tasks:
      - name: Install Nginx
        apt:
          name: nginx
          state: present
      - name: Start Nginx
        service:
          name: nginx
          state: started
          enabled: true
    handlers:
      - name: Restart Nginx
        service:
          name: nginx
          state: restarted
  ```

- **Key Elements**:
  - `hosts`: Can be a host, group, or pattern (e.g., `all`, `webservers`, `web*`).
  - `become`: Set to `true` for sudo; use `become_user` to specify a user (e.g., `root`).
  - `tasks`: Each task uses a module and has a `name` for clarity.
  - `handlers`: Run only when notified by a task (e.g., via `notify: Restart Nginx`).

## Hands-On: Writing Your First Playbook

Let’s write a playbook to deploy an Nginx web server on an Ubuntu managed node, configure a custom webpage, and ensure the service is running. We’ll use a static inventory and common modules.

### Step 1: Set Up the Environment

Ensure you have:
- An Ubuntu 22.04 system (control node) with Ansible installed (see Day 67 for installation).
- An Ubuntu managed node with SSH access (e.g., `192.168.1.10`).
- SSH key-based authentication configured.

Test SSH:

```bash
ssh admin@192.168.1.10
```

### Step 2: Create an Inventory

Create a directory for the demo:

```bash
mkdir ansible-playbook-demo
cd ansible-playbook-demo
```

Create `inventory.ini`:

```bash
nano inventory.ini
```

Add:

```
[webservers]
web1 ansible_host=192.168.1.10 ansible_user=admin

[webservers:vars]
http_port=80
```

Test connectivity:

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

### Step 3: Write a Playbook

Create a playbook to install Nginx, configure a custom webpage, and ensure the service is running.

```yaml
# webserver-playbook.yaml
- name: Configure Nginx Web Server
  hosts: webservers
  become: true
  vars:
    app_name: "My Web App"
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
    - name: Install Nginx
      apt:
        name: nginx
        state: present
    - name: Copy custom index.html
      copy:
        content: "<h1>{{ app_name }} - Managed by Ansible</h1>"
        dest: /var/www/html/index.html
        mode: '0644'
      notify: Restart Nginx
    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
        enabled: true
  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

- **Explanation**:
  - `hosts: webservers`: Targets the `webservers` group from the inventory.
  - `become: true`: Runs tasks with sudo.
  - `vars`: Defines `app_name` for use in the playbook.
  - `tasks`: Updates the apt cache, installs Nginx, copies a custom `index.html`, and ensures Nginx is running.
  - `notify`: Triggers the `Restart Nginx` handler if the `index.html` file changes.
  - `handlers`: Defines a task to restart Nginx when notified.

### Step 4: Run the Playbook

Validate the playbook syntax:

```bash
ansible-playbook -i inventory.ini webserver-playbook.yaml --check
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini webserver-playbook.yaml
```

Expected output:

```
PLAY [Configure Nginx Web Server] **********************************************

TASK [Gathering Facts] *********************************************************
ok: [web1]

TASK [Update apt cache] ********************************************************
ok: [web1]

TASK [Install Nginx] ***********************************************************
ok: [web1]

TASK [Copy custom index.html] **************************************************
changed: [web1]

TASK [Ensure Nginx is running] *************************************************
ok: [web1]

RUNNING HANDLER [Restart Nginx] ************************************************
changed: [web1]

PLAY RECAP *********************************************************************
web1 : ok=6    changed=2    unreachable=0    failed=0
```

### Step 5: Test the Web Server

Access the web server:

```bash
curl http://192.168.1.10
```

Expected output:

```html
<h1>My Web App - Managed by Ansible</h1>
```

### Step 6: Test Idempotency

Run the playbook again:

```bash
ansible-playbook -i inventory.ini webserver-playbook.yaml
```

Notice that no changes are made (`changed=0`) because the desired state is already achieved, demonstrating idempotency.

### Cleanup

Create a cleanup playbook to remove Nginx:

```yaml
# cleanup-playbook.yaml
- name: Remove Nginx Web Server
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

Remove the demo directory (optional):

```bash
cd ..
rm -rf ansible-playbook-demo
```

This hands-on demo shows how to write and run a playbook using common Ansible modules.

## Best Practices

- **Ansible Configuration**:
  - Use a project-specific `ansible.cfg` for portability.
  - Avoid disabling `host_key_checking` in production for security.
  - Set `log_path` in `ansible.cfg` for debugging playbook runs.

- **Modules**:
  - Prefer specific modules (e.g., `apt`, `file`) over `shell`/`command` for idempotency.
  - Check module documentation for parameters and defaults.
  - Use `notify` with handlers to optimize service restarts.

- **Playbooks**:
  - Use descriptive `name` fields for plays and tasks.
  - Define variables in `vars` or separate files for reusability.
  - Structure tasks logically and break complex playbooks into roles.

- **General**:
  - Test playbooks with `--check` before running in production.
  - Use Ansible Vault to encrypt sensitive data (e.g., passwords).
  - Combine playbooks with inventories for flexible automation.

## Conclusion

Ansible playbooks, powered by modules and a well-configured environment, enable robust automation of infrastructure tasks. By writing your first playbook, you’ve learned how to structure tasks, use modules, and ensure idempotency for reliable configurations.

Stay tuned for Day 70, where we’ll explore Ansible Roles and advanced playbook organization! Drop your questions or feedback in the comments below.

Thanks for reading! 🚀
## 👨‍💻 Author

**Ritesh Singh**  
🌐 [LinkedIn](https://www.linkedin.com/in/ritesh-singh-092b84340/) | 📝 [Hashnode](https://ritesh-devops.hashnode.dev/) | [GITHUB](https://github.com/ritesh355/Devops-journal)

