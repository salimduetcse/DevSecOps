exit
# Student Question Set — Git, GitHub & GitHub Actions (Basic)

> **Course module:** Ntech — Module 3  
> **Based on:** `git_basic/` and `github_action_basic/` learning materials  
> **Type:** End-to-end practical assessment (scaffolding → Git → Docker → CI/CD)  
> **Submission:** Answer each part with **print-screen evidence** where marked 📸

---

## Learning outcomes (what this set tests)

By completing this question set you prove you can:

1. Scaffold a basic Python web app and run it locally
2. Put the project under Git and link it to GitHub
3. Use branches, Pull Requests, and merge into `main`
4. Build and run the app **without Docker**, then **with Docker**
5. Create a GitHub Actions pipeline that builds a Docker image and pushes it to DockerHub
6. Add a **deploy job** (real cloud VM **or** mimic deploy if you have no AWS/Azure)
7. Trigger the workflow **manually** and **automatically** on push to `main`
8. Use a **matrix** strategy and a **runtime input** to select the branch to build

---

## Prerequisites

Before you start, confirm you have:

| Tool / Account | Check |
|----------------|-------|
| Python 3.10+ | `python --version` |
| Git | `git --version` |
| Docker Desktop (or Docker Engine) | `docker --version` |
| GitHub account | Logged in at https://github.com |
| DockerHub account | Logged in at https://hub.docker.com |
| Optional: AWS EC2 / Azure VM | Only if you choose **real deploy** (Part F Option B) |

---

## Project requirements (must follow exactly)

| Item | Required value |
|------|----------------|
| Suggested repo name | `ntech-python-git-lab` (or your own clear name) |
| Framework | Any lightweight Python web framework (Flask recommended) |
| Home route `/` response text | **`hello from Python in Ntech Course on GIT`** (exact string) |
| Suggested port | `8000` |
| Feature branch name | **`dev`** |
| Default branch | **`main`** |
| Docker image name | `<your-dockerhub-username>/ntech-python-git-lab` |

---

# Part A — Scaffold the Python application (local)

### A1. Create the project on your machine

Create a project folder and scaffold at least:

```
ntech-python-git-lab/
├── app.py              (or main.py)
├── requirements.txt
├── README.md
├── .gitignore
└── (later) Dockerfile
└── (later) .github/workflows/...
```

### A2. Application behaviour

Implement a web app so that visiting `/` returns exactly:

```text
hello from Python in Ntech Course on GIT
```

Optional but recommended: add `/health` that returns a simple healthy JSON.

### A3. Local run **without Docker**

1. Create and activate a virtual environment
2. Install from `requirements.txt`
3. Start the app
4. Verify in browser or with `curl` that `/` shows the required message

**Submit 📸:** Terminal / browser screenshot proving the app runs locally **without Docker** and shows the exact hello message.

---

# Part B — Git + GitHub (repository, branch, PR, merge)

### B1. Initialize Git and first commit

```bash
git init
# create .gitignore (exclude venv/, __pycache__/, .env, etc.)
git add .
git commit -m "Initial commit: Ntech Python hello app"
```

### B2. Create GitHub repository and link remote

1. Create a **new empty repository** on GitHub (do **not** initialize with README if you already have local files)
2. Add remote and push `main`:

```bash
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

**Submit 📸:** Screenshot of the newly created GitHub repository page (repo name + your files visible).

### B3. Create `dev` branch

```bash
git checkout -b dev
# make a small meaningful change (e.g. add /health, or update README)
git add .
git commit -m "Update app on dev branch"
git push -u origin dev
```

**Submit 📸:** Screenshot showing the `dev` branch exists on GitHub (Branches page or branch dropdown).

### B4. Create Pull Request: `dev` → `main`

1. Open a Pull Request from `dev` into `main`
2. Add a short PR title and description

**Submit 📸:** Screenshot of the open Pull Request (`dev` → `main`).

### B5. Merge the PR into `main`

1. Merge the PR on GitHub
2. Confirm `main` contains the change

**Submit 📸:** Screenshot of the merged PR (or merge commit on `main`).

---

# Part C — Dockerize locally

### C1. Write a `Dockerfile`

Your Dockerfile should:

- Use a suitable Python base image (e.g. `python:3.11-slim`)
- Install dependencies from `requirements.txt`
- Copy application code
- Expose the app port
- Start the app with `CMD` / `ENTRYPOINT`

### C2. Build and run locally with Docker

```bash
docker build -t <your-dockerhub-username>/ntech-python-git-lab:latest .
docker run -d --name ntech-python-git-lab -p 8000:8000 <your-dockerhub-username>/ntech-python-git-lab:latest
curl http://localhost:8000/
```

Confirm the response is still:

```text
hello from Python in Ntech Course on GIT
```

**Submit 📸:** Screenshot proving the Docker container is running and the hello message is returned.

---

# Part D — GitHub Actions: build image and push to DockerHub

### D1. Create DockerHub access

1. Create / confirm your DockerHub account
2. Create a DockerHub **Access Token** (not your account password)

### D2. Add repository secrets on GitHub

Go to: **Settings → Secrets and variables → Actions → Secrets**

| Secret name | Purpose |
|-------------|---------|
| `DOCKERHUB_USERNAME` | Your DockerHub username |
| `DOCKERHUB_TOKEN` | DockerHub access token |

### D3. Create workflow for Docker build + push

Create: `.github/workflows/ci-cd.yml`

The **build** job must:

1. Checkout code
2. Log in to DockerHub using secrets
3. Build the image from your `Dockerfile`
4. Push to DockerHub as:
   - `<username>/ntech-python-git-lab:latest`
   - and optionally `<username>/ntech-python-git-lab:<commit-sha>`

**Submit 📸:** Screenshot of a **successful** GitHub Actions build job (green check).  
**Submit 📸:** Screenshot of the built image visible on your **DockerHub** repository page.

---

# Part E — Triggers: manual + automatic

Configure the **same** workflow to support **both** trigger styles:

### E1. Automatic trigger

```yaml
on:
  push:
    branches:
      - main
  workflow_dispatch:
    # inputs continue in Part G
```

Prove automatic mode by pushing a small change to `main` and showing the workflow run started by the push event.

**Submit 📸:** Actions run started by a **push** to `main`.

### E2. Manual trigger

Run the workflow from **Actions → Run workflow** (do not rely only on push).

**Submit 📸:** Actions run started by **workflow_dispatch** (manual).

---

# Part F — Deploy job (real deploy OR mimic deploy)

Add a second job, e.g. `deploy`, that **needs** the build/push job (`needs: build-and-push`).

## Option A — Mimic deploy (default for most students)

If you **do not** have an AWS/Azure VM, the deploy job must still exist and **simulate** deployment steps, for example:

- Print “Deploying image …”
- Echo host / image / tag (without printing secrets)
- Run placeholder commands such as:
  - “SSH to server”
  - “docker pull …”
  - “docker stop / rm / run …”
  - “Health check passed (simulated)”

This proves you understand the **job dependency** and deploy stage in CI/CD even without a cloud VM.

**Submit 📸:** Successful workflow run showing both **build** and **mimic deploy** jobs green.

## Option B — Real deploy (bonus / optional)

If you can spin up an AWS EC2 **or** Azure VM in your personal cloud account, make the deploy job **real**:

1. Install Docker on the VM
2. Open SSH + app port in the firewall / security group
3. Add these GitHub secrets:

| Secret | Example | Purpose |
|--------|---------|---------|
| `DEPLOY_HOST` or `EC2_HOST` | `54.x.x.x` | Public IP / hostname |
| `DEPLOY_USER` or `EC2_USER` | `ubuntu` / `azureuser` | SSH username |
| `DEPLOY_SSH_KEY` or `EC2_SSH_KEY` | Full private key PEM | SSH private key |
| `DOCKERHUB_USERNAME` | (already set) | Pull image on server |
| `DOCKERHUB_TOKEN` | (already set) | Private pull if needed |

4. Use SSH from Actions (e.g. `appleboy/ssh-action`) to:
   - `docker pull` your image
   - stop/remove old container
   - run new container on port `8000`
   - `curl` health/home endpoint on the server

**Submit 📸:** Successful real deploy job + browser/`curl` proof of app on the public IP.

> **Grading note:** Option A is enough to pass the deploy requirement. Option B earns bonus credit.

---

# Part G — Matrix build + runtime branch input

Enhance the **build** portion of your workflow as follows.

### G1. Matrix strategy

Use a matrix so the build/test runs across at least **two** Python versions, for example:

```yaml
strategy:
  fail-fast: false
  matrix:
    python-version: ["3.11", "3.12"]
```

Even if the final Docker image uses one base version, demonstrate matrix usage for a validation/test step (install deps / import app / simple check) across versions.

**Submit 📸:** Actions UI showing multiple matrix jobs (e.g. Python 3.11 and 3.12).

### G2. Runtime input to choose branch

Add a `workflow_dispatch` input so you can choose which branch to build **at run time**, for example:

```yaml
on:
  workflow_dispatch:
    inputs:
      build_branch:
        description: "Branch to checkout and build"
        required: true
        default: "main"
        type: string
        # or type: choice with options: main, dev
  push:
    branches: [main]
```

Then checkout that branch:

```yaml
- uses: actions/checkout@v4
  with:
    ref: ${{ inputs.build_branch || github.ref }}
```

Manually run the workflow twice:

1. Once with `build_branch = main`
2. Once with `build_branch = dev`

**Submit 📸:** Manual run where input branch = `main`  
**Submit 📸:** Manual run where input branch = `dev`

---

# End-to-end checklist (self-mark before submit)

Use this as your final review list:

| # | Task | Done? | Evidence |
|---|------|-------|----------|
| 1 | Python app returns exact hello string | ☐ | 📸 local run |
| 2 | GitHub repo created and code pushed | ☐ | 📸 repo page |
| 3 | `dev` branch created | ☐ | 📸 branches |
| 4 | PR `dev` → `main` created | ☐ | 📸 open PR |
| 5 | PR merged into `main` | ☐ | 📸 merged PR |
| 6 | App runs locally without Docker | ☐ | 📸 |
| 7 | Dockerfile created; local Docker run works | ☐ | 📸 |
| 8 | DockerHub secrets configured | ☐ | (do not screenshot secret values) |
| 9 | Actions builds & pushes image | ☐ | 📸 Actions + 📸 DockerHub image |
| 10 | Manual trigger works | ☐ | 📸 |
| 11 | Automatic trigger on `main` push works | ☐ | 📸 |
| 12 | Deploy job present (mimic **or** real) | ☐ | 📸 |
| 13 | Matrix used in build/test | ☐ | 📸 |
| 14 | Runtime branch input used (`main` + `dev`) | ☐ | 📸 ×2 |

---

# Suggested workflow skeleton (reference only — write your own)

Students should write the YAML themselves. The structure below is a **guide**, not a copy-paste answer key:

```yaml
name: Ntech Python CI/CD

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      build_branch:
        description: "Branch to checkout and build"
        required: true
        default: "main"
        type: choice
        options:
          - main
          - dev

env:
  IMAGE_NAME: ntech-python-git-lab
  APP_PORT: 8000

jobs:
  validate-matrix:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        python-version: ["3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ inputs.build_branch || github.ref_name }}
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: |
          python -m pip install -r requirements.txt
          python -c "import app; print('ok')"

  build-and-push:
    needs: validate-matrix
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ inputs.build_branch || github.ref_name }}
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:latest
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    steps:
      # Option A: mimic deploy steps with echo / fake script
      # Option B: real SSH deploy using DEPLOY_* / EC2_* secrets
      - name: Deploy (mimic or real)
        run: |
          echo "Deploying ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:latest"
          echo "Mimic: ssh → docker pull → docker run → health check"
```

---

# Marking guide (for trainer)

| Area | Weight | Pass criteria |
|------|--------|---------------|
| App scaffolding + exact hello message | 15% | Exact string on `/` |
| GitHub repo + `dev` branch + PR + merge | 20% | All screenshots present |
| Local run without Docker | 10% | Evidence of local success |
| Local Docker build/run | 10% | Container serves hello message |
| Actions build + DockerHub image | 20% | Green build + image on Hub |
| Manual + automatic triggers | 10% | Both evidences |
| Deploy job (mimic or real) | 10% | Job exists and succeeds after build |
| Matrix + branch input | 5% | Matrix jobs + two manual branch runs |

**Fail conditions (automatic):**

- Hello message is not the required exact string
- Secrets committed into the repository
- No PR / merge evidence
- Build job pushes nothing to DockerHub
- No deploy job at all

---

# Related study materials

Complete / revise these before or while doing the question set:

| Topic | Path |
|-------|------|
| Git fundamentals + branching/PR lab | [`git_basic/README.md`](git_basic/README.md) |
| GitHub Actions concepts + workflows 01–16 | [`github_action_basic/README.md`](github_action_basic/README.md) |
| Manual trigger + inputs | `github_action_basic/workflows/07-manual-trigger-input.yml` |
| Push trigger | `github_action_basic/workflows/08-push-trigger.yml` |
| Matrix | `github_action_basic/workflows/11-matrix-build.yml` |
| Docker build | `github_action_basic/workflows/15-docker-build-basic.yml` |
| DockerHub + EC2 deploy pattern | `github_action_basic/workflows/16-ec2-docker-deploy-basic.yml` |
| Full sample Python CI/CD project | `github_action_basic/sample-projects/python-app/` |

---

*Ntech Module 3 — Student Question Set for Git / GitHub / GitHub Actions Basic*
