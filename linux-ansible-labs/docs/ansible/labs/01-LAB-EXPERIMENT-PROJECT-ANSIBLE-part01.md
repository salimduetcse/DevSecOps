# Lab examination — take-home project (Ansible Part 01)

**Coverage:** Draws on ideas from class labs **01** (inventory, SSH, `ping`), **02** (ad-hoc commands, `command`/`copy` patterns), **03** (packages and `service`), **04** (Jinja2 `template` + **handlers**), **05** (variables, facts, `when`), and **06** (roles: `tasks/`, `handlers/`, `templates/`, `files/`, `defaults/`). It does **not** require every technique from those labs—only what this brief asks for. **Ansible Vault is out of scope** for this assignment (do not use `07-LAB-VAULT-INTRO.md`).

**Format:** One **scenario** with **ordered phases**. You decide **how** to implement each requirement (module choice, variable names, exact paths under `/var/www` or `/tmp` are yours unless fixed below). This document intentionally **does not** spell out every Ansible keyword; your evidence must show you ran automation from a real **control node** against real **managed nodes** (Ubuntu/Debian-style targets are assumed, matching the labs).

**Prerequisite:** At least **two** managed Linux hosts reachable by SSH from your control node, plus working privilege escalation (`become`) as in the inventory labs. Adjust hostnames and IPs to your environment; keep **group names** and outcomes clear in your evidence.

---

## Scenario

You are rolling out a tiny **internal status page** for two application hosts. Operations wants everything expressed as **versioned Ansible** (not manual SSH edits on each box): baseline web package, a **templated** landing page that shows machine identity, a **static** health snippet shipped from the role, a **conditional** “primary” marker on exactly one host, and finally a **refactor into a role** so the playbook stays thin. Your manager expects a **short evidence pack** (screenshots + a small memo)—not a theory-only essay.

Phases are **ordered on purpose**: prove connectivity and layout first, then playbooks, then templates/handlers, then conditionals, then the role refactor, then concepts.

---

## Story flow (sequence you must follow)

```text
Phase 1 — Control-node project tree + inventory (two managed hosts)
Phase 2 — Ad-hoc proof: ping + one useful fact per host
Phase 3 — Baseline playbook: package + service (idempotent)
Phase 4 — Template + handler (nginx reload semantics)
Phase 5 — Variables, facts, and a conditional “primary” marker
Phase 6 — Refactor into a role (mandatory layout + names)
Phase 7 — Concept memo (three questions)
```

---

## Allowed materials

- Your notes and the course lab documents:
  - `01-LAB-PING-AND-INVENTORY.md`
  - `02-LAB-ADHOC-COMMANDS.md`
  - `02-LAB-COMMAND-MODULE-BASIC.md`
  - `02-LAB-COPY-FILES-ACROSS-NODES.md`
  - `03-LAB-PACKAGES-AND-SERVICES-NGINX.md`
  - `04-LAB-TEMPLATES-HANDLERS.md`
  - `05-LAB-VARS-FACTS-CONDITIONS.md`
  - `06-LAB-ROLES-INTRO.md`
- Your lab environment only (control node + managed nodes).

Do **not** submit real passwords, private key material, `ansible_password` lines, or vault blobs. Redact connection secrets in screenshots the same way you would for the Linux exam brief.

---

## Phase 1 — Project tree and inventory (two hosts)

**Requirement:**

1. On the **control node**, create a dedicated working directory for this exam, for example under your home directory: **`~/ansible-labs/exam-ansible-part01/`** (you may choose a different path, but you must **document** it in Phase 7 and use it consistently in evidence).
2. Inside that directory, keep an inventory file (name your choice) that defines:
   - a group containing **both** managed hosts (the labs often use a pattern like `nodes`; you may reuse that name or pick another, but you must **explain** your group in the memo if it is non-obvious);
   - **per-host** inventory names (e.g. `web1`, `web2`) that appear in logs and facts;
   - whatever SSH/`become` variables your environment requires (redacted in submission screenshots where needed).
3. Your two managed hosts must **both** be targeted by the group you will use in later playbooks for the web baseline (Phases 3–6).

**Evidence to submit:** Screenshot(s) showing the **directory path** on the control node and the **inventory** file open in an editor or `cat`/`less` output with secrets redacted.

---

## Phase 2 — Ad-hoc proof (connectivity + facts)

**Requirement:** Still from `~/ansible-labs/exam-ansible-part01/` (or the path you declared):

1. Run Ansible **ad-hoc** `ping` against **both** hosts using the same group you defined for the pair.
2. Run **one** additional ad-hoc command that prints **at least two distinct facts per host** (hostname and primary IPv4 address are enough). Use a module style consistent with the labs (`setup`/`gather_facts` patterns or `debug` with fact variables—your choice).

**Evidence to submit:** Terminal screenshot(s) showing successful **`ping`** for both hosts and the **fact-oriented** output so an instructor can match lines to **each** inventory name.

---

## Phase 3 — Baseline web stack (playbook, idempotent)

**Requirement:** Author a playbook (filename your choice) that:

1. Targets **both** managed hosts from Phase 1’s group.
2. Uses privilege escalation where required.
3. Ensures the distribution’s **`nginx`** package is present and the **`nginx`** service is **started** and **enabled** for boot (same outcomes as the packages/services lab).
4. Can be run twice without breaking the story (idempotent package/service pattern).

**Evidence to submit:**

- Screenshot of **`ansible-playbook`** run showing **changed/ok** summary for the play.
- Screenshot of a **second** run where package/service tasks are predominantly **`ok`** (not reinstalling the world each time).
- One screenshot proving HTTP responds on each host (from control node is fine), e.g. **`curl -I`** against each host’s reachable address/port you used for the check.

---

## Phase 4 — Templated landing page + handler discipline

**Requirement:** Extend your automation (playbook **or** role path—Phase 6 will refactor anyway) so that:

1. A Jinja2 **template** deploys the main site document to **`/var/www/html/index.html`** (same docroot idea as the templates lab).
2. The rendered page **must visibly include**:
   - the **inventory hostname** of the machine serving it;
   - a **custom title** supplied by an Ansible variable you define (e.g. `site_title`—name is yours);
   - the literal marker string **`ANSIBLE-PART01`** somewhere in the body (visible in `curl` output).
3. Changing the title variable and re-running must update the file and **restart or reload nginx via a handler** that runs **only when** the template task reports a change (handler pattern from the templates lab).

**Evidence to submit:**

- Screenshot showing the **template task** `notify:` relationship to a **handler** in YAML.
- Screenshot of **`curl`** (or browser) showing **`ANSIBLE-PART01`** and differing hostnames per machine.
- Screenshot or log snippet showing a **handler run** after you intentionally change `site_title` (or equivalent) between two playbook runs.

---

## Phase 5 — Variables, facts, and a conditional marker (moderate twist)

**Requirement:**

1. Introduce a **boolean** variable (name your choice, default **`false`**) that controls whether an extra “tool” package is installed—pick **one** small package from lab 05’s style (for example `htop` or `curl`) and guard installation with `when:` so the task is skipped when the boolean is false.
2. Create a small **marker file** on **exactly one** of the two hosts:
   - path: **`/tmp/ansible-exam-primary.txt`**
   - file content must include the literal substring **`PRIMARY`**, the **inventory hostname**, and an **ISO-like timestamp** (fact or `lookup('pipe', …)`—your choice).
   - implement the “only one host” rule using a conditional (`when:`) tied to inventory identity (for example first host in the group, or a host variable you set in inventory). **Do not** SSH manually to only one box to create the file—Ansible must enforce it.

**Evidence to submit:**

- Screenshot of relevant playbook/role YAML showing the **`when:`** logic.
- Screenshot of remote checks proving the file **exists on one host** and is **absent** (or empty directory listing) on the other.

---

## Phase 6 — Refactor into a role (mandatory structure)

**Requirement:** Refactor Phases 3–5 into a **role** with this **exact role name**:

- **`roles/status_site/`**

Minimum layout on the control node (same folder as your playbook entry point):

```text
roles/status_site/
├── defaults/main.yml
├── files/
├── handlers/main.yml
├── tasks/main.yml
└── templates/
```

Rules:

1. Move nginx install/service, template deploy, static file usage, handler(s), and the Phase 5 conditional marker into the role’s `tasks/main.yml` (you may split into `include_tasks` **only if** you keep the entry behavior obvious in screenshots—avoid needless complexity).
2. Place at least **one** static file under `roles/status_site/files/` and deploy it with **`ansible.builtin.copy`** to **`/var/www/html/health.txt`** on both hosts (harmless content; must include the literal substring **`HEALTH`**).
3. Keep defaults (e.g. `site_title`, your boolean toggle) in **`roles/status_site/defaults/main.yml`** and show in evidence that the playbook overrides **at least one** default via `vars:` or extra-vars **without** editing the role defaults file between runs.
4. The **playbook entry point** at repo root for grading clarity must be named exactly:

   - **`site.yml`**

   and it must apply your role using the normal `roles:` mechanism (not copy-pasting the same tasks into `site.yml`).

**Evidence to submit:**

- Screenshot of **tree**/`ls` showing `site.yml`, `roles/status_site/...`, and inventory co-located as you run them.
- Screenshot of **`ansible-playbook`** against `site.yml` succeeding after the refactor.
- Screenshot proving **`/var/www/html/health.txt`** on both hosts contains **`HEALTH`**.

---

## Phase 7 — Concept memo (three questions)

Answer in **your own words** (roughly **one short paragraph each**). No screenshots.

1. **Idempotency:** In Phase 3, why is it desirable that a second playbook run reports mostly **`ok`** instead of **`changed`** for package and service tasks? What would repeated `changed` imply about your automation story in production?

2. **Handlers:** Why might restarting nginx on **every** playbook run be worse than notifying a handler only when the template changes? Mention **change noise** and **service disruption** in practical terms.

3. **Roles vs flat playbooks:** The labs describe separating `tasks/`, `templates/`, `files/`, and `defaults/`. In your own words, what becomes easier for a teammate when Phase 6’s layout exists compared to one long `site.yml` with everything inlined?

---

## How to submit

Send everything to:

**faizulkhan56@gmail.com**

**Subject line (required):**

```text
Ansible Lab Exam Part01 - <Your Full Name> - <Roll or ID if applicable>
```

**Attachments:**

- A **single ZIP** or **one PDF** containing:
  - screenshots for Phases **1–6** (label files clearly, e.g. `AnsiblePart01-Phase1.png`, …), and  
  - the **Phase 7** answers in the same PDF **or** as a separate `AnsiblePart01-Memo-<YourName>.pdf` / `.docx`.

**Optional (nice to have, not graded unless your instructor says so):** attach a **sanitized** tarball of `site.yml`, `inventory`, and `roles/status_site/` with **no secrets**.

**Checklist before send:**

- [ ] Phase 1–6 evidence is present and readable  
- [ ] Phase 7 answered in prose  
- [ ] No secrets or private keys in the package  
- [ ] Subject line includes your name  
- [ ] `ANSIBLE-PART01`, `PRIMARY`, and `HEALTH` markers are visible where required  

---

## How participants will be evaluated

| Criterion | Looks for |
|-----------|-----------|
| Phase 1 | Control-node project dir; inventory with **two** hosts in one group; safe redaction |
| Phase 2 | Ad-hoc `ping` success; fact output tied to **each** host |
| Phase 3 | Playbook installs/starts/enables nginx; **second run** mostly `ok`; HTTP check on **both** |
| Phase 4 | Template to `/var/www/html/index.html`; **`ANSIBLE-PART01`** visible; handler tied to template change |
| Phase 5 | Boolean-guarded package install; **`/tmp/ansible-exam-primary.txt`** on **one** host only; `when:` logic clear |
| Phase 6 | Role name **`status_site`**; required tree; `site.yml` entry; static **`HEALTH`** file via `copy`; defaults overridable from playbook |
| Phase 7 | Accurate concepts in own words |

---

*This is Ansible Part 01. A solution guide may be published later. Vault (`07-LAB-VAULT-INTRO.md`) is intentionally excluded from this assignment.*
