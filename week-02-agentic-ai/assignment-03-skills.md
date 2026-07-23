# Assignment 3 — Building Your Command Center

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a local Claude Skills system by creating the `.claude/skills/` folder structure, adding predefined skill files, and executing a real agentic command (`/scaffold-terraform`) to generate infrastructure code. You will also observe how skills enforce tool restrictions and enable controlled automation.

---

# Task 1 — Create the Skill Folder Structure

## Goal

Create the required `.claude/skills/` directory structure for all skills.

### Evidence

#### Screenshot 1 — VS Code sidebar showing `.claude/skills/` folder with all 4 subfolders visible

<img width="292" height="318" alt="image" src="https://github.com/user-attachments/assets/126bd43e-8c31-4c94-8a5f-dae80312bcfb" />

---

# Task 2 — Add the Skill Files

## Goal

Place all required skill files into their correct directories and verify their configuration.

### Evidence

#### Screenshot 2 — `.claude/skills/scaffold-terraform/` open in VS Code showing both `SKILL.md` and `template-spec.md`

<img width="250" height="70" alt="Screenshot 2026-07-15 000707" src="https://github.com/user-attachments/assets/8f81ae36-5372-43b5-aef3-0e5ca6c735db" />

---

#### Screenshot 3 — Screenshot 3 — `tf-plan/SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no Write) and `disable-model-invocation: true`

<img width="308" height="44" alt="Screenshot 2026-07-15 000815" src="https://github.com/user-attachments/assets/47d04c9e-c7bc-4df9-955f-c2e46979cf98" />

---

# Task 3 — Run /scaffold-terraform

## Goal

Execute the `/scaffold-terraform` skill to generate a full Terraform infrastructure setup.

### Evidence
<img width="994" height="444" alt="Screenshot 2026-07-15 000940" src="https://github.com/user-attachments/assets/761d540d-56bc-4937-b0be-e9dc5f3b88ac" />

#### Screenshot 4 — Claude's response showing the scaffold complete with the file list

<img width="1000" height="268" alt="Screenshot 2026-07-10 015324" src="https://github.com/user-attachments/assets/29f1426b-0f8e-406a-ba5e-9a2d3b2e16c0" />

---

#### Screenshot 5 — VS Code sidebar showing the `terraform/` folder with all generated files inside

<img width="268" height="126" alt="Screenshot 2026-07-15 001505" src="https://github.com/user-attachments/assets/1a272fb6-f2fe-4027-94eb-0e8f50afd7a9" />

---

# Task 4 — Run terraform init and /tf-plan

## Goal

Initialize Terraform and execute the `/tf-plan` skill to observe plan execution and output analysis.

### Evidence
<img width="692" height="568" alt="Screenshot 2026-07-10 020301" src="https://github.com/user-attachments/assets/a67a20f5-b18b-42c5-8987-b40521d93666" />

<img width="662" height="576" alt="Screenshot 2026-07-10 030146" src="https://github.com/user-attachments/assets/01847e78-3ba9-4a84-8a3d-4fd323561d26" />

#### Screenshot 6 — Claude's `/tf-plan` response showing it ran the command and analyzed the result (pass or auth error both count)

<img width="694" height="542" alt="Screenshot 2026-07-10 032150" src="https://github.com/user-attachments/assets/bcbeb242-172e-4d17-bbef-2ef7ce279c00" />

---

# Submission Instructions

- Ensure `.claude/skills/` folder and all skill files are committed to your GitHub repository
- Run all commands successfully and capture required screenshots
- Push final changes to your forked repository

---

## GitHub Repository URL

Paste your forked repository URL here:

<<<<<<< HEAD
`_https://github.com/NkJuwe/Ultimate-Agentic-DevOps-with-Claude-Code.git`
=======
`Add your URL here`
>>>>>>> upstream/main

## LinkedIn post URL

Paste your forked repository URL here:

<<<<<<< HEAD
`https://github.com/NkJuwe/Ultimate-Agentic-DevOps-with-Claude-Code.git`
=======
`Add your URL here`
>>>>>>> upstream/main
---

# Completion Checklist

- [ ] `.claude/skills/` folder created with all 4 skill folders
- [ ] All skill files placed correctly
- [ ] `tf-plan/SKILL.md` shows correct `allowed-tools` restrictions
- [ ] `/scaffold-terraform` executed successfully
- [ ] Terraform files generated inside `terraform/` folder
- [ ] `terraform init` executed successfully
- [ ] `/tf-plan` executed and output analyzed by Claude
- [ ] All required screenshots added
- [ ] GitHub repository URL included
- [ ] LinkedIn post URL included

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
