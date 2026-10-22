# Assignment 2 — Deploy Mini Finance Project via Azure DevOps Pipeline

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build an Azure DevOps CI/CD pipeline that deploys the Mini Finance static website to an Ubuntu VM running Nginx: importing the repo into Azure Repos, provisioning the VM with Terraform and Ansible, connecting via an SSH Service Connection, and deploying on every commit to `main`.

---

# Task 1 — Import the Repository

## Goal

Import `https://github.com/pravinmishraaws/Azure-Static-Website` into Azure Repos and confirm `index.html` is present.

### Evidence

#### Screenshot 1 — Azure Repos showing the imported repository files with `index.html` visible

![index.html](<Screenshot 2026-10-20 113238.png>)

---

# Task 2 — Prepare the Target VM

## Goal

Provision a Linux VM with Terraform (ports 22/80 open), then use Ansible to install and start Nginx and prepare `/var/www/html`.

### Evidence

#### Screenshot 2 — Terraform output or cloud console showing the running VM and public IP

![vm](<Screenshot 2026-10-20 161909.png>)

---

#### Screenshot 3 — Terminal showing Ansible completed successfully and Nginx is active

![ansible complete, nginx active](<Screenshot 2026-10-20 162055.png>)

---

# Task 3 — Create an SSH Service Connection

## Goal

Create the password-based SSH Service Connection `ubuntu-nginx-ssh` pointing to the VM, and validate it.

### Evidence

#### Screenshot 4 — SSH Service Connection configuration page showing the connection details and successful validation, with the password hidden

![ssh config](<Screenshot 2026-10-20 122234.png>)

---

# Task 4 — Author the YAML Pipeline

## Goal

Write a pipeline triggered on `main` that checks out the repo, copies files to `/var/www/html` via `CopyFilesOverSSH@0`, and verifies the deployment directory via an `SSH@0` task, using `ubuntu-nginx-ssh` and the self-hosted (or available Microsoft-hosted) pool.

### Evidence

#### Screenshot 5 — Pipeline YAML definition open in the Azure DevOps editor

![yaml](<Screenshot 2026-10-20 122956.png>)

---

# Task 5 — Verify Deployment

## Goal

Confirm the pipeline run succeeded (checkout, SSH connection, file transfer, remote verification) and the Mini Finance website is live at the VM's public IP.

### Evidence

#### Screenshot 6 — Successful Azure DevOps pipeline run log summary

![pipeline log](<Screenshot 2026-10-20 162350.png>)

---

#### Screenshot 7 — Browser showing the deployed website with the VM public IP visible

![website](<Screenshot 2026-10-20 162510.png>)

---

### Notes

Include the VM public URL. Describe any issue you faced and how you fixed it (e.g. parallelism/agent-pool issues).

### Project: Deploying a Static Website to AWS EC2 Using Azure DevOps CI/CD

**Cloud Platform:** Amazon Web Services (AWS) EC2
**CI/CD Platform:** Azure DevOps Pipelines
**VM Public URL:** http://13.53.111.64
**Deployment Method:** Automated deployment over SSH to an EC2 instance running Nginx.

### Implementation Summary

I configured an Azure DevOps CI/CD pipeline to deploy static website files from Azure Repos to an AWS EC2 virtual machine. The pipeline uses a Microsoft-hosted Ubuntu agent, connects to the EC2 instance through an SSH service connection, copies website files to a staging directory, and synchronizes them to the Nginx web root at `/var/www/html`.

The pipeline also checks that Nginx is running, verifies that `index.html` exists, and tests the website's HTTP response.

### Issues Faced and Solutions

**1. YAML syntax errors:**
The initial pipeline configuration contained incorrect indentation and an invalid list marker (`*` instead of `-`). I corrected the YAML structure and indentation to resolve the parsing errors.

**2. Agent pool configuration:**
The pipeline initially referenced a self-hosted agent pool that Azure DevOps could not use. I switched to the Microsoft-hosted `ubuntu-latest` agent, allowing the pipeline to run without depending on the unavailable pool.

**3. SSH connection timeout:**
The pipeline initially timed out while connecting to the EC2 instance. I investigated the SSH connectivity and service connection configuration. A subsequent pipeline run established the SSH connection successfully.

**4. Missing staging and web-root directories during manual testing:**
I initially ran the synchronization command from my local WSL environment, where the EC2 directories did not exist. I identified that these operations needed to run on the remote EC2 instance and prepared the required directories and Nginx environment.

### Outcome

The pipeline successfully established an SSH connection to the EC2 instance and executed the remote verification task. The logs confirmed that `index.html` was present in the Nginx web root.

**Public URL:** http://13.53.111.64

This project provided practical experience with Azure DevOps CI/CD pipelines, AWS EC2, SSH-based deployments, Nginx configuration, and troubleshooting cloud deployment issues.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not commit the VM password to the repository or write it directly in YAML

---

# Completion Checklist

- [ ] Task 1: Repository imported into Azure Repos (Screenshot 1)
- [ ] Task 2: VM provisioned and Nginx configured (Screenshots 2–3)
- [ ] Task 3: SSH Service Connection created and validated (Screenshot 4)
- [ ] Task 4: YAML pipeline authored (Screenshot 5)
- [ ] Task 5: Pipeline run succeeded and site verified (Screenshots 6–7)
- [ ] VM URL and issue notes written (Notes)
- [ ] No passwords, tokens, or credentials exposed

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
