# Assignment 4 — Building Your AI Team

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build and configure a set of specialized AI subagents inside your project. You will learn how different models and tool permissions define agent behavior, and you will trigger two real agent delegations to analyze security and cost aspects of your Terraform infrastructure.

---

# Task 1 — Create the Agents Folder and Add Files

## Goal

Create the `.claude/agents/` directory and add all required agent files.

### Evidence

#### Screenshot 1 — VS Code sidebar showing `.claude/agents/` with all 3 files

<img width="788" height="102" alt="Screenshot 2026-07-15 125629" src="https://github.com/user-attachments/assets/7432b9d7-68e1-4e96-a547-f9912ee7c6e8" />

---

# Task 2 — Compare the Agent Configurations

## Goal

Analyze the configuration differences between the three agents and demonstrate understanding of model and tool selection.

### Written Answers

#### 1. Why does the cost optimizer use Haiku instead of Sonnet?


The cost optimizer is designed for lightweight tasks such as reviewing Terraform resources and identifying cost-saving opportunities. These tasks do not require complex reasoning, so the faster and more cost-efficient Haiku model is more appropriate than Sonnet.

---

#### 2. Why does the security auditor NOT have Write in its tools list?

The security auditor is limited to analyzing and reviewing Terraform configurations. It does not need to modify files, so Write access is intentionally excluded to prevent unintended changes and to follow the principle of least privilege.
---

#### 3. Why does the tf-writer use `inherit` instead of a specific model?

The tf-writer handles tasks such as generating and modifying Terraform code, which may require different levels of reasoning depending on the situation. Using inherit allows it to use the default model configuration in Claude Code, providing flexibility instead of being restricted to a single model.
---

### Evidence

#### Screenshot 2 — `security-auditor.md` frontmatter showing model and tools configuration

<img width="970" height="256" alt="Screenshot 2026-07-15 003658" src="https://github.com/user-attachments/assets/cebc4330-8b2e-4239-a34a-1a7d18c56ffa" />

---

#### Screenshot 3 — `cost-optimizer.md` frontmatter showing the model and tools configuration

<img width="972" height="218" alt="Screenshot 2026-07-15 003935" src="https://github.com/user-attachments/assets/09bc418f-6109-44f1-9b50-203cf3ce8e05" />

---

# Task 3 — Run the Security Auditor

## Goal

Trigger the security auditor agent and analyze the generated security report for your Terraform infrastructure.

### Evidence
<img width="644" height="506" alt="Screenshot 2026-07-15 004322" src="https://github.com/user-attachments/assets/30042cb1-66d2-491a-ac3c-e744a0b386e7" />



#### Screenshot 4 — The delegation message showing Claude launched the security-auditor

<img width="676" height="94" alt="Screenshot 2026-07-15 004212" src="https://github.com/user-attachments/assets/d0c22b0e-d526-4565-8c3a-a22f007167a2" />

---

#### Screenshot 5 — Security audit report output

<img width="644" height="506" alt="Screenshot 2026-07-15 004322" src="https://github.com/user-attachments/assets/ef943201-7e50-416b-a84d-2720cd63cb14" />
<img width="972" height="382" alt="Screenshot 2026-07-15 004421" src="https://github.com/user-attachments/assets/18202462-735c-4d72-b040-c16d78d292fa" />
<img width="678" height="496" alt="Screenshot 2026-07-15 004452" src="https://github.com/user-attachments/assets/a76bc0f8-b68f-4b5b-bf3a-22d956eecf85" />

---

# Task 4 — Run the Cost Optimizer

## Goal

Trigger the cost optimizer agent and review the generated cost optimization report.

### Evidence

#### Screenshot 6 — The full cost optimization report

<img width="644" height="502" alt="image" src="https://github.com/user-attachments/assets/2c280834-fe9e-48bf-bf96-981f0b9ac758" />
<img width="658" height="598" alt="image" src="https://github.com/user-attachments/assets/f0b02248-02a6-45c1-ada2-31935b92fb6a" />
<img width="668" height="520" alt="image" src="https://github.com/user-attachments/assets/d0c91d1b-f6dc-4142-a6e0-ac6b65b79281" />


---

# Submission Instructions

- Ensure all agent files are committed in `.claude/agents/`
- Complete all written answers in your GitHub Repo
- Push final changes to your forked GitHub repository

---

## GitHub Repository URL

Paste your forked repository URL here:

<<<<<<< HEAD
`_https://github.com/NkJuwe/Ultimate-Agentic-DevOps-with-Claude-Code.git`
=======
`Add your URL here`
>>>>>>> upstream/main

---

# Completion Checklist

- [ ] `.claude/agents/` folder contains all 3 agent files
- [ ] Screenshot 2 shows correct `security-auditor.md` configuration
- [ ] Screenshot 3 shows correct `cost-optimizer.md` configuration
- [ ] All 3 written answers completed 
- [ ] Security auditor executed successfully
- [ ] Cost optimizer executed successfully
- [ ] Security report is visible with findings
- [ ] Cost report is visible with recommendations
- [ ] All required screenshots added
- [ ] GitHub repo updated with agents

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
