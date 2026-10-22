# Assignment 5 — Production-Grade EpicBook: Terraform + Ansible Roles (Azure or AWS)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application on a cloud VM provisioned with Terraform (Azure or AWS — pick one) and configured through reusable Ansible roles (`common`, `nginx`, `epicbook`) orchestrated by one playbook, using group variables, templates, and handlers, with a verified idempotent second run.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `epicbook-prod` project with `terraform/azure` or `terraform/aws`, `ansible/inventory.ini`, `ansible/site.yml`, `ansible/group_vars/web.yml`, and the `common`, `nginx`, and `epicbook` role directories.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `epicbook-prod` project tree

![project tree](<Screenshot 2026-10-18 231534.png>)

---

# Task 2 — Terraform (Pick One: Azure or AWS)

## Goal

Provision one secure Ubuntu 22.04 VM with SSH key authentication, inbound SSH (22) and HTTP (80), and `public_ip`/`admin_user` outputs, on your chosen cloud.

### Evidence

#### Screenshot 2 — Terminal showing successful `terraform apply` and `terraform output` with `public_ip` and `admin_user`

![terraform output](<Screenshot 2026-10-19 110819.png>)

---

#### Screenshot 3 — Terraform code or cloud console showing inbound rules for ports 22 and 80

![inbound rules](<Screenshot 2026-10-19 111447.png>)

---

# Task 3 — Ansible Inventory

## Goal

Create the `[web]` inventory using the Terraform `public_ip` and `admin_user` outputs, and verify passwordless SSH and `ansible ping`.

### Evidence

#### Screenshot 4 — Terminal showing the successful passwordless SSH hostname check

![passwordless ssh](<Screenshot 2026-10-19 110928.png>)

---

#### Screenshot 5 — Editor or terminal showing `inventory.ini` and a successful Ansible ping

![ping](<Screenshot 2026-10-18 233243.png>)

---

# Task 4 — Create site.yml (Role Orchestration)

## Goal

Create `site.yml` invoking the `common`, `nginx`, and `epicbook` roles in that exact order.

### Evidence

#### Screenshot 6 — Editor showing `ansible/site.yml` with the three roles in the required order

![ansible/site.yml](<Screenshot 2026-10-18 233335.png>)

---

# Task 5 — Role: common

## Goal

Create `roles/common/tasks/main.yml` to update apt, upgrade packages, install baseline packages (`git`, `curl`, `unzip`, `software-properties-common`), with optional SSH hardening applied only after key-based access is confirmed.

### Evidence

#### Screenshot 7 — Editor showing `roles/common/tasks/main.yml`

![main.yml](<Screenshot 2026-10-18 233402.png>)

---

# Task 6 — Role: nginx

## Goal

Create the `nginx` role to install Nginx, deploy the `epicbook.conf.j2` template to `/etc/nginx/sites-available/epicbook`, enable the site, remove the default site, and reload via handler.

### Evidence

#### Screenshot 8 — Editor showing the Nginx role tasks, handler, and `epicbook.conf.j2` template

![nginx](<Screenshot 2026-10-18 233435.png>)

---

#### Screenshot 9 — Terminal showing `/etc/nginx/sites-available/epicbook` and a successful Nginx configuration test

![successful nginx](<Screenshot 2026-10-18 233458.png>)

---

# Task 7 — Role: epicbook

## Goal

Create the `epicbook` role to clone the repository to `{{ app_dest }}`, set ownership/permissions using group variables, and notify the Nginx reload handler on change.

### Evidence

#### Screenshot 10 — Editor showing `roles/epicbook/tasks/main.yml`

![tasks/main.yml](<Screenshot 2026-10-18 233520.png>)

---

# Task 8 — Group Variables

## Goal

Define `app_repo`, `app_dest`, `app_user`, and `app_group` in `ansible/group_vars/web.yml`.

### Evidence

#### Screenshot 11 — Editor showing `ansible/group_vars/web.yml`

![groups_vars/web.yml](<Screenshot 2026-10-18 233538.png>)

---

# Task 9 — Run the Playbook

## Goal

Run `ansible-playbook -i inventory.ini site.yml` and confirm `common` → `nginx` → `epicbook` all complete with `failed=0`.

### Evidence

#### Screenshot 12 — Terminal showing the role-based Ansible run and final recap with `failed=0`

![final recap](<Screenshot 2026-10-19 014847.png>)

---

# Task 10 — Verify

## Goal

Confirm the EpicBook site loads with HTTP 200, inspect the Nginx configuration, and rerun the playbook to confirm the second run is mostly OK/UNCHANGED with `failed=0`.

### Evidence

#### Screenshot 13 — Browser showing the EpicBook site with the public IP visible

![browser](<Screenshot 2026-10-19 014956.png>)

---

#### Screenshot 14 — Terminal showing HTTP 200 and the Nginx site-file snippet

![http 200](<Screenshot 2026-10-19 015028.png>)

---

#### Screenshot 15 — Terminal showing the idempotent second Ansible run with mostly OK/UNCHANGED and `failed=0`

![idempotent second ansible](<Screenshot 2026-10-19 114005.png>)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, any security issues you identified, and your production remediation plan.

### Issue Faced and Resolution

One challenge was getting the EpicBook application to run correctly behind Nginx. Although the application service was running, Nginx initially displayed its default welcome page instead of the EpicBook interface. I inspected the Nginx configuration, verified the application response locally, and reloaded Nginx so that requests were served through the intended EpicBook site configuration. I then verified that the public endpoint returned HTTP 200 and displayed the application.

I also addressed Ansible idempotency. The npm dependency installation task initially reported changes on repeated runs. I updated the role to check whether the Git repository had changed and whether the installed npm dependency lockfile existed before running the dependency installation task. The subsequent playbook run completed with `changed=0`, `failed=0`, and `unreachable=0`.

### What I Learned

This project strengthened my understanding of Terraform-based infrastructure provisioning, Ansible role design, Linux service management, application runtime configuration, Nginx reverse proxying, and repeatable configuration management. I learned that a successful deployment requires more than provisioning a virtual machine: the application, database, service manager, web server, and network access must work together. I also learned to distinguish a service being active from the application being accessible through its public endpoint.

### Security Issues Identified

The deployment uses SSH key authentication, and SSH ingress is restricted to a specific source IP address. The application database credentials are stored in an Ansible Vault file and deployed to a root-owned environment file with restrictive permissions. The application is served through Nginx over HTTP, however, rather than HTTPS. The current single-server architecture also does not provide the isolation, redundancy, and resilience expected of a production service.

### Production Remediation Plan

For a production deployment, I would configure HTTPS using a valid TLS certificate, restrict inbound and outbound network access to the minimum required, and move database credentials to a dedicated secrets-management service. I would separate the application and database into appropriately isolated network tiers, establish automated backups and tested recovery procedures, and add centralized logging, monitoring, and alerting. I would also introduce automated security updates, vulnerability scanning, and deployment checks in a CI/CD pipeline before promoting changes to production.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post describing the Terraform + Ansible roles deployment (cloud chosen, role structure, Nginx deployment, idempotency result), and add a 4–6 line video reflection covering one challenge/fix, security issues observed, and your production remediation plan.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`Add your URL here`

---

#### Screenshot — Published LinkedIn post

Add your screenshot here.

---

#### Video reflection screenshot

Add your screenshot here.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose private keys, credentials, tokens, or unrestricted management access

---

# Completion Checklist

- [ ] Task 1: `epicbook-prod` project and role structure created (Screenshot 1)
- [ ] Task 2: Cloud VM provisioned with Terraform (Screenshots 2–3)
- [ ] Task 3: Passwordless SSH and Ansible ping verified (Screenshots 4–5)
- [ ] Task 4: `site.yml` orchestrates roles in common → nginx → epicbook order (Screenshot 6)
- [ ] Task 5: `common` role created (Screenshot 7)
- [ ] Task 6: `nginx` role, template, and handler created (Screenshots 8–9)
- [ ] Task 7: `epicbook` role created (Screenshot 10)
- [ ] Task 8: Group variables defined (Screenshot 11)
- [ ] Task 9: Playbook run successfully with `failed=0` (Screenshot 12)
- [ ] Task 10: Site verified and idempotent rerun confirmed (Screenshots 13–15)
- [ ] Reflection and security remediation notes written (Notes)
- [ ] LinkedIn post and video reflection submitted
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
