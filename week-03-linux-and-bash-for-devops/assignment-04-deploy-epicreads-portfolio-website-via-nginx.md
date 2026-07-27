# Assignment 4 — Deploy EpicReads Portfolio Website via Nginx

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy a static portfolio website on an Ubuntu VM using Nginx. You will download the website template, add your ownership proof in the footer, deploy the files to the Nginx web root, and verify the website is publicly accessible via a browser.

---

# Task 0 — Pre-flight Check

## Goal

Verify the Ubuntu VM and Nginx are ready for deployment.

### Evidence

#### Screenshot 0 — Output of `sudo systemctl status nginx --no-pager` showing Active (running)

<img width="1186" height="610" alt="Screenshot 2026-07-20 105810" src="https://github.com/user-attachments/assets/bafe0c99-ddce-4cbb-8a2c-fd5888501372" />

---

# Task 1 — Get the Website Source Code

## Goal

Download and extract the portfolio website template.

### Evidence

#### Screenshot 1 — Output of `ls -la` showing the extracted project folder

<img width="870" height="602" alt="Screenshot 2026-07-20 133322" src="https://github.com/user-attachments/assets/3b292162-f48c-4ae0-9cb4-bbedec33e09b" />

---

# Task 2 — Add Ownership Proof (Anti-Copy Change)

## Goal

Update the website footer with your deployment details.

### Evidence

#### Screenshot 2 — Nano editor open with the updated footer showing your Full Name, Group, Week, and Date

<img width="1200" height="556" alt="Screenshot 2026-07-20 140706" src="https://github.com/user-attachments/assets/5fe67215-3380-4594-a522-40c2d34969ce" />

---

# Task 3 — Deploy Website via Nginx

## Goal

Deploy the portfolio website to the Nginx web root.

### Evidence

#### Screenshot 3 — Output of `sudo nginx -t` showing configuration test successful

<img width="946" height="644" alt="Screenshot 2026-07-20 141229" src="https://github.com/user-attachments/assets/4e5f5ca7-e935-4ad9-a66d-f9e8ecad8da3" />

---

#### Screenshot 4 — Output of `ls /var/www/html` showing deployed website files

<img width="1010" height="608" alt="Screenshot 2026-07-20 141505" src="https://github.com/user-attachments/assets/bd90131f-af70-4e04-a0ea-5c6389f6cb0e" />

---

# Task 4 — Verify Website is Live

## Goal

Verify the deployed website is publicly accessible and the footer contains your details.

### Evidence

#### Screenshot 5 — Output of `curl ifconfig.me` showing the server's public IP address

<img width="1424" height="604" alt="Screenshot 2026-07-20 142437" src="https://github.com/user-attachments/assets/1e050c72-cc12-49bf-a0ed-796635ea62cd" />

---

#### Screenshot 6 — Browser showing the live website with your Full Name and deployment details in the footer

<img width="1436" height="764" alt="Screenshot 2026-07-20 142609" src="https://github.com/user-attachments/assets/a0c0f071-b9a1-4655-826a-39b9b4b6d512" />

---

# Task 5 — Mini Real DevOps Operational Check

## Goal

Verify the deployed website and Nginx service are healthy.

### Evidence

#### Screenshot 7 — Output of `systemctl is-enabled nginx`

<img width="682" height="136" alt="Screenshot 2026-07-20 143010" src="https://github.com/user-attachments/assets/332304c8-a021-48fa-9743-7b3b24766931" />

---

#### Screenshot 8 — Output of `curl -I http://localhost` showing 200 OK

<img width="666" height="366" alt="Screenshot 2026-07-20 143128" src="https://github.com/user-attachments/assets/b8f1da4e-5f82-4afc-b18d-7dae8c8f5c2c" />

---

# LinkedIn Post (Mandatory)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/nkechi-juwe_devops-aws-linux-ugcPost-7484967527639461888-TuXN/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M`

---

#### Screenshot — Published LinkedIn post showing the live website with your Full Name in the footer

<img width="558" height="754" alt="image" src="https://github.com/user-attachments/assets/d8bcb018-2015-47e6-aedc-ec7308ab8064" />
.

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Ownership proof in the footer is mandatory
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Screenshot 0: Nginx service status (active/running)
- [ ] Screenshot 1: Website files downloaded and extracted
- [ ] Screenshot 2: Footer updated with Full Name, Group, Week, and Date
- [ ] Screenshot 3: Nginx configuration test successful
- [ ] Screenshot 4: Website files deployed to /var/www/html
- [ ] Screenshot 5: Public IP retrieved
- [ ] Screenshot 6: Live website accessible in browser with footer details
- [ ] Screenshot 7: Nginx enabled on boot
- [ ] Screenshot 8: Local HTTP response returns 200 OK
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
