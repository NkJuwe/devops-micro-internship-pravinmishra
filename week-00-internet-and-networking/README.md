# Week 00 — Internet & Networking Basics

## Assignment Overview

This week covers foundational concepts: Internet & Networking, Application Architecture,
Domain & DNS, VS Code setup, and using ChatGPT as a learning tool.

---

## Task 1: Using ChatGPT as Your Learning Assistant

**Prompt I used:**

<!-- I'm currently learning DevOps and have enrolled in a course on Udemy that t pian to follow. 
To be honest, I don't know much about DevOps yet, so l'll need your help from time to time while going through the course.
When I ask questions, please try to explain things in very simple language, preferably with some examples.
Now help me to understand what is Difference Between Two-Tier and Three-Tier Application Architecture -->

**Screenshot:**

![ChatGPT Interaction](./screenshots/task1-chatgpt.png)

---

## Task 2: Internet and Networking

**Scenario:** Your friend is launching an online bookstore named EpicReads hosted in Finland.
Explain in 100–150 words how users globally can access it. Cover: Packet Switching, IP Address, TCP/IP, HTTP/HTTPS.

**My Explanation:**

<!-- When a user anywhere in the world visits EpicReads, their device connects to the internet using an IP address, which uniquely identifies both the user and the Finnish server hosting the bookstore. The request to access the website is broken into smaller chunks through packet switching, allowing data to travel efficiently across multiple routes. These packets follow the TCP/IP protocol suite: TCP ensures reliable delivery by reassembling packets in the correct order, while IP handles addressing and routing. Once the request reaches the server, the website is delivered using HTTP or HTTPS. HTTPS is especially important, as it encrypts data for secure communication, protecting user information like login credentials and payments. This entire process enables fast, reliable, and secure global access to EpicReads. -->

---

## Task 3: Application Architecture & Stack

**Scenario:** EpicReads has two versions — a Two-tier and a Three-tier app.

**Two-Tier Architecture (Frontend + Database):**

<!-- User → Frontend → Database → Frontend → User -->

![Two-Tier Diagram](./screenshots/task3-two-tier.png)

| Layer | Technologies |
|-------|-------------|
| Frontend | <!-- e.g. React, HTML/CSS --> |
| Database | <!-- e.g. MySQL, PostgreSQL --> |

**Three-Tier Architecture (Frontend + Backend + Database):**

<!-- User → Frontend → Backend → Database
Database → Backend → Frontend → User -->

![Three-Tier Diagram](./screenshots/task3-three-tier.png)

| Layer | Technologies |
|-------|-------------|
| Frontend | <!-- e.g. React, Angular --> |
| Backend | <!-- e.g. Node.js, Django --> |
| Database | <!-- e.g. MySQL, MongoDB --> |

---

## Task 4: Domain Name & DNS

**Scenario:** EpicReads is accessible via IP `52.172.142.222:3000`. The domain `epicreads.com` was purchased.

**My Explanation (50–100 words):**

<!-- DNS (Domain Name System) is the system that translates human-readable domain names like *epicreads.com* into machine-readable IP addresses such as *52.172.142.222*. It acts like a phonebook of the internet. To connect the domain to the IP address, an **A record** is used. This record maps the domain name directly to the server’s IPv4 address. This allows users to access EpicReads using a simple domain name instead of remembering a numeric IP, improving usability and accessibility. -->

---

## Task 5: Visual Studio Code Setup

**Screenshot showing:**
- Terminal open inside VS Code
- A basic command running (`pwd` / `ls` / `dir`)
- Your selected theme visible
- Your username visible in the terminal

![VS Code Setup](./screenshots/task5-vscode.png)

---

## Task 6: LinkedIn Post

**Post URL:** <!-- Paste your LinkedIn post URL here -->

---

## Key Learnings

<!-- 3-5 bullet points on what you learned this week -->

-
-
-

---

*Part of the [DevOps Micro Internship with Agentic AI](https://www.linkedin.com/in/pravin-mishra-aws-trainer/) by Pravin Mishra — Join: https://discord.pravinmishra.com/*
