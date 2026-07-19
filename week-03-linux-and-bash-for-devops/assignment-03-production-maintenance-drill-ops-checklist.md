# Assignment 3 — Production Maintenance Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will treat your already deployed React application (on Ubuntu VM with Nginx) as a live production system. You will perform structured operational checks covering network validation, service health, log analysis, resource monitoring, configuration verification, and incident simulation with recovery — mirroring real on-call DevOps responsibilities.

---

# Task 1 — Server Access & Networking Validation

## Goal

Verify that the deployed React application is reachable from the browser and confirm basic network connectivity of the Ubuntu VM.

### Evidence

#### Screenshot 1 — Browser showing the React app with your Full Name visible on the UI

<img width="1322" height="672" alt="Screenshot 2026-07-19 170249" src="https://github.com/user-attachments/assets/17e50d1c-afc7-4cb4-88b4-415542ad7e63" />

---

#### Screenshot 2 — Output of `ip a`

<img width="694" height="210" alt="Screenshot 2026-07-19 182917" src="https://github.com/user-attachments/assets/1bd27cd8-6aa9-40dd-a612-e37e1bba23b1" />

---

#### Screenshot 3 — Output of `sudo ss -tulpen`

<img width="1428" height="850" alt="Screenshot 2026-07-19 183437" src="https://github.com/user-attachments/assets/046302b7-a598-43d2-93d9-3b5b177ec28c" />

---

#### Screenshot 4 — Output of `sudo ufw status`

<img width="458" height="54" alt="Screenshot 2026-07-19 183818" src="https://github.com/user-attachments/assets/895096fe-f221-4fc5-855e-6adf75236db5" />

---

### Notes

Answer the following in your own words:

**1. What proves Nginx is listening on 0.0.0.0:80?**

Nginx proves to be listening on 0.0.0.0:80 because the server successfully responds to HTTP requests made to its public IP address on port 80.
Nginx is actively listening on port 80 on all network interfaces (0.0.0.0) and is able to receive and respond to incoming web traffic.
---

**2. What proves SSH is active on port 22?**

SSH proves to be active on port 22 because I was able to successfully connect to the server remotely using SSH.
The active terminal session itself confirms that the SSH service is running and listening on port 22, since SSH connections rely on that port by default.

---

**3. Did you find any unexpected open ports? Explain briefly.**

No unexpected open ports were found during the checks.

The server appears to expose only the required ports:
Port 22 for SSH access
Port 80 for HTTP web traffic

This indicates that the server is properly configured with minimal exposure, which follows security best practices by reducing the attack surface.

---

# Task 2 — Service Health & Systemd Validation (Nginx)

## Goal

Verify that Nginx is properly installed, running, enabled at boot, and safely configured.

### Evidence

#### Screenshot 1 — Output of `systemctl status nginx --no-pager`

Add your screenshot here.

---

#### Screenshot 2 — Output of `sudo nginx -t`

<img width="980" height="312" alt="Screenshot 2026-07-19 183926" src="https://github.com/user-attachments/assets/fdbced9e-9619-443f-8baa-05ac5071da79" />

---

#### Screenshot 3 — Output of `sudo ss -lptn '( sport = :80 )'`

<img width="1402" height="56" alt="image" src="https://github.com/user-attachments/assets/2ffca8b7-501e-4eaf-a7b2-a6a6e4a3a4cc" />

---

### Notes

Answer the following in your own words:

**1. What happens if Nginx fails to restart in production?**

If Nginx fails to restart in production, the web application becomes unavailable to users because the server is no longer able to handle incoming HTTP requests.
This can lead to downtime, failed API calls, and a poor user experience. In some cases, users may see errors like 502 Bad Gateway, 503 Service Unavailable, or may not be able to connect at all.
It can also impact business operations if the application is critical, resulting in lost traffic or revenue. Immediate investigation and recovery are required to restore service.

---

**2. What's your basic rollback plan?**

My basic rollback plan is to quickly restore the last known working version of the application and configuration.

The steps include:
Restore the application files from a backup (e.g., /var/www/html_backup)
Revert any recent configuration changes if needed
Restart or reload Nginx to apply the restored state
Verify the application using a command like: curl -I http://<public-ip>

The goal is to minimize downtime by returning the system to a stable and previously verified state as quickly as possible.
---

# Task 3 — Logs & Request Trace

## Goal

Verify real traffic flow and analyze logs to understand system behavior and errors.

### Evidence

#### Screenshot 1 — Output of `sudo tail -n 30 /var/log/nginx/access.log`

<img width="1440" height="440" alt="Screenshot 2026-07-19 185231" src="https://github.com/user-attachments/assets/8d83092d-9f4b-49d9-a502-d20197923ddc" />

---

#### Screenshot 2 — Output of `sudo tail -n 30 /var/log/nginx/error.log`

<img width="1440" height="532" alt="Screenshot 2026-07-19 185507" src="https://github.com/user-attachments/assets/c569cee3-1318-45aa-82a6-96a8eaf61763" />

---

#### Screenshot 3 — Output of `sudo journalctl -u nginx --no-pager -n 50`

<img width="1440" height="676" alt="Screenshot 2026-07-19 185623" src="https://github.com/user-attachments/assets/571662a4-8ac6-4a09-8f2a-bb344ade3492" />

---

### Notes

Answer the following in your own words:

**1. Were there any errors in the logs?**

- If yes, mention 1–2 example error lines from the logs and explain what each one means in simple terms.
- If no, explain what it means if the error log is empty or shows no recent errors during your check.

No critical errors were found in the logs during the analysis.
The entries shown in the screenshot are system service messages such as:

starting nginx.service - A high performance web server...
started nginx.service - A high performance web server...
stopped nginx.service...

These are normal systemd service logs, not errors. They simply indicate that Nginx was started, stopped, or restarted successfully.
The Nginx error log earlier only showed a notice-level message (not an error), which means no failures were recorded.

This means that during the time of observation, there were no actual errors affecting the server.

---

**2. If there were no errors, what does that indicate about the system?**

If no errors are present in the logs, it indicates that the system and services (like Nginx) were operating normally during the time period checked.

It means:
The web server handled requests without failure
No crashes or misconfigurations were detected
Services started and stopped cleanly

However, this does not mean the system is permanently perfect. It only shows that no issues were recorded during the specific time window analyzed. Continuous monitoring is still required.
---

**3. Based on the access logs, were your curl requests visible in the log entries? What does that prove about traffic flow?**

Yes, the curl requests were clearly visible in the access logs.

Example: 127.0.0.1 - - [19/Jul/2026:15:40:40 +0000] "GET / HTTP/1.1" 200 644 "-" "curl/8.18.0"

This confirms that:
The request successfully reached the server
Nginx received and processed the request
The server returned a valid response (200 OK)

This proves that the traffic flow is working correctly:

Client → Nginx → Application → Response back to client

It verifies that the web server is properly handling incoming HTTP requests and serving content as expected.

---

# Task 4 — System Resource Health Check (Capacity Red Flags)

## Goal

Assess server capacity and detect potential performance or failure risks.

### Evidence

#### Screenshot 1 — Output of `uptime`

<img width="790" height="532" alt="Screenshot 2026-07-19 190730" src="https://github.com/user-attachments/assets/1dcd0f69-da32-4b4c-bbd7-b3e4c805431d" />

---

#### Screenshot 2 — Output of `free -h`

<img width="734" height="74" alt="Screenshot 2026-07-19 190753" src="https://github.com/user-attachments/assets/ca1abbff-f369-44ab-bfd8-3208e55e7016" />

---

#### Screenshot 3 — Output of `df -h`

<img width="734" height="506" alt="Screenshot 2026-07-19 190753" src="https://github.com/user-attachments/assets/261aff11-39a1-4e7e-a7da-ac4dcff4ee84" />

---

#### Screenshot 4 — Output of `sudo du -sh /var/* | sort -h`

<img width="780" height="544" alt="Screenshot 2026-07-19 190820" src="https://github.com/user-attachments/assets/c9ebb27e-0484-4320-8d26-4b4ecf15cb9d" />

---

### Notes

Answer the following in your own words:

**1. Which resource looks most critical right now? (CPU/load, memory, or disk) Explain why.**

Based on the system health checks, disk usage is the most important resource to monitor at the moment.

From the df -h output, the root filesystem shows: /dev/root  6.7G  5.2G  1.5G  78%

This means the server is currently using 78% of its available disk space. While the server is still operating normally, this is the resource that requires the most attention because continued growth from application files, logs, packages, or backups could eventually consume all available storage.

CPU/load is not a concern because the uptime command shows: load average: 0.00, 0.00, 0.00

This indicates the server is not under processing pressure.

Memory usage is also healthy. The free -h output shows:
Available memory: 605Mi

which means there is still sufficient memory available for normal operations.

Therefore, disk usage is the resource I would monitor most closely because storage exhaustion can directly affect application stability and server reliability.

---

**2. What happens if disk becomes 100% full in a production server?**

If a production server disk becomes 100% full, many system and application operations can fail because the server cannot write new data.

Some possible impacts include:

- Logs may stop writing because there is no space available for new log entries.
- Applications may fail because they cannot create temporary files or save required data.
- Nginx and other services may become unstable if they cannot write necessary files.
- System updates and package installations may fail.
- The server may become slow, unresponsive, or difficult to manage.

To prevent this, production systems should have disk monitoring alerts, log rotation, regular cleanup processes, and capacity planning to ensure storage does not reach critical levels.

---

# Task 5 — Configuration & Deployment Verification

## Goal

Ensure the correct React build is deployed and Nginx is serving it properly.

### Evidence

#### Screenshot 1 — Output of `ls -lah /var/www/html | head -n 20`

<img width="576" height="178" alt="Screenshot 2026-07-19 191840" src="https://github.com/user-attachments/assets/824785dc-7752-436b-b086-e4527fb79f72" />

---

#### Screenshot 2 — Output of `grep -R "Deployed by" -n /var/www/html 2>/dev/null | head`

<img width="1436" height="680" alt="Screenshot 2026-07-19 191917" src="https://github.com/user-attachments/assets/23bc7be9-c4a9-4a83-91a2-ee4fa726685f" />
<img width="1420" height="836" alt="Screenshot 2026-07-19 195025" src="https://github.com/user-attachments/assets/fff2948f-b124-490e-829f-74f5740c4b13" />

---

#### Screenshot 3 — Output of `grep -n "try_files" /etc/nginx/sites-available/default`

<img width="646" height="86" alt="Screenshot 2026-07-19 200157" src="https://github.com/user-attachments/assets/3b5093e4-7e35-4142-a34b-75f95efb03e8" />

---

### Notes

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

I confirm that the correct version of the application is deployed by checking for a unique identifier that I added to the application, such as the text "Deployed by <my name>", and verifying that the expected files exist in the deployment directory.

Evidence from grep command

I used the command:

grep -R "Deployed by" -n /var/www/html 2>/dev/null | head

This searches through the deployed application files for the custom text.

The output showed a match inside the deployed files (in the JavaScript bundle), which confirms that my modified version of the application was successfully built and deployed to the server.

Evidence from directory listing

I also used:

ls -lah /var/www/html | head -n 20

This command shows the contents of the deployment directory.

The output confirmed that:

The directory contains expected web application files such as index.html
It includes folders like static/ which hold CSS and JavaScript assets
File sizes and timestamps indicate a recent build and deployment

This verifies that the application files are present and correctly structured for Nginx to serve.

By combining both checks:

The presence of the "Deployed by" text confirms the correct application version
The directory structure and files confirm a successful deployment

Together, these prove that the intended version of the application is currently deployed and being served by the server.
---

# Task 6 — Nginx Configuration Failure Simulation

## Goal

Simulate a real-world Nginx misconfiguration and recover the service safely.

### Evidence

#### Screenshot 1 — Output of `sudo nginx -t` showing the syntax error (broken config)

<img width="732" height="140" alt="Screenshot 2026-07-19 201753" src="https://github.com/user-attachments/assets/60a9eacf-953f-4f9a-be24-f452e987824f" />

---

#### Screenshot 2 — Output of `sudo nginx -t` showing syntax ok (fixed config)

<img width="702" height="194" alt="Screenshot 2026-07-19 211621" src="https://github.com/user-attachments/assets/15d5ea13-c040-4a16-9991-5c22705486c6" />

---

#### Screenshot 3 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

<img width="1094" height="854" alt="Screenshot 2026-07-19 211446" src="https://github.com/user-attachments/assets/bbeb6edf-cf25-4d56-9984-2d324f6b1df8" />

---

### Notes

Answer the following in your own words:

**1. What caused the configuration failure?**

The configuration failure was caused by a syntax error in the Nginx configuration file.

This could include issues such as a missing semicolon (;), incorrect directive format, or an invalid configuration block. When Nginx was tested using:

sudo nginx -t

it reported a syntax error, which means Nginx could not properly read or interpret the configuration file.

Because of this, Nginx could not restart or reload successfully, leading to service disruption.

---

**2. How did you fix the issue?**

The issue was fixed by identifying and correcting the syntax error in the Nginx configuration file.

After reviewing the error message from: sudo nginx -t

I located the exact line causing the problem and corrected the mistake (such as adding a missing semicolon or fixing a directive).

I then re-ran: sudo nginx -t

to confirm:
syntax is ok
test is successful

After confirming the fix, I reloaded/restarted Nginx: sudo systemctl restart nginx

Finally, I verified recovery using: curl -I http://<public-ip>

which returned: HTTP/1.1 200 OK

confirming that the server was working correctly again.

---

**3. How can you avoid this kind of issue in real production systems?**

In real production systems, this type of issue can be avoided by following best practices:

Always test configuration changes before applying them using: sudo nginx -t

- Use version control (e.g., Git) to track and review configuration changes before deployment
- Implement CI/CD pipelines to automatically validate configurations before they reach production
- Use staging environments to test changes safely before applying them to live systems
- Apply changes gradually (e.g., reload instead of full restart when possible)
- Enable monitoring and alerts to detect failures immediately

These practices reduce the risk of downtime and ensure safer, more reliable deployments.

---

# Task 7 — Web Application Failure Simulation

## Goal

Simulate missing deployment content and recover the application safely.

### Evidence

#### Screenshot 1 — Output of `curl -I http://<public-ip>` showing failure (non-200 response)

<img width="1058" height="848" alt="image" src="https://github.com/user-attachments/assets/275640b0-076d-4965-acf9-325845222384" />

---

#### Screenshot 2 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

<img width="860" height="828" alt="Screenshot 2026-07-19 212448" src="https://github.com/user-attachments/assets/08e8b5e8-f73d-4d68-a546-70a8ada23f6a" />

---

### Notes

Answer the following in your own words:

**1. What caused the application to break in this scenario?**

The application broke because the main web content directory (/var/www/html) was removed and replaced with an empty directory.

Nginx depends on this directory to serve the website files (such as index.html, JavaScript, and CSS). When the directory was empty, the server could not find the required files to respond properly to incoming requests.

This is why the server returned: HTTP/1.1 500 Internal Server Error

This indicates that the server encountered a problem while trying to process the request due to missing application content.

---

**2. How did you fix the issue and restore the application?**

The issue was fixed by restoring the original application files from the backup.

The following steps were taken:

The empty directory was removed: sudo rm -rf /var/www/html

The backup directory was restored: sudo mv /var/www/html_backup /var/www/html

Nginx was restarted to reload the configuration and apply the restored files: sudo systemctl restart nginx

The application was verified using: curl -I http://16.16.171.10

The response returned: HTTP/1.1 200 OK

This confirms that the application was successfully restored and is serving content correctly again.

---

**3. What steps would you take to prevent this kind of issue in real production systems?**

In a real production environment, several measures would be implemented to prevent this type of failure:

Regular backups: Maintain automated backups of application files so recovery is fast and reliable.
Access control: Restrict permissions so only authorized users can modify or delete critical directories like /var/www/html.
Deployment automation: Use CI/CD pipelines to manage deployments instead of manual file operations, reducing the risk of accidental deletion.
Monitoring and alerts: Set up monitoring tools to detect application failures (e.g., non-200 responses) and notify engineers immediately.
Use of staging environments: Test changes in a staging environment before applying them to production.
Infrastructure as Code (IaC): Use tools like Terraform or Ansible to recreate environments quickly if something goes wrong.

These practices help ensure system reliability, quick recovery, and reduced risk of human error.

---

# Task 8 — Security & Reliability Review

## Goal

Review and reflect on the security and reliability practices applied during this assignment.

### Security & Reliability Notes

Answer the following in your own words:

**1. Why is SSH key-based authentication more secure than sharing passwords?**

SSH key-based authentication is more secure because it uses cryptographic key pairs instead of passwords. A private key stays on the user's machine and is never transmitted over the network, while the public key is stored on the server.

Unlike passwords, which can be guessed, reused, or exposed through brute-force attacks, SSH keys are significantly harder to crack due to their complexity and length. This reduces the risk of unauthorized access and improves overall server security.

---

**2. Why should only required ports be open on a production server?**

Only required ports should be open to minimize the server’s attack surface.

Every open port is a potential entry point for attackers. By restricting open ports to only those necessary (e.g., port 22 for SSH, port 80/443 for web traffic), the risk of unauthorized access, exploitation, or scanning attacks is reduced.

This practice follows the principle of least privilege and improves system security.
---

**3. Why is it important for Nginx to be enabled on boot?**

Enabling Nginx on boot ensures that the web server starts automatically whenever the system is restarted.

This is important for maintaining application availability. Without this configuration, the server could reboot and leave the application offline until manually restarted, causing downtime and impacting users.

Automatic startup ensures consistent service reliability.
---

**4. What are the risks of sharing secrets, keys, or credentials publicly?**

Sharing secrets, keys, or credentials publicly can lead to serious security breaches.

Attackers can use exposed credentials to gain unauthorized access to servers, databases, or cloud resources. This can result in data theft, service disruption, financial loss, or complete system compromise.

Once exposed, secrets must be considered compromised and should be rotated immediately.

---

**5. Why should cloud resources be stopped or terminated when they are no longer needed?**

Cloud resources should be stopped or terminated when not in use to avoid unnecessary costs and reduce security risks.

Running unused resources continues to incur charges and may also expose idle systems to potential attacks if they remain accessible.

Proper resource management ensures cost efficiency and reduces the attack surface in cloud environments.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/nkechi-juwe_devops-nginx-linux-ugcPost-7484731948322639872-d8DB/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M`

---

#### Screenshot — Published LinkedIn post

<img width="564" height="772" alt="image" src="https://github.com/user-attachments/assets/0112c684-c229-45d2-a0c2-4a288465c7ef" />

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Task 1: Screenshots (browser, ip a, ss -tulpen, ufw status) + Notes answered
- [ ] Task 2: Screenshots (nginx status, nginx -t, ss port 80) + Notes answered
- [ ] Task 3: Screenshots (access log, error log, journalctl) + Notes answered
- [ ] Task 4: Screenshots (uptime, free -h, df -h, du -sh) + Notes answered
- [ ] Task 5: Screenshots (ls html, grep deployed by, grep try_files) + Notes answered
- [ ] Task 6: Screenshots (nginx -t fail, nginx -t pass, curl recovery) + Notes answered
- [ ] Task 7: Screenshots (curl failure, curl recovery) + Notes answered
- [ ] Task 8: Security & Reliability Notes answered
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
