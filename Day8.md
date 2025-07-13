# 🚀 Day 8 of 100 Days of DevOps : Mastering GitHub and Pushing Projects Publicly
---
## Introduction

Welcome back to my 100 Days of DevOps journey! After mastering Git basics and branching on Days 4 and 7, Day 8 marked a significant milestone: pushing my projects to GitHub and making them public. This step transformed my local backup.sh script from Day 6 into a shareable asset, opening doors to collaboration and visibility. In this blog, I’ll walk you through my experience, the technical details, and why this matters for aspiring DevOps engineers. Let’s dive in!
---
## Why GitHub Matters

GitHub is more than just a code-hosting platform—it’s a hub for collaboration, version control, and showcasing your skills. For DevOps, it’s where:


- You store project backups securely.

- Teams collaborate on code, mirroring CI/CD workflows.

- Employers and communities discover your work.

Pushing my backup.sh project publicly was a proud moment, proving I could share automation scripts with the world. Let’s break down how I did it.
---
## Setting Up GitHub

First, I needed a GitHub account. If you don’t have one, head to github.com and sign up with your email. I used ritesh@example.com and picked a username, ritesh-devops, to reflect my DevOps journey. After verification, I was ready to create my first repository.
---
###Creating a Repository

1. On the GitHub homepage, I clicked the “+” icon and selected “New repository.”

2. I named it day6-backup-project to match my local project.

3. I set it to Public (the day’s focus!) and added a description: “Bash script for automated backups – Day 6 DevOps project.”

4. I skipped initializing with a README or .gitignore since I’d push my local files.

5. Clicking “Create repository” gave me the URL: https://github.com/ritesh-devops/day6-backup-project.git.
---

## Configuring Git Locally
Before pushing, I configured Git with my identity:
```
git config --global user.name "Ritesh"
git config --global user.email "ritesh@example.com"
```

I verified it with git config --list, ensuring my email matched GitHub’s. This step links my commits to my profile.
---

##Linking and Pushing to GitHub

###Connecting the Local Repository

I navigated to my project directory:
```
cd ~/day6_backup
```
I checked my status with git status to confirm backup.sh and README.md were committed from Days 6 and 7. Then, I linked it to GitHub:
```
git remote add origin https://github.com/ritesh-devops/day6-backup-project.git
```
A quick git remote -v confirmed the connection.

###Pushing the Code

With changes committed, I pushed to GitHub:
```
git push -u origin main
```
GitHub prompted me for authentication. Since passwords are deprecated, I generated a Personal Access Token (PAT):

Went to Settings > Developer settings > Personal access tokens > Tokens (classic).

Created a token named day8-token with repo scope and copied it.

Used the PAT as my password during the push.

After a successful push, I refreshed the GitHub page and saw my files—exciting!
---

##Enhancing the Repository

To make it professional, I updated README.md locally:
```
nano README.md
```
Added:
```
 Day 6: Backup Automation Script
A Bash script to automate directory backups.
- Author: Ritesh
- Date: 2025-07-12
- Usage: ./backup.sh [source_dir] [backup_dir]
- Features: Error handling, logging, size check.
- GitHub Push: Day 8 milestone!
```
Committed and pushed:
```bash
git add README.md
git commit -m "Enhance README for Day 8"
git push origin main
```
---
##Challenges and Solutions

- Authentication Error: Initially, I used my password, which failed. Switching to a PAT fixed it.

- Push Rejected: I forgot to commit a change—git add . and git commit resolved this.

- Learning Curve: Understanding remotes took time, but git remote -v clarified the setup.
---
#Reflections

Pushing to GitHub felt like sharing a piece of my learning journey. It’s not just code—it’s a portfolio item! I shared the link on X, getting encouraging feedback from the DevOps community. This step also prepares me for Day 9 (Markdown and Docs), where I’ll refine documentation further.
---
##Conclusion

Day 8 was a game-changer, turning my local project into a public asset. If you’re following the 100 Days of DevOps roadmap, don’t skip this—GitHub is your gateway to the DevOps world. Try it with your own project, and let me know your experience!

Happy coding!
Ritesh

## 🙌 Let's Connect

- 💼 [LinkedIn](https://linkedin.com/in/ritesh-singh-092b84340)
- 💻 [GitHub](https://github.com/ritesh355)
