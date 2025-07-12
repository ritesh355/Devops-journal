📘 Day7.md — Git Branching, Merging & Conflict Resolution

# 📅 Day 7 – Git Branching, Merging & Conflict Resolution

Today I learned and practiced **Git branching** strategies, how to **merge branches**, and how to handle **merge conflicts** — essential skills for any DevOps engineer collaborating on code.

---

## 🧠 What I Learned

| Concept                   | Skill Gained                                  |
|---------------------------|-----------------------------------------------|
| `git branch`              | Create and manage branches                    |
| `git checkout -b`         | Create and switch to a new branch             |
| `git merge`               | Merge one branch into another                |
| Merge Conflicts           | Identify and resolve conflicts manually       |
| `git log --oneline --graph` | Visualize branch history                   |

---

## ✅ Commands I Practiced

### 🔀 1. Create a new Git repository

```bash
mkdir git-practice-lab
cd git-practice-lab
git init

🌿 2. Create a new branch

git branch feature-a

Check all branches:

git branch

🚀 3. Switch to a branch

git checkout feature-a

Or create and switch:

git checkout -b feature-b

📝 4. Make some changes

echo "This is feature A" > file.txt
git add .
git commit -m "Add feature A content"

Switch back to main and make a conflicting change:

git checkout main
echo "This is MAIN version" > file.txt
git commit -am "Update from main"

🔀 5. Merge and resolve conflicts

git merge feature-a

🛑 Conflict message appears if both branches modified the same part of the file.

Resolve it manually:

    Open the file

    Edit to keep the correct version

    Save and run:

git add file.txt
git commit -m "Resolve conflict between main and feature-a"

🧪 Bonus: Visualize Branch History

git log --oneline --graph --all

Shows a visual tree of your branches and commits.
🛠️ Summary of Key Commands
Command	Use Case
git branch	List or create branches
git checkout branch_name	Switch to branch
git checkout -b new_branch	Create + switch
git merge branch_name	Merge into current branch
git status	Check working tree
git log --oneline --graph	Visualize history
git diff	See changes
git add and git commit	Save changes
⚔️ What I Learned from Conflicts

Merge conflicts happen when:

    Two branches modify the same lines of a file

    Git cannot automatically resolve the difference

🧠 I learned to:

    Read conflict markers (<<<<<<<, =======, >>>>>>>)

    Edit files manually

    Add and commit after resolving

📌 Reflections

    “Branching and merging are not optional — they are essential for working in teams. Conflict resolution is an art that becomes easier with practice.”

📂 Files Created

    Day7.md — this log

    conflict-demo.txt — used to simulate a merge conflict

    git-branch-cheatsheet.md (optional for repo)

🔗 Resources

    Git Branching Tutorial – Atlassian

    Learn Git Branching (visual tool)

📘 Next Steps

    ✅ Push this Git exercise to GitHub

    ✅ Start a Hashnode blog explaining the conflict resolution visually

    🔜 Learn how to stash changes and cherry-pick commits
