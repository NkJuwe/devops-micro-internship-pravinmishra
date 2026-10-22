# Assignment 6 — Capstone: Deploy Book Review App (Three-Tier Architecture) on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a production-ready, best-practice-compliant three-tier architecture on Azure: separated presentation, application, and database tiers, least-privilege network access, a controlled public entry point, protected secrets, and availability/monitoring evidence.

---

# Task 1 — Design the Azure Three-Tier Architecture

## Goal

Create an architecture diagram and implementation plan identifying the presentation, application, and database components, the chosen Azure services, the public entry point, and the internal traffic paths.

### Evidence

#### Screenshot 1 — Architecture diagram showing the public entry point, three tiers, network boundaries, and traffic flow

![arc diagram](<Azure Book Review App Architecture-compressed.jpg>)

---

#### Screenshot 2 — Written architecture assumptions and selected Azure services

![arc assumption](<Screenshot 2026-10-06 123346.png>)
![azure selected service](<Screenshot 2026-10-06 123410.png>)

---

# Task 2 — Create the Azure Network Foundation

## Goal

Create a dedicated Resource Group and VNet with separate subnets for the web, application, and database tiers, keeping the application and database tiers without direct public access.

### Evidence

#### Screenshot 3 — Resource Group overview showing the assignment resources

![rg](<Screenshot 2026-10-06 123717.png>)

---

#### Screenshot 4 — VNet overview showing the address space and all required subnets

![vnet overview](<Screenshot 2026-10-03 182936.png>)

---

#### Screenshot 5 — Route-table or Private DNS evidence where applicable

![private dns](<Screenshot 2026-10-06 125137.png>)

---

# Task 3 — Configure Security and Secret Management

## Goal

Apply least-privilege NSG rules so traffic flows Internet → public entry point → web tier → application tier → database tier, and store credentials in Azure Key Vault or another approved secure mechanism.

### Evidence

#### Screenshot 6 — NSG rules proving least-privilege access between the tiers

![nsg](<Screenshot 2026-10-06 125342.png>)

---

#### Screenshot 7 — Key Vault or approved secret-management configuration (without displaying secret values)

![key vault](<Screenshot 2026-10-03 214932.png>)

---

# Task 4 — Deploy the Presentation (Web) Tier

## Goal

Deploy the Book Review App presentation layer on the approved web-tier compute service, configured to route requests to the internal application-tier endpoint, and not directly exposed except through the public entry service.

### Evidence

#### Screenshot 8 — Web-tier compute overview showing subnet and availability configuration

![web](<Screenshot 2026-10-03 222755.png>)

---

#### Screenshot 9 — Terminal or service output proving the presentation layer is running

![terminal output](<Screenshot 2026-10-06 164415.png>)

---

# Task 5 — Deploy the Business (Application) Tier

## Goal

Deploy the Book Review App backend privately in the application subnet, configured to use the private database endpoint and secured environment values, reachable only through its internal endpoint.

### Evidence

#### Screenshot 10 — Application-tier compute overview showing private subnet placement

![app tier](<Screenshot 2026-10-05 002339.png>)

---

#### Screenshot 11 — Backend process, service, or listening-port evidence

![listening port backend](<Screenshot 2026-10-05 022529.png>)

---

#### Screenshot 12 — Internal health-check or API response (without exposing secrets)

![internal healthcheck](<Screenshot 2026-10-06 165654.png>)

---

# Task 6 — Deploy the Managed Database Tier

## Goal

Create a private Azure managed database (public access disabled), with availability/backup/retention settings, the Book Review App schema imported, and access restricted to the application tier only.

### Evidence

#### Screenshot 13 — Database overview showing private connectivity and public access disabled

![database](<Screenshot 2026-10-05 023743.png>)

---

#### Screenshot 14 — Availability, backup, and retention configuration

![config](<Screenshot 2026-10-05 023824.png>)

---

#### Screenshot 15 — Successful schema or connectivity verification (without exposing credentials)

![connectivity](<Screenshot 2026-10-05 022221.png>)

---

# Task 7 — Configure Traffic Management, Availability, and Monitoring

## Goal

Configure the approved public entry service with health probes and backend pools, internal routing for the application tier where required, and enable Azure Monitor/diagnostics/logs/alerts for the key resources.

### Evidence

#### Screenshot 16 — Public entry service showing listener, frontend endpoint, and healthy web targets

![public lb](<Screenshot 2026-10-06 135110.png>)

---

#### Screenshot 17 — Internal application-tier load-balancing or routing configuration where applicable

![interal lb](<Screenshot 2026-10-06 135538.png>)

---

#### Screenshot 18 — Azure Monitor, diagnostic settings, logs, metrics, or alert evidence

![monitor](<Screenshot 2026-10-06 173623.png>)

---

# Task 8 — Validate the Production-Style Deployment

## Goal

Confirm the Book Review App works end to end through the public endpoint, with at least one database read and one write, confirm private tiers are not internet-reachable, and complete a safe availability test.

### Evidence

#### Screenshot 19 — Browser showing the Book Review App through the public endpoint

![browser](<Screenshot 2026-10-06 204556.png>)

---

#### Screenshot 20 — Proof of successful database-backend read and write operations

![database](<Screenshot 2026-10-06 180533.png>)

---

#### Screenshot 21 — Evidence that private tiers are not publicly accessible

![private tier](<Screenshot 2026-10-05 012216.png>)

---

#### Screenshot 22 — Availability-test and healthy-target evidence

![heathy](<Screenshot 2026-10-06 185951.png>)
![health](<Screenshot 2026-10-06 190209.png>)

---

#### Public Endpoint

Paste your public endpoint URL here:

http://20.87.118.115

---

### Notes

Summarize what worked, issues encountered and how they were fixed, and the availability/security/secrets/monitoring/backup choices made.

Absolutely. Here is a clean summary you can use in the assignment submission. I’ve separated **what worked**, **issues and fixes**, and the required **availability, security, secrets, monitoring, backup, and recovery choices**.

## Deployment Summary

### 1. What Worked

The Book Review application was deployed on Azure using a three-tier architecture in **South Africa North**.

* **Web/presentation tier**

  * Azure VM: `Book-Review-Web-VM`
  * Ubuntu 24.04
  * Private IP: `10.0.1.4`
  * Subnet: `Book-Review-Web-Subnet`
  * Nginx was installed and configured as the public-facing web server and reverse proxy.
  * The VM does not have a public IP directly attached.
  * Public traffic enters through the Azure Load Balancer.

* **Application/business tier**

  * Azure VM: `BOOK-REVIEW-APP-VM`
  * Private IP: `10.0.2.4`
  * Subnet: `Book-Review-App-Subnet`
  * Backend runs on port `3001`.
  * The Express application successfully connects to Azure Database for MySQL.
  * API requests such as `GET /api/books` work successfully.

* **Database tier**

  * Azure Database for MySQL Flexible Server.
  * Server: `bookreview-mysql-nikkyjuwe.mysql.database.azure.com`
  * Database: `book_review_db`
  * Private networking through the database subnet.
  * Public access disabled.
  * SSL/TLS enforced.
  * Database schema and records were successfully verified.

* **Public access**

  * Azure Public Load Balancer: `Book-Review-LB`
  * Public IP: `20.87.118.115`
  * Traffic enters through TCP port 80.
  * The load balancer forwards traffic to the Web VM.
  * Nginx then routes application traffic internally.

* **Database-backed validation**

  * Existing books were successfully retrieved from MySQL.
  * A new book, **Azure DevOps Test Book**, was successfully created through the application.
  * The new record subsequently appeared through the public `/api/books` endpoint.
  * This demonstrated a successful **public request → web tier → application tier → database write/read** flow.

---

# 2. Issues Encountered and How They Were Fixed

### Issue 1: Web VM could not reach the internet

The Web subnet was configured as a private subnet but did not have a NAT Gateway associated with it.

As a result, package installation failed because the VM could not reach the Ubuntu package repositories.

**Fix:**
The existing `app-nat-gateway` was also associated with the Web subnet. After that, the Web VM was able to reach `azure.archive.ubuntu.com`, allowing packages to be installed.

---

### Issue 2: Nginx was missing from the Web VM

Initial connectivity testing showed that nothing was listening on port 80 and the Nginx service did not exist.

**Fix:**
Nginx was installed using:

```bash
sudo apt install -y nginx
```

Nginx was then enabled and configured to listen on port 80.

---

### Issue 3: Public Load Balancer initially reported the Web VM as unhealthy

The Azure Load Balancer health probe uses TCP port 80. The probe initially failed because there was no healthy service listening on port 80.

**Fix:**
Nginx was installed and configured to listen on port 80. This provided the service required by the Load Balancer health probe.

---

### Issue 4: Backend database authentication failed through Run Command

The MySQL command initially returned an authentication error showing:

```text
using password: NO
```

The problem was caused by the non-interactive Azure Run Command environment. `mysql -p` could not interactively receive the password.

**Fix:**
A temporary MySQL client configuration file was created and used with:

```bash
mysql --defaults-extra-file=/tmp/mysql-client.cnf
```

This allowed the database connection to succeed without exposing the password in the command itself.

---

### Issue 5: Public endpoint initially showed the Nginx default page

The public Load Balancer and Web VM were working, but the browser initially displayed the standard Nginx page instead of the application.

**Fix:**
The default Nginx site was removed and a dedicated Book Review Nginx configuration was created.

Nginx was configured to:

* Send `/api/` requests to the backend on `10.0.2.4:3001`.
* Send normal web requests to the Next.js frontend on port `3000`.

---

### Issue 6: Next.js frontend stopped running

The frontend initially ran successfully, but later the process disappeared. Investigation showed that Node.js and npm were no longer available on the Web VM.

The systemd service consequently failed with:

```text
status=203/EXEC
```

**Fix:**
Node.js and npm were reinstalled successfully:

* Node.js `v18.19.1`
* npm `9.2.0`

The existing frontend files and build were retained. The frontend service still needs to be started with a Node version compatible with the Next.js 15 application.

---

# 3. Availability Choices

The deployment uses several availability mechanisms appropriate for the assignment:

* **Azure Load Balancer** provides a public entry point rather than exposing the Web VM directly.
* A **TCP health probe on port 80** checks whether the web tier is available.
* The Web VM is deployed in **Availability Zone 1**.
* The application has been separated into independent web, application, and database tiers.
* The backend and database are not directly exposed to the Internet.
* The frontend/backend services can be managed as persistent services using `systemd`.
* MySQL Flexible Server has automated backup retention configured.

A limitation is that the current deployment uses a single Web VM and single App VM, so it is **not fully highly available at the compute-tier level**. The Load Balancer provides the architecture for availability, but true redundancy would require multiple VM instances.

---

# 4. Security Choices

The deployment follows least-privilege principles as much as possible.

### Network isolation

The VNet is divided into:

* `Book-Review-Web-Subnet`
* `Book-Review-App-Subnet`
* `Book-Review-DB-Subnet`

The application and database tiers use private IP addresses.

### Network Security Groups

The Web subnet has an NSG allowing HTTP traffic on port 80 and administrative SSH access.

The App subnet has its own NSG and the database is isolated within its database subnet.

### Public exposure

The Web VM does **not** have its own public IP.

The public IP belongs to the Azure Load Balancer:

```text
20.87.118.115
```

This means the public entry point is controlled through the Load Balancer rather than exposing individual backend resources.

### Database security

MySQL:

* Uses private networking.
* Has public access disabled.
* Uses SSL/TLS.
* Is placed behind the database subnet.

This prevents direct public access to the database.

---

# 5. Secrets Management

Database credentials are **not stored in the source code**.

The backend uses environment variables such as:

```text
DB_HOST
DB_NAME
DB_USER
DB_PASS
DB_PORT
```

The database password was kept out of screenshots and was not exposed in commands used for evidence.

For the final production architecture, **Azure Key Vault** is the preferred secure secret-management mechanism. The current implementation uses environment-based configuration while ensuring that secret values are not committed to the repository or exposed in the assignment evidence.

# 6. Monitoring and Health Checks

The deployment includes health and monitoring mechanisms at several levels:

* Azure Load Balancer TCP health probe on port 80.
* Azure resource and VM status monitoring.
* Nginx service status.
* Backend listening-port verification on port 3001.
* Local API testing using `/api/books`.
* Azure Activity Log for resource operations.
* Azure Network Watcher was used during troubleshooting to diagnose connectivity between the application and web tiers.

The application was also validated from the public endpoint rather than relying only on local VM tests.

# 7. Backup and Recovery

Azure Database for MySQL Flexible Server was configured with:

* **7-day backup retention**
* Storage autogrowth enabled
* SSL/TLS enforced
* Private network connectivity

The database is therefore protected by Azure-managed automated backups and can be recovered within the configured retention window.

For a stronger production design, the next improvement would be to document and test a restore procedure and consider a longer backup retention period depending on business requirements.

**Key evidence achieved:** the public API successfully returned database records, and a new book record was successfully written and subsequently retrieved. This is strong evidence that the database-backed application path is functioning end-to-end.


---

# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, keys, connection strings, or subscription IDs

---

# Completion Checklist

- [ ] Task 1: Architecture diagram and assumptions documented (Screenshots 1–2)
- [ ] Task 2: Network foundation created with isolated tiers (Screenshots 3–5)
- [ ] Task 3: Least-privilege security and secret management configured (Screenshots 6–7)
- [ ] Task 4: Presentation tier deployed (Screenshots 8–9)
- [ ] Task 5: Application tier deployed privately (Screenshots 10–12)
- [ ] Task 6: Managed database tier deployed privately (Screenshots 13–15)
- [ ] Task 7: Public entry, internal routing, and monitoring configured (Screenshots 16–18)
- [ ] Task 8: End-to-end validation and availability test completed (Screenshots 19–22, Public Endpoint, Notes)
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
