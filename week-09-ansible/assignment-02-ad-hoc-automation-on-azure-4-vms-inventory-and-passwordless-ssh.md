# Assignment 2 — Ad-Hoc Automation on Azure: 4 VMs, Inventory & Passwordless SSH

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision four Azure Linux VMs with Terraform, configure passwordless SSH, build a custom Ansible inventory with web/app/db groups, and run ad-hoc commands across individual hosts and groups.

---

# Task 1 — Provision 4 Azure VMs (Terraform)

## Goal

Provision four Ubuntu 22.04 VMs (`web1`, `web2`, `app1`, `db1`, Standard_B1s) with SSH key authentication and public IPs, in a VNet with an NSG allowing SSH (22) and HTTP (80), and output all four public IPs.

### Evidence

#### Screenshot 1 — Terminal showing successful `terraform apply` output and `terraform output public_ips`

![terraform apply](<Screenshot 2026-10-16 000503.png>)

---

#### Screenshot 2 — Azure Portal showing all four running Ubuntu VMs

![ec2 vms](<Screenshot 2026-10-16 011246.png>)

---

#### Screenshot 3 — Network Security Group inbound rules showing SSH 22 and HTTP 80

![nsg](<Screenshot 2026-10-16 011512.png>)

---

# Task 2 — Configure Passwordless SSH

## Goal

Connect to each of the four VMs as `azureuser` and run `hostname` remotely without a password prompt.

### Evidence

#### Screenshot 4 — Terminal showing successful `hostname` output from all four passwordless SSH tests

![passwordless ssh test](<Screenshot 2026-10-16 001145.png>)

---

# Task 3 — Create a Custom Ansible Inventory

## Goal

Create `inventory.ini` mapping VM indices 0–1 to `[web]`, index 2 to `[app]`, and index 3 to `[db]`, with `ansible_user` and `ansible_ssh_private_key_file` set under `[all:vars]`.

### Evidence

#### Screenshot 5 — Editor or terminal showing `inventory.ini` with the web, app, db, and all:vars sections

![inventory.ini](<Screenshot 2026-10-16 002006.png>)

---

# Task 4 — Run Your First Ansible Ad-Hoc Commands

## Goal

Run `ping`, `whoami`, and `uptime` against all hosts; install and start Nginx on the `web` group with `--become`; install `htop` on all hosts; and run `df -h` on `db` and `free -m` on all hosts.

### Evidence

#### Screenshot 6 — Terminal showing `ansible ping` SUCCESS for all four hosts

![ansible ping](<Screenshot 2026-10-16 002441.png>)

---

#### Screenshot 7 — Terminal showing `uptime` output for all four hosts

![uptime](<Screenshot 2026-10-16 002624.png>)

---

#### Screenshot 8 — Terminal showing Nginx installation and service start on the web group

![nginx](<Screenshot 2026-10-16 003443.png>)

---

#### Screenshot 9 — Terminal showing `htop` installation on all hosts and group-targeted command output

![htop](<Screenshot 2026-10-16 003546.png>)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, when you'd use an ad-hoc command instead of a playbook, and one challenge you faced during SSH or inventory setup.

### 1. An Issue I Faced and How I Fixed It

One issue I encountered was configuring the Ansible inventory and running commands from the correct directory. Initially, Ansible could not find the inventory file because I was running the command from the Terraform directory while using a relative path to the inventory. I fixed this by returning to the project root and using the correct inventory path, `ansible/inventory.ini`. This taught me that the current working directory and file paths are important when running infrastructure automation commands.

### 2. What I Learned

I learned how to provision Ubuntu EC2 instances on AWS using Terraform and manage them remotely with Ansible. I also learned how to configure an inventory, test connectivity with the Ansible ping module, retrieve server uptime, install packages, and manage services. Successfully installing and starting Nginx, then receiving an HTTP 200 OK response, showed me how to verify that a service is working beyond simply checking whether a command completed successfully.

### 3. When I Would Use an Ad-Hoc Command Instead of a Playbook

I would use an Ansible ad-hoc command for quick, one-time tasks such as checking server connectivity, retrieving uptime, installing a package, or checking a service's status across multiple hosts. For example, `ansible all -i ansible/inventory.ini -m ping` quickly checks whether Ansible can reach the managed servers. For repeatable, multi-step deployments that require structured tasks, variables, handlers, and consistent execution, I would use an Ansible playbook.

### 4. A Challenge I Faced During SSH or Inventory Setup

One challenge was ensuring that all three EC2 instances were accessible through SSH and correctly represented in the Ansible inventory. I had to use each instance's correct public IP address, the Ubuntu SSH username, and the correct private key path. I resolved the setup issues by verifying SSH connectivity to each server individually before running Ansible commands. This taught me that accurate inventory details and working SSH authentication are essential for reliable remote automation.


---

# Submission Instructions

- Add all required screenshots in your submission
- Public IP addresses may be redacted
- Do not expose, upload, or commit the SSH private key

---

# Completion Checklist

- [ ] Task 1: Four Azure VMs provisioned with Terraform (Screenshots 1–3)
- [ ] Task 2: Passwordless SSH verified on all four VMs (Screenshot 4)
- [ ] Task 3: `inventory.ini` created with web/app/db groups (Screenshot 5)
- [ ] Task 4: Ad-hoc ping, uptime, Nginx, and htop commands run successfully (Screenshots 6–9)
- [ ] Reflection notes written (Notes)
- [ ] No private key material exposed

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
