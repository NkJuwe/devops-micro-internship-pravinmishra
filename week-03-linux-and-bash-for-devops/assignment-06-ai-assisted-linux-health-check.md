# Assignment 6 — Build an AI-Assisted Linux Health Check (AI-Assisted Linux Incident Triage)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash triage script that checks the health of your Ubuntu server and Nginx application, connect it to Claude Code as a reusable `/linux-triage` skill, simulate a controlled Nginx incident, use the skill to gather and analyze evidence, recover the service manually, and verify recovery. The workflow follows the Agentic Loop: Gather → Analyze → Human Act → Verify.

---

# Task 1 — Confirm the Healthy Baseline and Create the Workspace

## Goal

Confirm that Nginx and the React application are healthy before building the automation.

### Evidence

#### Screenshot 1 — Output of `systemctl is-active nginx`, `ss -ltn | grep ':80'`, and `curl -I http://localhost`

<img width="502" height="640" alt="Screenshot 2026-07-20 224631" src="https://github.com/user-attachments/assets/92741cd5-21d5-4107-984e-2e08028669fc" />

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort` showing the workspace folder structure

<img width="852" height="776" alt="Screenshot 2026-07-20 224907" src="https://github.com/user-attachments/assets/54eb9c6a-7908-40b7-87f0-b45360eb0009" />

---

### Notes

Answer the following in your own words:

**1. What proves that Nginx is running?**

The command: systemctl is-active nginx

returned: active

showing that the Nginx service is currently running.
---

**2. What proves that the server is listening for HTTP traffic?**

The command: ss -ltn | grep ':80'

showed port 80 in a listening state, proving that Nginx is accepting HTTP connections.

---

**3. Why must you capture a healthy baseline before simulating an incident?**

A healthy baseline provides a comparison point. During an incident, we can identify exactly what changed instead of guessing.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Tell Claude exactly what this project does and what it is not allowed to do.

### Evidence

#### Screenshot 3 — CLAUDE.md open in VS Code showing all four sections (Project Overview, Incident Workflow, Safety Rules, Output Rules)

<img width="944" height="812" alt="Screenshot 2026-07-21 160527" src="https://github.com/user-attachments/assets/d0796277-9cd1-4982-ad1c-9c870bd50559" />
<img width="932" height="808" alt="Screenshot 2026-07-21 160557" src="https://github.com/user-attachments/assets/8b3ea778-718d-4403-8417-2c5f63251d7c" />

---

### Notes

Answer the following in your own words:

**1. Why should Claude receive project-specific operational rules?**

Claude should receive project-specific operational rules because every environment has different requirements, risks, and boundaries. The rules guide Claude on what it can and cannot do, ensuring it follows the correct incident workflow and focuses on analyzing evidence instead of making unsafe changes. This helps keep operations controlled and prevents accidental actions on the server.Add your answer here.

---

**2. Why is the human required to execute the recovery command?**

The human is required to execute the recovery command because restarting or modifying services can affect system availability. Even when AI provides a recommendation, the engineer must review the evidence, confirm the action is appropriate, and approve the change. This keeps accountability with the operator and prevents unauthorized or incorrect recovery actions.

---

**3. Which rule prevents Claude from making an unsupported diagnosis?**

"Do not claim a root cause unless the report contains supporting evidence."

This ensures Claude bases its analysis only on the information collected by the Bash health-check script instead of making assumptions or guessing the cause of an incident.

---

# Task 3 — Use Agentic AI to Plan Before Writing the Script

## Goal

Use Claude Code to inspect the environment and produce a read-only plan before creating any Bash code.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan and read-only inspection results

<img width="1410" height="770" alt="Screenshot 2026-07-21 012434" src="https://github.com/user-attachments/assets/de717de4-c6f8-4c44-8be7-51be408ff196" />

---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

The Gather phase was when Claude inspected the Ubuntu server using read-only commands and reviewed the available information to understand the current system state. In this task, the evidence gathering involved checking the environment and identifying the required health checks: Nginx service status, port 80 listening status, localhost HTTP response, disk usage, and available memory.

---

**2. Did Claude follow the instruction not to create files? How did you verify this?**

Yes, Claude followed the instruction not to create or modify any files. I verified this by reviewing Claude’s response and confirming that it only provided a health-check plan and used read-only inspection. I also checked the project directory afterward to confirm that no new files were created or existing files were modified.

---

**3. Why is planning before coding useful in DevOps automation?**

Planning before coding is useful because it helps define the exact problem, required checks, and expected outcomes before making changes. It reduces mistakes, prevents unnecessary automation, and ensures that the script collects the right evidence consistently. In DevOps, this approach helps create safer and more reliable automation workflows.

---

# Task 4 — Build the Linux Triage Bash Script

## Goal

Create one Bash script that gathers consistent Linux and Nginx health evidence.

### Evidence

#### Screenshot 5 — Top section of `linux-triage.sh` showing variables, thresholds, and the checks array

<img width="698" height="680" alt="Screenshot 2026-07-21 162737" src="https://github.com/user-attachments/assets/20864f42-3d82-434a-9e9c-698848c526f4" />
<img width="704" height="718" alt="Screenshot 2026-07-21 162758" src="https://github.com/user-attachments/assets/c504adbb-89ae-4ffb-99b5-2a9fe6a943d6" />

---

#### Screenshot 6 — Middle section showing check functions and conditionals

<img width="1310" height="770" alt="Screenshot 2026-07-21 013517" src="https://github.com/user-attachments/assets/d46f5b7f-06bb-42e4-8c7b-252c2bc24f25" />

<img width="1260" height="788" alt="Screenshot 2026-07-21 013552" src="https://github.com/user-attachments/assets/ddbb9e94-2eaf-4845-8d4d-27c83c7b2d1a" />

---

#### Screenshot 7 — Bottom section showing the loop, summary function, and exit behavior

<img width="1342" height="776" alt="Screenshot 2026-07-21 013613" src="https://github.com/user-attachments/assets/f089b49a-2442-40f4-abe0-b74758497c43" />


---

#### Screenshot 8 — Output of `bash -n scripts/linux-triage.sh` (no syntax errors) and `ls -l scripts/linux-triage.sh` showing executable permission

<img width="1178" height="810" alt="Screenshot 2026-07-21 013921" src="https://github.com/user-attachments/assets/e49b7012-3677-496e-9078-af2cf1e08bcd" />

---

### Notes

Answer the following in your own words:

**1. What is stored in the checks array?**

The checks array stores the names of the five health-check functions that the script needs to execute:

checks=(
check_service
check_port
check_http
check_disk
check_memory
)

The functions represent the different areas being monitored:

check_service → checks if the Nginx service is running
check_port → checks if port 80 is listening for HTTP traffic
check_http → checks if the application responds through localhost
check_disk → checks the root disk usage percentage
check_memory → checks available system memory

The array allows the script to store the checks in an organized way and execute them systematically.

---

**2. How does the `for` loop use that array?**

The for loop goes through each function name stored in the array and executes it one by one.

The code:

for check_function in "${checks[@]}"
do
    "$check_function"
done

works like this:

The loop takes the first item:
check_service

and runs:

check_service
Then it moves to:
check_port

and runs:

check_port
It continues until all five functions have been executed.

This makes the script reusable because adding another health check only requires adding another function name to the array.

---

**3. Why are the health checks separated into functions?**

The health checks are separated into functions to make the script easier to read, maintain, and troubleshoot.

Each function has one specific responsibility:

check_service() only checks Nginx status
check_port() only checks network listening status
check_http() only checks application availability

This follows the principle of separation of concerns, where each part of the script performs one clear task.

Benefits include:

Easier troubleshooting when a check fails
Code can be reused
Changes can be made to one check without affecting others
The script structure is cleaner and easier for other engineers to understand

---

**4. What is the purpose of `$(...)` in this script?**

$(...) is called command substitution in Bash.

It allows the output of a Linux command to be captured and stored inside a variable or inserted into text.

Examples from the script: base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

The commands inside $(...) are executed, and the output becomes the value of base_dir.

Another example: write_line "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"

The script runs: date

and inserts the result into the report.

Example output: Timestamp: 2026-07-21T01:30:00Z

Another example:

write_line "Hostname: $(hostname)"

runs: hostname

and records the server name in the report.

Command substitution allows the script to collect live system information automatically.

---

**5. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

The script uses different exit codes so that other systems or automation tools can understand the result without reading the entire report.

The exit codes are:

Status	Exit Code	Meaning
HEALTHY	0	All checks passed
WARN	1	System is working but attention may be needed
FAIL	2	A critical check failed

The logic:

if [ "$failure_count" -gt 0 ]
then
    script_exit_code=2
elif [ "$warning_count" -gt 0 ]
then
    script_exit_code=1
else
    script_exit_code=0
fi

allows monitoring tools, CI/CD pipelines, or other automation systems to quickly determine the health status.

For example:

./linux-triage.sh
echo $?

If it returns: 0

the system is healthy.

If it returns: 2

there is a failure requiring attention.

This supports reliable DevOps automation because machines can interpret the result automatically.

---

# Task 5 — Run and Understand the Healthy-State Report

## Goal

Run the Bash script against the healthy server and verify that it creates a report.

### Evidence

#### Screenshot 9 — Output of `./scripts/linux-triage.sh` showing your Full Name and all five check results

<img width="1116" height="840" alt="Screenshot 2026-07-21 123017" src="https://github.com/user-attachments/assets/bd53893d-1122-46b5-be50-860998c3bc54" />

---

#### Screenshot 10 — Output showing the captured exit code and final summary

<img width="1044" height="836" alt="Screenshot 2026-07-21 123856" src="https://github.com/user-attachments/assets/322dad34-7772-4b36-b045-79936a8fde31" />


---

### Notes

Answer the following in your own words:

**1. What is the overall status of your healthy baseline?**

The evidence proving the application is serving traffic is:

[PASS] Nginx service is active

and:

[PASS] Port 80 is listening

and most importantly:

[PASS] Local HTTP check returned status 200

The HTTP status code 200 confirms that the server successfully responded to a request from:

curl http://localhost

This proves that Nginx is running, accepting HTTP connections, and serving the application locally.

---

**2. Which exact Linux evidence proves the application is serving traffic?**

The script returned:

Script Exit Code: 2

It did not return 0 or 1.

The exit code was 2 because one critical check failed:

[FAIL] Root disk usage is 98%

The script logic is:

Exit code 0 → HEALTHY (all checks passed)
Exit code 1 → WARN (only warnings exist)
Exit code 2 → FAIL (one or more checks failed)

Since the disk usage exceeded the failure threshold of 90%, the script returned 2.

---

**3. Did your script return exit code 0 or 1? Explain why.**

My script returned exit code 1.

This is because the final output showed:

Overall Status: WARN
Script Exit Code: 1

Even though there were no FAIL results, the script still detected a warning condition, which was the root disk usage at 84%. The script is designed to return exit code 1 whenever there is either a WARN or FAIL, since the system is not fully in a healthy state. Only when all checks pass with no warnings does the script return exit code 0.

---

**4. What is the difference between a warning and a failure in this script?**

A warning means the system is still operating, but attention may be needed.

A failure means a critical health check has exceeded the allowed limit or the application may be affected.

In this script:

Warning examples:

Disk usage between 80% and 89%
Available memory below 100MB

The script continues but reports:

[WARN]

Failure examples:

Nginx service is not active
Port 80 is not listening
HTTP check does not return 200
Disk usage reaches 90% or higher

The script reports:

[FAIL]

and returns exit code 2.

---

# Task 6 — Create and Run the /linux-triage Skill

## Goal

Turn the Bash script into a reusable, manually invoked Agentic AI workflow.

### Evidence

#### Screenshot 11 — `SKILL.md` showing the frontmatter, allowed tool restrictions, and safety rules

<img width="1046" height="410" alt="Screenshot 2026-07-21 123223" src="https://github.com/user-attachments/assets/6ce3197e-b465-40ac-bab2-230e809dbcf1" />

---

#### Screenshot 12 — `/linux-triage` output for the healthy server

<img width="1428" height="540" alt="Screenshot 2026-07-21 125641" src="https://github.com/user-attachments/assets/e75b5f06-a10a-4045-b438-965d25fbe4d9" />

---

### Notes

Answer the following in your own words:

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

The skill only includes Bash, Read, and Grep because it is designed to be safe and read-only.

Bash - runs Linux commands (e.g., systemctl, df, curl)
Read - reads files like logs or reports
Grep - filters and searches output

It does not include Write because:

The goal is to inspect system health, not change it
Prevents accidental modification or damage to the server
Ensures the script behaves like a diagnostic tool, not a repair tool

This follows best practice in incident triage: observe first, do not change anything yet

---

**2. Why is `disable-model-invocation: true` useful for this skill?**

disable-model-invocation: true ensures that:

The skill only runs predefined commands
It does not generate new actions or guesses

This is useful because:

It makes results deterministic and consistent
Prevents Claude from making assumptions or hallucinating
Forces the system to rely on real Linux evidence, not AI interpretation

So instead of guessing, it behaves like a controlled diagnostic script

---

**3. What part is performed by Bash, and what part is performed by Claude?**

Bash (the script):

Executes actual system checks:
systemctl - service status
ss - port listening
curl - HTTP response
df - disk usage
free - memory
Collects real data from the server
Writes results into a report

Claude:

Interprets the results
Explains what PASS, WARN, and FAIL mean
Helps the user understand the system state
Suggests next steps (e.g., fix disk usage)

So:
Bash = data collection (facts)
Claude = analysis (meaning)

---

**4. Why is this better than asking Claude "Is my server healthy?" without giving it evidence?**

Asking:

"Is my server healthy?"

without evidence is unreliable because:

Claude cannot see your system directly
It may guess or give generic answers
There is no real-time data to verify health

Using this script is better because:

It provides actual Linux command outputs
Decisions are based on measurable metrics
Results are repeatable and auditable
It aligns with real DevOps practice: evidence-based diagnosis

For example, instead of guessing, you have proof:

[PASS] Local HTTP check returned status 200
[FAIL] Root disk usage is 98%

This allows accurate conclusions like:

The app is working 
The system is at risk due to disk usage 

---

# Task 7 — Simulate an Nginx Incident and Let the Skill Diagnose It

## Goal

Create a controlled service failure, gather evidence through Bash, and let Claude analyze the evidence without taking recovery action.

### Evidence

#### Screenshot 13 — Output showing Nginx is inactive and the HTTP request fails

<img width="700" height="282" alt="image" src="https://github.com/user-attachments/assets/ca8dddb1-0921-4750-b719-01cad94bda14" />

---

#### Screenshot 14 — `/linux-triage` output showing failed evidence, most likely cause, and a suggested recovery command

<img width="1064" height="802" alt="Screenshot 2026-07-21 124605" src="https://github.com/user-attachments/assets/a935d995-526f-4109-b179-eb4c2c292891" />

---

#### Screenshot 15 — `incident-failure-report.txt` showing the failed checks and your Full Name

<img width="1016" height="414" alt="Screenshot 2026-07-21 124819" src="https://github.com/user-attachments/assets/b874a7a7-f62d-4a0d-b040-54d1a73577e0" />

---

### Notes

Answer the following in your own words:

**1. Which three checks failed?**

NGINX service
Port 80
Local HTTP check

---

**2. What evidence supports the conclusion that Nginx is unavailable?**

The Bash triage report showed that the Nginx service was not active, port 80 was not listening, and the local HTTP request returned a failed response. These three pieces of evidence together confirm that the web server was not running and therefore unavailable..

---

**3. Did Claude execute the recovery command? Why is that important?**

No, Claude did not execute the recovery command. This is important because restarting services can impact system stability and availability. Keeping execution in human control ensures that actions are reviewed and approved before being applied, which prevents unintended changes or risks.

---

**4. Which phase of the Agentic Loop is represented by the Bash report?**

The Bash report represents the Gather phase because it collects system data and evidence about the current state of the server.

---

**5. Which phase is represented by Claude's explanation?**

Claude’s explanation represents the Analyze phase because it interprets the collected evidence and identifies the likely cause of the issue.

---

# Task 8 — Recover Manually, Verify Again, and Write the Incident Summary

## Goal

Recover the service as the human operator and prove that the system is healthy again.

### Evidence

#### Screenshot 16 — Output showing Nginx is active and `curl -I http://localhost` returns 200 OK

<img width="714" height="154" alt="Screenshot 2026-07-21 125201" src="https://github.com/user-attachments/assets/a33f9063-d2b8-4ede-babc-32ed26cf2637" />


---

#### Screenshot 17 — Second `/linux-triage` output showing successful recovery with no FAIL results

<img width="1428" height="540" alt="Screenshot 2026-07-21 125641" src="https://github.com/user-attachments/assets/27badb03-08cd-4506-ab88-7e3605d5645f" />


---

#### Screenshot 18 — Output of `ls -lah reports` showing both `incident-failure-report.txt` and `recovery-report.txt`

<img width="1270" height="856" alt="Screenshot 2026-07-21 125754" src="https://github.com/user-attachments/assets/41391911-efba-41f7-a3dd-f8cb080c4262" />


---

#### Screenshot 19 — `incident-summary.md` showing all required sections and your Full Name

<img width="1286" height="606" alt="Screenshot 2026-07-21 130020" src="https://github.com/user-attachments/assets/79af3689-d3d1-4c2d-8b48-57e8451db63f" />


---

### Notes

Answer the following in your own words:

**1. What action did you execute manually?**

I manually restarted the Nginx service using the command: sudo systemctl start nginx

---

**2. What evidence proves that the service recovered?**

The evidence includes:

The Nginx service status returned active
Port 80 was listening again
The curl request returned HTTP 200 OK
The triage script showed no failures for Nginx checks

---

**3. Why is the second triage run necessary?**

The second triage run is necessary to verify that the issue has actually been resolved. It confirms that all services are functioning correctly after the recovery action and ensures no new issues were introduced.

---

**4. What could go wrong if an AI agent automatically restarted every failed service?**

If an AI agent automatically restarted every failed service, it could cause unintended disruptions, restart critical services at the wrong time, or hide underlying issues without proper investigation. This could make problems worse instead of solving them.

---

**5. In one sentence, explain the difference between using AI as a chatbot and using AI in this agentic workflow.**

Using AI as a chatbot provides general answers, while this agentic workflow uses AI to analyze real system evidence and support controlled, human-approved operations.

---

# Incident Summary

Fill in all seven sections below in your own words.

**Full Name:** GIFT NKECH JUWE

**Date:** 21/07/2026

---

**1. Reported Symptom**

The web application was unavailable because the Nginx service was not running on the server.

---

**2. Evidence Collected**

The Bash triage script showed that the Nginx service was inactive, port 80 was not listening, and the HTTP request to localhost failed.

---

**3. Most Likely Cause**

The most likely cause was that the Nginx service had been stopped.

---

**4. Human-Approved Recovery Action**

After reviewing the evidence, I manually restarted the Nginx service using:

sudo systemctl start nginx

---

**5. Verification**

The service recovery was verified by confirming that Nginx was active, port 80 was listening, and the HTTP request returned a 200 OK response.

---

**6. Safety Decision**

Claude was only allowed to analyze the system and suggest a recovery action, while the actual execution was performed manually to maintain control and prevent unintended changes.

---

**7. Agentic Loop Mapping**

Gather: Bash collected system health data
Analyze: Claude reviewed and explained the issue
Human Act: I manually restarted the Nginx service
Verify: I reran the triage script to confirm recovery

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`(https://www.linkedin.com/posts/nkechi-juwe_devops-linux-bashscripting-ugcPost-7485386235834793984-JkDO/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M)`

---

#### Screenshot — Published LinkedIn post

<img width="554" height="716" alt="image" src="https://github.com/user-attachments/assets/679ea131-2bcc-4856-a519-531048945f12" />


---

# GitHub Repository URL

Paste the URL of your GitHub folder or repository containing the assignment files here:

`_https://github.com/NkJuwe/devops-micro-internship-pravinmishra.git`

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots and the Bash report
- All written answers must be in your own words
- Do not expose sensitive information (keys, passwords, AWS account IDs, tokens)
- GitHub URL must be included in this document

---

# Completion Checklist

- [ ] Task 1: Healthy baseline confirmed, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: CLAUDE.md created with all four sections (Screenshot 3, Notes answered)
- [ ] Task 3: Five-check plan produced by Claude using read-only tools (Screenshot 4, Notes answered)
- [ ] Task 4: `linux-triage.sh` created, syntax validated, executable permission set (Screenshots 5–8, Notes answered)
- [ ] Task 5: Healthy-state report generated with no FAIL result (Screenshots 9–10, Notes answered)
- [ ] Task 6: `/linux-triage` skill created and run successfully on healthy server (Screenshots 11–12, Notes answered)
- [ ] Task 7: Nginx incident simulated, failed evidence captured, Claude did not execute recovery (Screenshots 13–15, Notes answered)
- [ ] Task 8: Nginx recovered manually, recovery verified, reports saved, incident summary complete (Screenshots 16–19, Notes answered)
- [ ] Incident summary contains all seven required sections
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots and the Bash report
- [ ] Skill does not have Write permission
- [ ] Skill did not execute any recovery commands
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
