# Assignment 5 — Bash Script Automation Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will practice Bash scripting by building a series of small automation scripts covering environment setup, variables, arrays, loops, file conditionals, if-else logic, and functions. These scripts form the foundation of real-world Linux automation used in DevOps, cloud, and production support environments.

---

# Task 1 — Bash Environment & Workspace Setup

## Goal

Verify that Bash is available on your system and create a clean workspace for this assignment.

### Evidence

#### Screenshot 1 — Output of `echo $SHELL` and `bash --version`

<img width="984" height="620" alt="Screenshot 2026-07-20 212122" src="https://github.com/user-attachments/assets/c9441f4a-b47a-4636-8a3a-9daa53ef5bd0" />

---

#### Screenshot 2 — Output of `pwd` and `ls -lah` showing the scripts directory

<img width="922" height="630" alt="Screenshot 2026-07-20 212230" src="https://github.com/user-attachments/assets/21683263-f487-45dd-a50f-356843a0a5af" />

---

### Notes

Answer the following in your own words:

**1. What is Bash?**

Bash is a command-line interpreter that allows me to interact with the Linux system by typing commands. It also allows me to write scripts to automate tasks instead of doing them manually every time.

---

**2. What is the difference between shell and Bash?**

A shell is a general interface that allows users to communicate with the operating system. Bash is a type of shell, specifically one of the most widely used shells in Linux systems. So Bash is just one example of a shell.

---

**3. Why is it important to confirm the Bash version before writing scripts?**

It is important to confirm the Bash version to ensure compatibility, because some features or syntax may not work in older versions. Knowing the version helps avoid errors when running scripts.

---

# Task 2 — Your First Bash Script

## Goal

Create your first Bash script, make it executable, and run it from the terminal.

### Evidence

#### Screenshot 1 — Content of `first-script.sh`

<img width="926" height="608" alt="Screenshot 2026-07-20 212417" src="https://github.com/user-attachments/assets/f0232a66-8e6e-4dc7-a4ff-e7a16515ffde" />

---

#### Screenshot 2 — Output of `./first-script.sh`

<img width="930" height="622" alt="Screenshot 2026-07-20 212547" src="https://github.com/user-attachments/assets/5257f44b-32ec-409f-b5b2-b36f4efa07ef" />

---

#### Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission

<img width="810" height="626" alt="Screenshot 2026-07-20 212656" src="https://github.com/user-attachments/assets/af133536-8701-4088-bfc0-97babe8506ff" />

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `#!/bin/bash`?**

The #!/bin/bash line, also called a shebang, tells the system that the script should be executed using the Bash interpreter. It ensures the script runs in the correct environment.

---

**2. Why do we use `chmod +x` before running a script?**

We use chmod +x to make the script executable. By default, a script does not have permission to run, so this command allows the system to treat it like a program.

---

**3. What is the difference between running a script using `./script.sh` and `bash script.sh`?**

./script.sh runs the script as an executable file, while bash script.sh runs the script using the Bash interpreter directly. The first requires execute permission, but the second does not.

---

# Task 3 — Variables: User Information Script

## Goal

Use variables to store and display user-related information.

### Evidence

#### Screenshot 1 — Content of `user-info.sh`

<img width="894" height="632" alt="Screenshot 2026-07-20 212748" src="https://github.com/user-attachments/assets/7c37d5e7-09ae-43e1-8498-c185970a8527" />

---

#### Screenshot 2 — Output of `./user-info.sh`

<img width="874" height="624" alt="Screenshot 2026-07-20 212828" src="https://github.com/user-attachments/assets/64ff86f9-ebb7-462a-8aae-1d770beb02ea" />

---

### Notes

Answer the following in your own words:

**1. What is a variable in Bash?**

A variable in Bash is used to store data that can be reused in a script. It helps make scripts more flexible and easier to manage.

---

**2. Why should we avoid spaces around the `=` sign when creating variables?**

Spaces are not allowed when assigning values to variables in Bash. If spaces are added, Bash will interpret it incorrectly and throw an error.

---

**3. How do you access the value stored inside a Bash variable?**

The value of a variable is accessed using the $ symbol followed by the variable name, for example $full_name..

---

# Task 4 — Arrays & Loops: Tools Checklist Script

## Goal

Use arrays and loops to print a checklist of tools used in Bash scripting.

### Evidence

#### Screenshot 1 — Content of `tools-checklist.sh`

<img width="984" height="622" alt="Screenshot 2026-07-20 212912" src="https://github.com/user-attachments/assets/b180948d-d0f2-45b7-855d-207c181deff7" />

---

#### Screenshot 2 — Output of `./tools-checklist.sh`

<img width="808" height="616" alt="Screenshot 2026-07-20 212954" src="https://github.com/user-attachments/assets/84615f71-a070-49c5-acaf-1beb8775a2db" />

---

### Notes

Answer the following in your own words:

**1. What is an array in Bash?**

An array is a data structure used to store multiple values in a single variable. Each value can be accessed individually.

---

**2. Why are arrays useful in scripts?**

Arrays are useful because they allow us to manage multiple related values easily, especially when working with loops or repetitive tasks.

---

**3. What does `"${tools[@]}"` mean?**

It represents all the elements in the array. It allows the loop to go through each item one by one.

---

**4. What is the purpose of the `for` loop in this script?**

The for loop is used to iterate through each item in the array and perform an action, in this case printing each tool.

---

# Task 5 — Loops: Number Counter Script

## Goal

Use loops to repeat a task multiple times.

### Evidence

#### Screenshot 1 — Content of `counter.sh`

<img width="840" height="620" alt="Screenshot 2026-07-20 213031" src="https://github.com/user-attachments/assets/189e63f3-81e2-468e-aaa2-3f25e4479d9c" />

---

#### Screenshot 2 — Output of `./counter.sh`

<img width="854" height="638" alt="Screenshot 2026-07-20 213111" src="https://github.com/user-attachments/assets/f1b8c330-7762-4ca0-87e4-31716770512b" />

---

### Notes

Answer the following in your own words:

**1. What is a loop?**

A loop is used to repeat a set of commands multiple times until a condition is met or until all items are processed.

---

**2. Why do we use loops in Bash scripting?**

Loops help automate repetitive tasks, making scripts more efficient and reducing the need for manual repetition.

---

**3. How many times did the loop run in your script?**

The loop in my script ran 5 times because I set the range from 1 to 5.

---

**4. What would you change if you wanted the loop to run 10 times?**

If I wanted the loop to run 10 times, I would change the range in the loop from {1..5} to {1..10} so that it iterates 10 times instead of 5.
---

# Task 6 — Files & Conditionals: File Validation Script

## Goal

Use file checks and conditionals to verify whether files and directories exist.

### Evidence

#### Screenshot 1 — Output of `ls -lah ../test-folder`

<img width="890" height="620" alt="Screenshot 2026-07-20 213151" src="https://github.com/user-attachments/assets/89a90e7b-c729-4f7a-b1aa-bf83700e65a6" />

---

#### Screenshot 2 — Content of `file-check.sh`

<img width="1034" height="604" alt="Screenshot 2026-07-20 213308" src="https://github.com/user-attachments/assets/9f3f5f52-5bca-429f-8f40-f4312ff45a3d" />

---

#### Screenshot 3 — Output of `./file-check.sh`

<img width="820" height="608" alt="Screenshot 2026-07-20 213357" src="https://github.com/user-attachments/assets/f929ed9b-e49d-405a-ab82-285ecea8172a" />

---

### Notes

Answer the following in your own words:

**1. What does `-d` check in Bash?**

-d is used to check if a directory exists.

---

**2. What does `-f` check in Bash?**

-f is used to check if a file exists.

---

**3. Why should file and directory paths be stored in variables?**

File checks help ensure that required files or directories exist before performing operations. This prevents errors and makes scripts more reliable.

---

**4. What happens if the file does not exist?**

If the file does not exist, the condition that checks for the file will fail, and the script will usually execute the else part. In my script, it prints a message indicating that the file does not exist instead of continuing with the operation.

---

# Task 7 — Conditionals: Pass or Retry Script

## Goal

Use if-else conditionals to make decisions based on a variable value.

### Evidence

#### Screenshot 1 — Content of `score-check.sh` with `score=85`

<img width="796" height="608" alt="Screenshot 2026-07-20 213443" src="https://github.com/user-attachments/assets/ffe75ce7-5c24-4d70-8ba4-fbc9eb169910" />

---

#### Screenshot 2 — Output showing `Result: Pass`

<img width="580" height="342" alt="Screenshot 2026-07-18 204529" src="https://github.com/user-attachments/assets/8b784b22-25fc-4839-967c-4f34ccffe7bc" />

---

#### Screenshot 3 — Content of `score-check.sh` with `score=55`

<img width="582" height="346" alt="Screenshot 2026-07-18 204730" src="https://github.com/user-attachments/assets/9bc0e540-c288-4a41-ad20-091f5070d271" />

---

#### Screenshot 4 — Output showing `Result: Retry`

<img width="866" height="624" alt="Screenshot 2026-07-20 213550" src="https://github.com/user-attachments/assets/502be07d-7c1c-494e-8a8b-8eb60a85c1fa" />

---

### Notes

Answer the following in your own words:

**1. What is the purpose of if-else in Bash?**

An if-else statement is used to make decisions in a script. It allows the script to execute different commands based on conditions.

---

**2. What does `-ge` mean?**

-ge means “greater than or equal to.” It is used in conditions to compare two values and check if one is greater than or equal to the other.

---

**3. Why should conditions be tested with different values?**

Conditions should be tested with different values to make sure the script works correctly in all situations. It helps confirm that both the if and else parts behave as expected and prevents unexpected errors.

---

**4. How can conditionals help in automation scripts?**

Conditionals help automation scripts make decisions based on different situations. This allows the script to perform specific actions depending on the input or system state, making the automation more flexible and reliable.

---

# Task 8 — Functions: Final Bash Automation Script

## Goal

Create a final Bash script using functions to organize reusable code.

### Evidence

#### Screenshot 1 — Content of `final-automation.sh`

<img width="994" height="578" alt="Screenshot 2026-07-20 213715" src="https://github.com/user-attachments/assets/18a664b2-d7f2-4897-a4ee-398fccae99d1" />
<img width="858" height="612" alt="Screenshot 2026-07-20 213655" src="https://github.com/user-attachments/assets/95e69de7-a4fe-4cd3-9bc4-42b1107f6fc5" />

---

#### Screenshot 2 — Output of `./final-automation.sh`

<img width="886" height="606" alt="Screenshot 2026-07-20 213753" src="https://github.com/user-attachments/assets/e5f7bc95-f17b-4010-b55f-2764e258c935" />

---

#### Screenshot 3 — Output of `ls -lah` showing all created scripts

<img width="914" height="628" alt="Screenshot 2026-07-20 213849" src="https://github.com/user-attachments/assets/effbfaa6-a4dd-4493-a079-9622620a13c7" />

---

### Notes

Answer the following in your own words:

**1. What is a function in Bash?**

A function is a block of reusable code that performs a specific task. It helps organize scripts and avoid repetition.

---

**2. Why are functions useful in scripts?**

Functions improve code readability, make scripts easier to maintain, and allow reuse of logic without rewriting the same code multiple times.

---

**3. Which functions did you create in this script?**

In my script, I created the functions print_header(), print_user_details(), check_files(), and print_tools(). Each function handles a specific task, such as displaying information, checking files and directories, and printing the tools list, which helps keep the script organized and easy to understand.

---

**4. How does this final script combine variables, arrays, loops, conditionals, files, and functions?**

The script combines multiple Bash concepts by using variables to store values like my name, assignment name, and file paths. It uses an array to store a list of tools, and a loop to iterate through and display each tool. Conditionals are used to check if the required directory and file exist. Functions are used to organize these tasks into separate sections, making the script more structured and reusable. Altogether, it shows how different Bash features can be combined to automate tasks efficiently.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

<<<<<<< HEAD
`https://www.linkedin.com/posts/nkechi-juwe_aws-cloudcomputing-devops-ugcPost-7484350510364459009-g9oe/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M`
=======
`Add your URL here`
>>>>>>> upstream/main

---

#### Screenshot — Published LinkedIn post

<img width="590" height="746" alt="image" src="https://github.com/user-attachments/assets/8d1b8602-1396-4198-b160-b1c9ee3e0fe1" />


---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- All script files must be created and run successfully
- Required notes must be answered clearly for every task
- Do not expose sensitive information (keys, passwords, credentials)

---

# Completion Checklist

- [ ] Task 1: Environment setup verified, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: First script created, executed, permissions verified (Screenshots 1–3, Notes answered)
- [ ] Task 3: Variables script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 4: Arrays and loops script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 5: Counter loop script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 6: File validation script created and run (Screenshots 1–3, Notes answered)
- [ ] Task 7: Pass/Retry conditional script tested with both values (Screenshots 1–4, Notes answered)
- [ ] Task 8: Final automation script created and run (Screenshots 1–3, Notes answered)
- [ ] All scripts run without errors
- [ ] Full Name visible in all required screenshots
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
