
# 📦 Day 9 – Archiving, Compression, and Backup Scripts (100 Days of DevOps)

Today was all about learning how to **archive**, **compress**, and **backup files** — essential skills for any DevOps or system admin role.

---

## 📚 Topics Covered

- `tar` for archiving
- `zip` and `unzip` for compression
- `rsync` for smart backups
- Practice scripts and hands-on examples

---

## 📁 Archiving with tar

### Create an archive:

```bash
tar -cvf mybackup.tar /home/ritesh/devops-journal
```

- `-c`: create
- `-v`: verbose (shows progress)
- `-f`: filename

### Extract an archive:

```bash
tar -xvf mybackup.tar
```

- `-x`: extract

---

## 🗜️ Compression with zip/unzip

### Compress a folder:

```bash
zip -r mybackup.zip /home/ritesh/devops-journal
```

- `-r`: recursive

### Unzip:

```bash
unzip mybackup.zip
```

---

## 🔁 Backup with rsync

### Dry-run backup:

```bash
rsync -av --dry-run /home/ritesh/Documents/ /home/ritesh/Downloads/
```

### Actual backup:

```bash
rsync -av /home/ritesh/Documents/ /home/ritesh/Downloads/
```

- `-a`: archive mode (preserves permissions, etc.)
- `-v`: verbose

---

## 🔧 Project: Backup Script

I also created an automated backup script using `rsync` to copy my DevOps journal into a backup directory:

```bash
#!/bin/bash
DATE=$(date +%F)
DEST="/home/ritesh/backup_devops"
SRC="/home/ritesh/devops-journal"
mkdir -p $DEST
rsync -av $SRC $DEST/devops_backup_$DATE
```

This helps maintain daily backups — a crucial habit for real-world systems.

---

## 🧠 Key Takeaways

- `tar` is best for archiving; combine with gzip for compression (`tar -czvf`)
- `zip` is easier and widely used on Windows
- `rsync` is the most efficient way to perform smart, incremental backups
- Automating backups is critical for production environments

---

## 🔗 Related

- [Day 12 – Cron Jobs & Automation](https://ritesh-devops.hashnode.dev)


---

## 💻 GitHub Repo

[ritesh355/devops-journal](https://github.com/ritesh355/devops-journal)

---

## 🔥 Quote of the Day

> “Backups are like seatbelts — boring until they save your life.”
