# Assignment 6 — Safety Rails for Your AI Agent

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will configure safety and control mechanisms for Claude Code using permissions and hooks. You will define team-level command restrictions and implement prompt-level and tool-level hooks to prevent destructive actions before they execute.

---

# Task 1 — Create settings.json with Permissions

## Goal

Create a team-level `settings.json` file with allow and deny rules for safe command execution.

### Evidence

#### Screenshot 1 — Screenshot 1 — `settings.json` open in VS Code showing the full permissions configuration

<img width="294" height="276" alt="image" src="https://github.com/user-attachments/assets/5a1031c9-a4b0-4742-b41b-7411453453cb" />

---

# Task 2 — Add the UserPromptSubmit Hook

## Goal

Add a hook that intercepts user prompts before Claude starts execution and blocks destructive intent.

### Evidence

#### Screenshot 2 — settings.json showing UserPromptSubmit hook

<img width="1084" height="238" alt="image" src="https://github.com/user-attachments/assets/77964e88-e011-4030-8a68-071fa0d20a35" />

---

# Task 3 — Add the PreToolUse Hook

## Goal

Extend `settings.json` with a PreToolUse hook that blocks dangerous Bash commands before execution.

### Evidence

#### Screenshot 3 — full settings.json with permissions and hooks

<img width="1046" height="198" alt="image" src="https://github.com/user-attachments/assets/5dd95308-4700-46ef-bd9b-a2ae41f5ba9f" />
<img width="1046" height="198" alt="Screenshot 2026-07-15 135957" src="https://github.com/user-attachments/assets/e612747b-b6dc-4ac6-987b-2e7170204fa9" />
<img width="1032" height="188" alt="Screenshot 2026-07-15 140054" src="https://github.com/user-attachments/assets/b6319ae9-1241-42ca-a8da-4afab9497e4e" />
<img width="1086" height="590" alt="Screenshot 2026-07-15 140226" src="https://github.com/user-attachments/assets/68a88ee8-12f9-42d8-8732-80f2ab1cf176" />

---

# Task 4 — Test the UserPromptSubmit Hook

## Goal

Verify that destructive prompts are blocked before Claude begins execution.

### Evidence

#### Screenshot 4 — blocked prompt due to UserPromptSubmit hook

<img width="672" height="246" alt="Screenshot 2026-07-10 140802" src="https://github.com/user-attachments/assets/7f06d572-9509-456a-a07b-6648491aaeec" />

---

# Task 5 — Test the PreToolUse Hook

## Goal

Verify that dangerous commands are intercepted before execution by the PreToolUse hook.

### Evidence

#### Screenshot 5 — PreToolUse hook blocking terraform destroy

<img width="662" height="342" alt="Screenshot 2026-07-10 142119" src="https://github.com/user-attachments/assets/adb35c5e-f472-430e-97bd-855792ff4467" />
<img width="630" height="412" alt="Screenshot 2026-07-10 143124" src="https://github.com/user-attachments/assets/2c37db65-ad66-4548-bf7e-d933cdaa869e" />

---

# Submission Instructions

- Ensure `.claude/settings.json` is committed to your GitHub repository
- Run both hook tests successfully and capture required screenshots
- Push final changes to your forked repository

---

## GitHub Repository URL

Paste your forked repository URL here:

`_https://github.com/NkJuwe/Ultimate-Agentic-DevOps-with-Claude-Code.git`

---

# Completion Checklist

- [ ] `settings.json` created with permissions block
- [ ] UserPromptSubmit hook added correctly
- [ ] PreToolUse hook added correctly
- [ ] Screenshot 3 shows full hooks + permissions configuration
- [ ] Prompt-level destructive test was blocked (Screenshot 4)
- [ ] Command-level `terraform destroy` was blocked (Screenshot 5)
- [ ] `settings.json` committed and visible in GitHub repo

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
