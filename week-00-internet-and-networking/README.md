# Week 00 - Internet and Networking

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

# 🧑‍💻 Task 1: Using ChatGPT as Your Learning Assistant

## Scenario

You're new to DevOps and will frequently encounter technical questions. ChatGPT can be your learning companion.

## Your Task

Write a clear ChatGPT prompt to help you understand:

> "What is a protocol in networking? Explain with a simple real-life example."

Take a screenshot of your interaction showing:

* Your detailed prompt (with clear expectations)
* ChatGPT's simplified response with an example

## Screenshot

Save your screenshot in the `screenshots` folder and update the file name below.

![Task 1 Screenshot](screenshots/task-1-chatgpt.png)


Replace `task-1-chatgpt.png` with your actual screenshot file name.

---

## What I Learned (2–3 lines)

A networking protocol is a set of rules that allows computers to communicate by sending and receiving data in a structured way.
It ensures data is delivered correctly, in order, and understood across different systems, just like rules guide how packages are delivered.

---

# 🌐 Task 2: Internet and Networking

## Scenario

Your friend is launching an online bookstore named **EpicReads**.

He asked you to explain how users globally can access his website hosted in Finland.

## Your Task

Write a short explanation (**100–150 words**) that includes:

* Packet Switching
* IP Address
* TCP/IP
* HTTP/HTTPS

💡 **Tip:** You may use ChatGPT (as demonstrated in Task 1) to refine your explanation.

## Answer

When a user anywhere in the world visits EpicReads, their device connects to the internet using an **IP address**, which uniquely identifies both the user and the Finnish server hosting the bookstore. The request to access the website is broken into smaller chunks through **packet switching**, allowing data to travel efficiently across multiple routes. These packets follow the **TCP/IP protocol suite**: TCP ensures reliable delivery by reassembling packets in the correct order, while IP handles addressing and routing. Once the request reaches the server, the website is delivered using **HTTP or HTTPS**. HTTPS is especially important, as it encrypts data for secure communication, protecting user information like login credentials and payments. This entire process enables fast, reliable, and secure global access to EpicReads.

---

# 🏗️ Task 3: Application Architecture & Stack

## Scenario

EpicReads bookstore has two application versions:

### Two-Tier Application

* Frontend
* Database

### Three-Tier Application

* Frontend
* Backend
* Database

## Your Task

* Draw simple diagrams (hand-drawn or tool-based such as draw.io)
* Label each layer clearly
* List at least two common technologies or tools used for each layer
* Submit a screenshot or photo clearly showing your own drawing

## Diagram Screenshot / Photo

Save your diagram image in the `screenshots` folder and update the file name below.

![Application Architecture Diagram](screenshots/task-3-diagram.png)


Replace `task-3-diagram.png` with your actual diagram file name.

---

## Technologies Used

### Frontend

* Draw.io
* <img width="254" height="148" alt="image" src="https://github.com/user-attachments/assets/025b30c7-64dd-446d-aa71-aa7af551c5aa" />


### Backend

* Draw.io
*<img width="282" height="150" alt="image" src="https://github.com/user-attachments/assets/b8fe28af-4219-451f-b338-b0aed6ca3f9f" />


### Database

* Draw.io
* <img width="292" height="138" alt="image" src="https://github.com/user-attachments/assets/9d3a80b7-71ea-47c6-a087-98ea5bea2bf7" />


---

# 🌍 Task 4: Domain Name & DNS (Basic Concepts)

## Scenario

Your friend's bookstore **EpicReads** is currently accessible through:

```text
52.172.142.222:3000
```

He purchased the domain:

```text
epicreads.com
```

## Your Task

In **50–100 words**, explain in your own words:

1. What is DNS (Domain Name System)?
2. Which DNS record type should be used to connect the domain to the given IP, and why?

## Answer

DNS (Domain Name System) is like the phonebook of the internet. It translates human-friendly domain names like epicreads.com into machine-readable IP addresses like 52.172.142.222 so browsers can find the correct server. The DNS record type used here is an A record, because it connects a domain name directly to an IPv4 address. This allows users to access the website using a simple name instead of remembering a long IP address and port.

---

# 💻 Task 5: Visual Studio Code Setup (Hands-on)

## Your Task

Install Visual Studio Code (if not already installed).

Take a screenshot of your VS Code environment showing:

* Terminal open inside VS Code
* Running a basic command:

### Windows

```powershell
dir
```

### Linux / macOS

```bash
pwd
ls
```

* Your selected VS Code theme clearly visible

⚠️ **Important:** The screenshot must show your username or another identifiable detail to confirm it is your environment.

## Screenshot

Save your screenshot in the `screenshots` folder and update the file name below.

![VS Code Setup Screenshot](screenshots/task-5-vscode.png)


Replace `task-5-vscode.png` with your actual screenshot file name.

---

# 🔗 Task 6: Publish Your Assignment as a LinkedIn Post

## Objective

Publishing on LinkedIn helps you:

* Build your professional online presence
* Reinforce your learning
* Document your DevOps journey publicly

## Your Task

Summarize your answers from Tasks 1–5 into a LinkedIn post.

Clearly structure your post into the following sections:

* ChatGPT
* Internet & Networking
* App Architecture
* DNS
* VS Code Setup

Add the following credit note at the end of your post:

> **P.S. This post is a part of DevOps Micro Internship with Agentic AI Cohort-3 by Pravin Mishra. You can start your DevOps journey by joining this Discord community: https://discord.pravinmishra.com/**

---

## LinkedIn Post URL

Paste your LinkedIn post URL here:

```text
[Add your URL here...](https://www.linkedin.com/posts/nkechi-juwe_devops-techjourney-cloudcomputing-activity-7474268315809591296-iMnC?utm_source=social_share_send&utm_medium=member_desktop_web&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M)
```

---

## LinkedIn Post Backup Copy

Paste the full text of your LinkedIn post here:

My DevOps Micro Internship | Week 1

Having been on this learning path before, I’m not starting from scratch this time. I’m building on existing knowledge through structured training and hands-on practice under Pravin Mishra, and I aim to stay consistent throughout this journey as I explore and build real-world projects.

This DevOps Micro Internship cohort 3 is helping me refresh and strengthen my understanding of core system fundamentals.

This week focused on how the internet works behind the scenes, and breaking down how everyday web requests actually happen.

Here’s what I learned:
- How domain names are translated into IP addresses using DNS
- How DNS resolution works step-by-step (cache - resolver - root - authoritative servers)
- How data moves across networks using packet-based communication
- The role of HTTP/HTTPS in loading and securing websites

What stood out most is how many systems work together just to load something as simple as a webpage.

This is not just learning, it’s structured rebuilding.
Re-engaged my GitHub after some time away and I’m back in VS Code, using it to practice, deploy, and document my DevOps journey as I go. (Sounds like a big flex or a Super power) 😁 

No shortcuts. Just consistency, discipline, and execution.

---

# Reflection – Week 0

### What did you find easy?

Understanding basic networking concepts like protocols and DNS using real-life examples.

---

### What was difficult?

Rememebering the technical setup steps like VS Code terminal usage and understanding architecture layers at first.

---

### What will you improve next week?

I will focus on building more hands-on practice with DevOps tools and improving my understanding of backend and infrastructure concepts.

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.


## 📌 Resources

- 🌐 **DMI Official Website:** https://pravinmishra.com/dmi  
- 🎓 **DevOps for Beginners (Udemy):** https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 **Ultimate Agentic AI DevOps with Clude Code** https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/?referralCode=448389767BC96284087B
- 🎓 **DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm** https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/?referralCode=1C5B734505D65A010FA3
- ▶️ **YouTube Playlist (DMI Cohort 3):** https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 **Pravin Mishra (LinkedIn):** https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 **CloudAdvisory (LinkedIn):** https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track*
