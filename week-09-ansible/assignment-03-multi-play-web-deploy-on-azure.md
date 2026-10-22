# Assignment 3 — Multi-Play Web Deploy on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will create one Ansible playbook (`site.yml`) with three plays — install Nginx, deploy a static website with the `copy` module, and verify the deployment from the controller — against the `[web]` group from your existing inventory.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `static-web` project directory with `inventory.ini`, `site.yml`, a `files/` subdirectory, and `README.md`.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `static-web` folder layout

![static-w](<Screenshot 2026-10-16 225806.png>)

---

# Task 2 — Get the Content

## Goal

Stage `index.html` from `https://github.com/pravinmishraaws/Azure-Static-Website` locally under `static-web/files/`.

### Evidence

#### Screenshot 2 — Editor or terminal showing `files/index.html` staged inside the `static-web` project

![static web project](<Screenshot 2026-10-17 004047.png>)

---

# Task 3 — Create the Multi-Play Playbook: site.yml

## Goal

Write `site.yml` with three plays: Play 1 (install/start Nginx on `web`), Play 2 (`copy` `files/index.html` to `/var/www/html/index.html` with owner `www-data`/mode `0644`, notifying an Nginx reload handler), and Play 3 (verify every web host with the `uri` module from `localhost`, asserting HTTP 200).

### Evidence

#### Screenshot 3 — Editor showing the three plays in `site.yml`

![site.yml](<Screenshot 2026-10-17 004120.png>)

---

#### Screenshot 4 — Editor showing the copy task, file ownership/mode, handler, uri task, and HTTP 200 assertion

![assertion](<Screenshot 2026-10-17 004548.png>)

---

# Task 4 — Run the Playbook

## Goal

Run `ansible-playbook -i inventory.ini site.yml` and confirm all plays complete with no failures.

### Evidence

#### Screenshot 5 — Terminal showing the `ansible-playbook` run and final recap with OK/changed results and no failures

![final recap](<Screenshot 2026-10-17 000903.png>)

---

#### Screenshot 6 — Terminal showing the successful localhost URI verification results

![uri](<Screenshot 2026-10-17 001108.png>)

---

# Task 5 — Manual Verification

## Goal

Confirm the deployed static website is reachable directly from a web-server public IP via `curl` and a browser.

### Evidence

#### Screenshot 7 — Browser showing the static website loaded from a web-server public IP

![web-server](<Screenshot 2026-10-17 001303.png>)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, why installation and deployment were split into separate plays, and one benefit of using `copy` instead of cloning from Git directly.

### 1. Issue Encountered and How I Fixed It

One issue I encountered was an SSH host key verification error when I first ran the Ansible ping command against my EC2 instances. Ansible could not verify the remote servers because their host keys had not yet been accepted by my local SSH client. I resolved this by connecting to each server manually through SSH and accepting its host key. After that, I reran the Ansible ping command, and both servers returned successful `pong` responses. I also encountered YAML indentation errors while creating the playbook, which I corrected before validating the file with `ansible-playbook --syntax-check`.

### 2. What I Learned

I learned how to configure an Ansible inventory, establish SSH connectivity to remote servers, write multi-play YAML playbooks, install and manage Nginx, deploy website files, and verify HTTP responses automatically. I also learned the importance of validating playbook syntax before execution and using a second playbook run to test idempotency. Both servers returned HTTP 200, and the second run reported `changed=0`, demonstrating that Ansible maintained the desired state without making unnecessary changes.

### 3. Why Installation and Deployment Were Split into Separate Plays

Installation and deployment were separated to improve organization, readability, and maintainability. The first play prepares both servers by updating the package cache, installing Nginx, and ensuring the service is running. The second play deploys the website file and reloads Nginx only when the file changes. Separating these responsibilities makes the playbook easier to troubleshoot, modify, and extend.

### 4. One Benefit of Using `copy` Instead of Cloning from Git

The Ansible `copy` module transfers the website file directly from the controller to the target servers. This is suitable for this assignment because the HTML file was already available locally. It avoids the need to install Git on the target servers or clone a repository during deployment, making the process simpler and r

---

# Submission Instructions

- Add all required screenshots in your submission
- IP addresses in `inventory.ini` may be redacted
- Do not expose SSH private keys

---

# Completion Checklist

- [ ] Task 1: `static-web` project structure created (Screenshot 1)
- [ ] Task 2: `index.html` staged under `files/` (Screenshot 2)
- [ ] Task 3: Three-play `site.yml` written (Screenshots 3–4)
- [ ] Task 4: Playbook run successfully with no failures (Screenshots 5–6)
- [ ] Task 5: Site verified manually via browser (Screenshot 7)
- [ ] Reflection notes written (Notes)
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
