
# day 11 – Fixing Ghost Group ID Issue in Linux (DevOps Practice)

Today I encountered and resolved a real-world Linux user/group issue — a **ghost group ID** left over after deleting a group (`docker`) that my user was still a member of.

---

## ⚠️ The Problem

After running:

```bash
sudo groupdel docker
```

Then checking:

```bash
groups
```

I saw:

```bash
groups: cannot find name for group ID 137
137 devs
```

This meant the group with GID `137` was deleted, but my session still referenced it.

---

## 🔍 Investigation

### Step 1: Checked active groups
```bash
id ritesh
```

### Step 2: Validated `/etc/group`
```bash
getent group | grep 137   # No result
getent group docker       # docker:x:1011:ritesh
```

Confirmed that group `137` no longer existed.

---

## ✅ The Fix

### Step 1: Reassign valid groups
```bash
sudo usermod -G sudo,docker ritesh
```

### Step 2: Log out and log back in
This cleared the ghost group from the session.

### Step 3: Recheck

```bash
groups
# Output:
ritesh sudo docker
```

### Step 4: Verified with:
```bash
id ritesh
# Output:
uid=1000(ritesh) gid=1000(ritesh) groups=1000(ritesh),27(sudo),1011(docker)
```

---

## 🧠 Key Takeaways

- Linux can retain **ghost group IDs** in active sessions after `groupdel`
- Use `id` and `getent group` to debug group memberships and GIDs
- `usermod -G` helps reset valid group memberships
- Always **logout/login** to refresh session and group context

---

## 📌 Useful Commands

| Command | Description |
|--------|-------------|
| `id username` | Show UID, GID, and all groups |
| `groups` | Show all groups for current user |
| `getent group` | List valid groups from system DB |
| `sudo usermod -G group1,group2 user` | Reassign group membership |
| `sudo groupdel groupname` | Delete a system group |
| `logout` | Refresh your shell session |

---

## 🔗 Related Links

- 🔒 [Day 10 – SSH & Secure Access](https://ritesh-devops.hashnode.dev)
- 📁 [GitHub Repo – DevOps Journal](https://github.com/ritesh355/devops-journal)

---

## 🧠 Quote of the Day

> "Understanding groups and permissions is not just a Linux skill — it's a DevOps superpower."
