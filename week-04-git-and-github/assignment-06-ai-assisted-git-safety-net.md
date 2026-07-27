# Assignment 6 — Building an AI-Assisted Git Safety Net (PR Ready Check)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In Week 2 you built Claude Code hooks that block a dangerous action *before* it happens (`PreToolUse`), and a restricted skill that could look but not touch (`allowed-tools` without `Write`). In this assignment you will discover that Git has the exact same idea, decades older: a **pre-commit hook** that blocks a commit before it's created.

You will build both halves of a real "PR Ready" workflow:

1. A **Git hook that follows fixed rules** — scans staged changes for hardcoded secrets and oversized files and refuses the commit. No AI involved, no guessing, just a rule that gives the same answer every time.
2. A **restricted Claude Code skill** (`/pr-ready`) that reads your staged diff and drafts a Pull Request title, description, and a short list of things worth a second look — the kind of judgment a fixed rule can't make (mixed changes, missing context, unclear intent). The skill never commits, pushes, or opens the PR. You do that yourself, using its draft as a starting point.

This mirrors the Agentic Loop from Week 3's Linux triage assignment: **Gather → Analyze → Human Act → Verify**. The hook and the skill both gather and analyze; only you act.

---

# Task 0 — Confirm Your Fork and Create a Feature Branch

## Goal

Confirm you are working in your own fork, then create a dedicated branch for this assignment.

### Evidence

#### Screenshot 1 — Output of git remote -v and git branch showing the new branch

![git remote -v](<Screenshot 2026-07-23 212741-1.png>)

---

### Notes

**1. Why create a dedicated branch instead of doing this work on main?**

A dedicated branch isolates changes from the main branch, prevents breaking stable code, and allows safe experimentation, review, and rollback without affecting production-ready code.

---

# Task 1 — Stage a Change With Realistic Risk

## Goal

On your own fork of this repository (the one you've been submitting your DMI work in since onboarding), create a new branch and stage a change that a real reviewer should catch: a hardcoded-looking secret and a leftover debug statement.

### Evidence

#### Screenshot 1 — Output of  `git status` showing the staged file on feature/ai-pr-ready

![git status](<Screenshot 2026-07-23 213414-1.png>)

---

### Notes

**1. Why does this assignment use an obviously fake key instead of a real one?**

A fake key is used to simulate a real security risk without exposing actual credentials, ensuring safe learning while still testing detection mechanisms.

---

# Task 2 — Write a Real Git Pre-Commit Hook

## Goal

Create a tracked, shareable pre-commit hook that blocks a commit containing secret-like patterns or files over 1MB.

### Evidence

#### Screenshot 2 — `hooks/pre-commit` open in VS Code showing the full script

![hooks/pre-commit](<Screenshot 2026-07-25 120816.png>)

---

#### Screenshot 3 — Output of `git config core.hooksPath` confirming it points to `hooks`

![git config core](<Screenshot 2026-07-24 161754.png>)

---

### Notes

**1. Why is `hooks/pre-commit` tracked in the repo instead of living only in `.git/hooks/`?**

Tracking hooks/pre-commit ensures the hook is shared across the team via the repository, providing consistent enforcement, unlike .git/hooks/ which is local-only and not version-controlled.

---

**2. Compare this to `PreToolUse` from Week 2 Assignment 6. What does each one intercept, and what do they have in common?**

The pre-commit hook intercepts Git commits before they are created, while PreToolUse intercepts tool execution before an action is performed. Both enforce safety rules before an irreversible operation occurs, acting as preventive control mechanisms.

---

# Task 3 — Prove the Hook Blocks the Risky Commit

## Goal

Attempt to commit the staged file from Task 1 and show the hook rejecting it.

### Evidence

#### Screenshot 4 — Terminal showing `git commit` rejected with the hook's "BLOCKED" message naming the exact file

![git commit](<Screenshot 2026-07-25 111230.png>)

---

### Notes

**1. Which line in `hooks/pre-commit` matched your fake key, and why did it match?**

grep -qE 'AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|PRIVATE) KEY-----'

---

**2. Could this hook have caught a poorly-named variable that stores a secret without the `AKIA` prefix? What does that tell you about the limits of a fixed rule like this?**

No, the hook would not reliably catch it.

---

# Task 4 — Build the `/pr-ready` Skill

## Goal

Create a manually invoked Claude Code skill that reads your staged changes and produces a PR-readiness report and a draft PR description — without writing, committing, or pushing anything itself.

### Evidence

#### Screenshot 5 — `SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no `Write`) and `disable-model-invocation: true`

![skill md](<Screenshot 2026-07-25 111439.png>)

---

#### Screenshot 6 — `/pr-ready` output while the risky file is still staged, showing it flagged the secret and/or debug statement

![pr-ready](<Screenshot 2026-07-25 111622.png>)

---

### Notes

**1. Why does `/pr-ready` have `Bash` and `Read` but not `Write`?**

/pr-ready is designed to analyze the staged changes safely without modifying the repository, which is why it only has:

Read → to inspect the staged diff (git diff --cached)
Bash → to execute validation logic (scripts, checks)

It does not have Write access because:

Granting write permissions would allow it to modify files, alter commits, or bypass safeguards, which would be unsafe and defeat its purpose as a validation tool.

---

**2. The pre-commit hook and `/pr-ready` both looked at the same staged diff. Did they flag the same things? What did one catch that the other didn't?**

No, they did not always flag the same things, even though both analyze the staged diff.

---

# Task 5 — Fix the Issues and Re-Verify

## Goal

Remove the secret and debug statement, then prove both gates now pass clean.

### Evidence

#### Screenshot 7 — `git commit` succeeding after the fix (no BLOCKED message)

![git commit](<Screenshot 2026-07-25 112826.png>)

---

#### Screenshot 8 — Second `/pr-ready` run showing a clean risk report and a drafted PR title + description

![pr-ready](<Screenshot 2026-07-25 112826-1.png>)

---

### Notes

**1. What exactly did you change to satisfy the pre-commit hook?**

I modified the contents of the staged file to remove or avoid patterns that match the hook’s regex rules.

Specifically:

I removed the line containing the fake secret:

API_KEY=super-secret-123

Or replaced it with a safe placeholder, such as:

API_KEY=example-value

---

# Task 6 — Push and Open a Pull Request Using the AI Draft

## Goal

Push your branch and open a real Pull Request, using `/pr-ready`'s drafted title and description as your starting point — read it critically and edit before you use it.

**Important:** Open this Pull Request with base repository set to **your own fork** — not the shared upstream `pravinmishraaws/devops-micro-internship-pravinmishra` repository. This assignment's hook and skill files are your own practice work, not a change meant for the shared class repo.

### Evidence

#### Screenshot 9 — Your Pull Request showing the base repository is your own fork, plus the title and description, with the `/pr-ready` draft visible for comparison (paste it in the PR conversation or your notes below)

![pull request](<Screenshot 2026-07-25 113812.png>)

---

#### PR Link

[pull](https://github.com/NkJuwe/devops-micro-internship-pravinmishra/pull/1)

---

### Notes

**1. What, if anything, did you edit in the AI's drafted PR description before using it? Why?**

I reviewed and edited the AI-generated PR description to improve clarity, accuracy, and relevance. Specifically, I ensured it correctly described my actual changes, removed any generic or incorrect statements, and aligned it with the assignment requirements.

Why:
AI-generated content can be partially correct but may include assumptions or vague wording. Editing ensures the PR is precise, truthful, and professionally written.

---

**2. If you had blindly copy-pasted the AI's draft without reading it, what could go wrong?**

If I had blindly used the AI’s draft, it could include incorrect details, misleading explanations, or irrelevant information. This could result in a confusing or inaccurate PR, reduce credibility, and potentially introduce errors into the review process.

---

**3. Why does this PR need to target your own fork instead of the shared upstream repository?**

The PR must target my own fork because I do not have direct write access to the shared upstream repository. Working in a fork ensures that my changes are isolated and safe, and allows maintainers to review and merge them without risking unintended modifications to the main project.

---

# Task 7 — Map the Workflow to the Agentic Loop

## Goal

Explain this assignment's workflow using the same Gather → Analyze → Human Act → Verify structure from Week 3.

### Notes

**1. Which step(s) represent Gather?**

The Gather step includes:

Running git status and git diff
Reviewing staged changes (git diff --cached)
Collecting feedback from tools like the pre-commit hook or /pr-ready

These steps collect the necessary information about the current state of the code.

---

**2. Which step(s) represent Analyze?**

The Analyze step includes:

Interpreting the output of the pre-commit hook
Reviewing /pr-ready feedback
Understanding which changes are problematic (e.g., secrets, large files)

This is where the gathered information is evaluated to identify issues.

---

**3. Which step is Human Act, and why must a human — not Claude — run `git commit`, `git push`, and open the PR?**

The Human Act step is when I:

Run git commit
Run git push
Open the pull request

A human must perform these actions because they involve making final decisions, authenticating with Git, and taking responsibility for changes. AI cannot securely access credentials or guarantee intent, so these actions require human control.

---

**4. Which step is Verify?**

The Verify step includes:

Confirming the pre-commit hook passes
Checking that the PR is correctly created
Reviewing CI checks or feedback after submission

This ensures that the changes meet all requirements and no issues remain.

---

**5. In one or two sentences: why do you need *both* the fixed-rule pre-commit hook and the AI skill? Isn't one enough?**

Both are needed because they serve complementary roles. The pre-commit hook enforces strict, rule-based checks for known issues (like specific secret patterns or file size limits), while the AI skill provides broader, context-aware analysis that can detect less obvious problems.

The hook is precise but limited; the AI is flexible but not deterministic — together they provide stronger protection than either alone.

---

# Task 8 — LinkedIn Post

## Goal

Publish a LinkedIn post summarizing what you built and what you learned about combining fixed-rule safety checks with AI-assisted review.

### Evidence

#### LinkedIn Post URL

[linkedin url](https://www.linkedin.com/posts/nkechi-juwe_dmi-devops-micro-internship-with-agentic-share-7487289872966156288-Cxrt/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADt-vqsBoRObYmV0maWpD3wnWmjrlXVSF4M)

---

## Key Learnings

Add 3-5 bullet points on what you learned this week.

-Pre-commit hooks operate on the staging area (index), not the working directory
-Git hooks require explicit execution permissions; otherwise, they are ignored without error
-Pattern-based detection is inherently limited to known signatures and cannot generalize
-AI-assisted review improves coverage but must be validated before use
-Effective workflows combine automated enforcement (hooks) with adaptive analysis (AI)

---

# Submission Instructions

- Ensure `hooks/pre-commit` and `.claude/skills/pr-ready/SKILL.md` are committed to your GitHub repository
- Add all required screenshots to your submission
- All written answers must be in your own words
- Do not use a real secret or credential anywhere in your submission — the fake key in Task 1 is intentional and must stay clearly fake
- Open your Pull Request against your own fork, not the shared upstream repository
- Push your final changes to your forked repository
- Include your PR link and LinkedIn post URL

---

## GitHub Repository URL

Paste your forked repository URL here:

`Add your URL here`

---

# Completion Checklist

- [ ] Branch `feature/ai-pr-ready` created with a staged file containing a fake secret and a debug statement
- [ ] `hooks/pre-commit` created and tracked in the repo (not only in `.git/hooks/`)
- [ ] `core.hooksPath` configured to point at `hooks/`
- [ ] Pre-commit hook shown blocking the risky commit
- [ ] `.claude/skills/pr-ready/SKILL.md` created with correct `allowed-tools` (no `Write`) and `disable-model-invocation: true`
- [ ] `/pr-ready` run against the risky diff and shown flagging issues
- [ ] Risky file fixed; `git commit` succeeds cleanly
- [ ] `/pr-ready` re-run showing a clean report and drafted PR title/description
- [ ] Pull Request opened using the AI draft as a starting point, with your own fork as the base repository (not upstream), PR link included
- [ ] Agentic Loop mapping (Task 7) completed in your own words
- [ ] LinkedIn post published and URL submitted
- [ ] All required screenshots added
- [ ] GitHub repository URL provided

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
