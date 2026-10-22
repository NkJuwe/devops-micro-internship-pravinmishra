# Assignment 5 — Deploy Book Review App in Your Favorite Cloud (Agentic Terraform Project)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the Terraform section. You will deploy the Book Review App in a production-style three-tier architecture using Terraform on your choice of AWS or Azure — six subnets across two Availability Zones, tier-specific security rules, public and internal load balancers, Next.js/Node.js on Ubuntu VMs, and a private managed MySQL database with a read replica. This assignment is agent-assisted: you may use Claude Code, ChatGPT, or another LLM tool to help design, generate, debug, and improve the infrastructure.

---

# Task 1 — VPC/VNet and Subnet Setup

## Goal

Create a custom VPC/VNet (10.0.0.0/16) with six subnets across two Availability Zones: two public Web Tier subnets, two private App Tier subnets, and two private Database Tier subnets, implemented with Terraform.

### Evidence

#### Screenshot 1 — VPC or VNet details showing 10.0.0.0/16

![vpc](<Screenshot 2026-10-12 144506.png>)

---

#### Screenshot 2 — Subnet list showing all six subnets, their tiers, CIDR ranges, and Availability Zones

![subnet](<Screenshot 2026-10-12 144635.png>)

---

#### Screenshot 3 — Terraform plan or cloud networking view showing the required routing and tier isolation

![terraform plan](<Screenshot 2026-10-12 152341.png>)

---

# Task 2 — Security Groups/NSGs and Load Balancers

## Goal

Configure tier-specific Security Groups/NSGs (Web Tier HTTP 80, App Tier 3001 only from Web Tier, Database Tier 3306 only from App Tier), and create a public load balancer for the frontend and an internal load balancer for the backend, all with Terraform.

### Evidence

#### Screenshot 4 — Web, App, and Database Security Group or NSG rules

![db security](<Screenshot 2026-10-12 152947.png>)

---

#### Screenshot 5 — Public frontend load balancer configuration

![public lb](<Screenshot 2026-10-12 154353.png>)

---

#### Screenshot 6 — Internal backend load balancer configuration

![internal lb](<Screenshot 2026-10-12 154135.png>)

---

#### Screenshot 7 — Healthy frontend and backend targets or backend pools

![frontend](<Screenshot 2026-10-12 155553.png>)
![backend](<Screenshot 2026-10-12 155752.png>)


---

# Task 3 — VMs and Application Deployment

## Goal

Deploy the Next.js Web Tier behind Nginx on port 80 in the public subnets, and the Node.js App Tier on port 3001 in the private subnets (no Elastic IPs/Public IPs on private VMs), with the frontend reaching the backend through the internal load balancer.

### Evidence

#### Screenshot 8 — EC2 or Azure VM dashboard showing the frontend and backend VMs

![ec2](<Screenshot 2026-10-12 160336.png>)

---

#### Screenshot 9 — Nginx status or frontend response on the Web Tier

Add your screenshot here.

---

#### Screenshot 10 — Backend API response through the permitted internal path

![backend api](<Screenshot 2026-10-13 121120.png>)

---

# Task 4 — MySQL Database Setup

## Goal

Deploy a private managed MySQL database (Amazon RDS Multi-AZ or Azure Database for MySQL Flexible Server) with a read replica, restricted to the App Tier on port 3306, and validate the Book Review App homepage, login, review flow, backend API, and database integration through the public load balancer.

### Evidence

#### Screenshot 11 — Amazon RDS or Azure Database dashboard showing the primary database and read replica

![rds primary db and read replica](<Screenshot 2026-10-12 144009.png>)


---

#### Screenshot 12 — Evidence of private database networking and permitted App Tier access

![private db](<Screenshot 2026-10-13 123323.png>)

---

#### Screenshot 13 — Functional Book Review App homepage and login flow

![app homepage](<Screenshot 2026-10-12 144802.png>)

---

#### Screenshot 14 — Functional review flow with working backend API and database integration

![backend api](<Screenshot 2026-10-13 140951.png>)

---

#### Screenshot 15 (optional) — Application logs or terminal output

![app log](<Screenshot 2026-10-13 142536.png>)

---

### Notes

Report the cloud platform used (AWS or Azure), your Terraform code structure (`main.tf`, `variables.tf`, `outputs.tf`, and supporting files), a link/description of your architecture diagram, and the Public Load Balancer DNS used to access the frontend.

## 1. Cloud Platform Used

**Platform:** Amazon Web Services (AWS)

**Infrastructure as Code:** Terraform

**AWS Region:** Europe (Stockholm), `eu-north-1`

The Book Review Application capstone uses AWS to deploy a three-tier application infrastructure across two Availability Zones. The architecture separates the web, application, and database tiers using public and private subnets.

## 2. Terraform Code Structure

The Terraform configuration is maintained in the `terraform/` directory of the capstone repository.

| File or Directory          | Purpose                                                               |
| -------------------------- | --------------------------------------------------------------------- |
| `versions.tf`              | Defines Terraform and AWS provider version requirements.              |
| `variables.tf`             | Declares configurable infrastructure variables.                       |
| `main.tf`                  | Defines core Terraform configuration and shared resources.            |
| `networking.tf`            | Configures the VPC, six subnets, internet gateway, and routing.       |
| `security_groups.tf`       | Defines security groups and permitted traffic between tiers.          |
| `alb.tf`                   | Configures the public and internal Application Load Balancers.        |
| `compute.tf`               | Defines EC2 launch templates and Auto Scaling Groups.                 |
| `database.tf`              | Configures Amazon RDS for MySQL and its read replica.                 |
| `secrets.tf`               | Configures AWS Secrets Manager integration.                           |
| `outputs.tf`               | Exposes useful deployment outputs, including load balancer DNS names. |
| `terraform.tfvars.example` | Provides an example of variable values.                               |
| `scripts/`                 | Contains frontend and backend bootstrap scripts.                      |

The configuration is organized into supporting files to make the infrastructure easier to understand, maintain, and troubleshoot.

## 3. Architecture Diagram

**Diagram title:** Book Review Application: AWS Three-Tier Architecture

The architecture diagram illustrates:

* A custom VPC with CIDR `10.0.0.0/16`.
* Six subnets distributed across two Availability Zones.
* Public and private application load balancers.
* Frontend and backend EC2 instances managed by Auto Scaling Groups.
* Amazon RDS for MySQL with a read replica.
* Security groups, IAM roles, AWS Secrets Manager, and CloudWatch monitoring.
* The application request flow from the internet through the frontend and backend to the database.

The diagram is included as the architecture visual for this project. Note that it is a conceptual representation; optional components and individual resource placements should be checked against the final Terraform configuration before treating it as an exact deployed-resource inventory.

## 4. Public Load Balancer DNS

**Public Application Load Balancer DNS:**

`book-review-alb-1114457219.eu-north-1.elb.amazonaws.com`

**Frontend URL:**

http://book-review-alb-1114457219.eu-north-1.elb.amazonaws.com/

This is the public endpoint used to access the frontend. The endpoint uses HTTP, not HTTPS.

A previous verification request confirmed that the homepage returned HTTP 200. The `/api/books` endpoint also returned HTTP 200 with book data in JSON format. Browser-side rendering, authentication, and review submission still require final end-to-end verification.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about what you achieved in this assignment, with public or "Anyone" visibility.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://lnkd.in/p/eRSupZH8

---

#### Screenshot 16 — Published LinkedIn post showing the text and at least one image or proof

![post](<Screenshot 2026-10-14 125725.png>)

---

# Submission Instructions

- Add all required screenshots in your submission
- Include your architecture diagram and Public Load Balancer DNS
- Do not expose passwords, keys, tokens, database credentials, or Terraform state secrets

---

# Completion Checklist

- [ ] Task 1: Six-subnet VPC/VNet created across two AZs with Terraform (Screenshots 1–3)
- [ ] Task 2: Tier-specific security rules and load balancers configured (Screenshots 4–7)
- [ ] Task 3: Web and App Tier VMs deployed with correct public/private placement (Screenshots 8–10)
- [ ] Task 4: Private MySQL with read replica deployed and app validated end to end (Screenshots 11–15)
- [ ] Report completed: cloud platform, Terraform structure, diagram, LB DNS (Notes)
- [ ] LinkedIn post published and URL submitted (Screenshot 16)
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
