# Assignment 2 — Deploy a React App on Ubuntu VM Using Nginx

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy a React application on an Ubuntu EC2 instance and serve it using Nginx. You will provision a Linux server, install the required tools, personalize the application with your details, and verify that it is publicly accessible via a browser.

---

# Task 1 — Setup Environment (Node.js & npm)

## Goal

Install Node.js and npm on the Ubuntu VM and verify the installation.

### Evidence

#### Screenshot 1 — Output of `node -v && npm -v` showing installed versions

<img width="1108" height="618" alt="Screenshot 2026-07-18 221924" src="https://github.com/user-attachments/assets/7efd4d3a-fecb-43b5-9763-f0c0dd08ac35" />

---

# Task 2 — Setup Environment (Nginx)

## Goal

Install Nginx, start the service, and confirm it is running.

### Evidence

#### Screenshot 2 — Output of `systemctl status nginx --no-pager` showing Active (running)

<img width="1182" height="570" alt="Screenshot 2026-07-18 222242" src="https://github.com/user-attachments/assets/cdf4700e-2398-4938-b8d3-099caa8dccf4" />

---

# Task 3 — Clone React Application

## Goal

Clone the project repository and verify the project files are present.

### Evidence

#### Screenshot 3 — Output of `ls` inside the `my-react-app` directory showing project files

<img width="1062" height="616" alt="Screenshot 2026-07-18 225930" src="https://github.com/user-attachments/assets/4d74bf99-5081-4c62-b048-ed9be72e63d6" />

---

# Task 4 — Modify Application (Personalization)

## Goal

Update `App.js` with your full name and the current date.

### Evidence

#### Screenshot 4 — `nano App.js` open showing your full name and date filled in

<img width="978" height="536" alt="Screenshot 2026-07-18 230702" src="https://github.com/user-attachments/assets/2e18d5fe-2924-4f6c-a9d3-c09e77e03b82" />

---

# Task 5 — Build React Application

## Goal

Install dependencies and generate the production build.

### Evidence

#### Screenshot 5 — Output of `ls` inside `my-react-app` showing the `build/` folder generated

<img width="986" height="458" alt="Screenshot 2026-07-19 000222" src="https://github.com/user-attachments/assets/d0ce274e-27f9-4cc5-bbac-b7f642d8d815" />

---

# Task 6 — Deploy React Build to Nginx Web Root

## Goal

Copy the production build files to the Nginx web root directory.

### Evidence

#### Screenshot 6 — Output of `ls /var/www/html/` showing the deployed build contents

<img width="1004" height="220" alt="Screenshot 2026-07-19 000815" src="https://github.com/user-attachments/assets/8defdfe2-3b06-41dc-854b-7e3900b62555" />

---

# Task 7 — Configure Nginx for React Application

## Goal

Apply Nginx configuration for React routing and confirm the service is active.

### Evidence

#### Screenshot 7 — Output of `systemctl is-active nginx` showing `active`

<img width="1054" height="604" alt="Screenshot 2026-07-19 163029" src="https://github.com/user-attachments/assets/ba73a03b-7ea7-48c7-a50b-aece6d86262b" />

---

#### Screenshot 8 — Output of `cat /etc/nginx/sites-available/default` showing the Nginx config

<img width="1054" height="604" alt="Screenshot 2026-07-19 163029" src="https://github.com/user-attachments/assets/0742503f-1656-4766-b9c8-eb9ecf2c0123" />

---

# Task 8 — Test Deployment

## Goal

Verify the React application is publicly accessible via the server's public IP.

### Evidence

#### Screenshot 9 — Output of `curl ifconfig.me` showing the server's public IP address

<img width="680" height="66" alt="image" src="https://github.com/user-attachments/assets/ff2c07dc-b9d4-45e3-9924-57bf8a3e53a3" />


---

#### Screenshot 10 — Browser showing the deployed React app at `http://<public-ip>` with your name and date visible

<img width="1322" height="672" alt="Screenshot 2026-07-19 170249" src="https://github.com/user-attachments/assets/3cf87a8b-712c-4a44-8c3a-83b49e58f865" />

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/nkechi-juwe_aws-cloudcomputing-devops-ugcPost-7484645241799663617-fZHO/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M`

---

#### Screenshot — LinkedIn post showing the deployed application

<img width="580" height="744" alt="Screenshot 2026-07-19 175010" src="https://github.com/user-attachments/assets/769fce0d-1cfb-4064-9ea7-492440efe61b" />
<img width="548" height="704" alt="Screenshot 2026-07-19 175026" src="https://github.com/user-attachments/assets/fd90b61f-3e54-432f-b93d-3bdf75b94571" />


---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Node.js and npm installed and verified (Screenshot 1)
- [ ] Nginx installed and running (Screenshot 2)
- [ ] Repository cloned and files verified (Screenshot 3)
- [ ] App.js updated with full name and date (Screenshot 4)
- [ ] Production build generated (Screenshot 5)
- [ ] Build files deployed to Nginx web root (Screenshot 6)
- [ ] Nginx configured and active (Screenshots 7 & 8)
- [ ] Public IP retrieved (Screenshot 9)
- [ ] React app accessible in browser with personal details visible (Screenshot 10)
- [ ] LinkedIn post published and URL submitted
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
