# 🐳 Docker Projects - Secure 3-Tier Application & AWS Automation

This repository contains a containerized 3-tier application (Python, Web-Frontend, PostgreSQL) and automated AWS infrastructure scripts, built to demonstrate modern production standards for **Security** and **Maintainability**.

## 📐 Core Architectural Principles

* **Rigorous Security:** Zero hardcoded credentials. All API keys, passwords, and AWS IDs are extracted from the source code.
* **High Maintainability:** Single Point of Truth. The entire configuration is managed centrally via environment variables.

---

## ⚖️ Security: Local vs. Cloud Production

| Feature | Local Development ❌ | CI/CD Cloud Production (AWS)  |
| :--- | :--- | :--- |
| **Secret Storage** | Handled locally via `.env` files. | **Secret Wallet:** Stored securely within GitHub Secrets. |
| **AWS Authentication** | Requires manual CLI configuration. | **AWS OIDC Provider:** Uses temporary tokens (valid for 2 minutes). |
| **Network Isolation** | Local Docker network bridges. | Isolated network environment (**My_VPC**). |

---

## 🛠️ Quick Local Setup

### 1. Configure Environment Variables
* **Backend:** Go to `/backend`, copy template (`cp .env.example .env`) and set your database password.
* **Frontend:** Go to `/frontend`, copy template (`cp env.Beispiel .env`) and enter your specific AWS infrastructure IDs.

### 2. Launch the Application
Run the following command in the project root directory:
```bash
docker compose up --build
```
* **Frontend:** Accessible at `http://localhost`
* **Backend API:** Accessible at `http://localhost:8000`

---

## 📦 Automation Scripts & Directory Structure

* **`/backend`** — Python API, database models, and Docker configuration.
* **`/frontend`** — Web interface and automated deployment scripts:
  * `configure_all.sh` — **Single Point of Truth.** Central validation of environment variables.
  * `deploy_frontend.sh` — Token-based, secure frontend deployment to AWS.
  * `create_subnets.sh` & `associate_private.sh` — Automatic generation of isolated network layers.
  * `configure_rules.sh` — Hardens environment via restrictive Security Group boundaries.
  * `backup_db.sh` — Automates AWS RDS database snapshots.

---

## 📊 Deployment Flow & Infrastructure Zones

```text
[ GitHub Repository ] ──( 1. Code Push & OIDC Auth )──> [ AWS OIDC Provider ]
        │                                                         │
        ▼ (Provides Code & Templates)                             ▼ (Issues temporary 2-Min Token)
[ Deployment Server / My_VPC ] ──( 2. Run AWS Scripts )───> [ Temporary IAM Rights ]
```

### 🌐 Multi-AZ Production Architecture
1. **Edge Layer:** Route 53 and AWS WAF block malicious traffic and route requests to the Load Balancer (ALB).
2. **Public Subnet:** Hosts only the NAT Gateways. No direct internet access to application servers.
3. **Private App Subnet:** Application logic scales horizontally within an Auto Scaling Group across two Availability Zones.
4. **Private Data Subnet:** High Availability Amazon RDS Multi-AZ setup with automatic failover replication.

---

## 🔍 Migration Roadmap (CALOSPRO 1–46)

The project executes a 46-step production migration aligned with the **AWS Well-Architected Framework**:
* **Phase 1-2 (Local Baseline & Containers):** Code audits, multi-stage Docker builds, and image security scanning via Amazon ECR.
* **Phase 3-4 (Network & Security Foundation):** Designing VPC boundaries, restrictive NACLs, and role-based access via AWS SSM (No open SSH ports).
* **Phase 5-6 (Scale & Governance):** Load balancing, self-healing Auto Scaling verification, centralized CloudWatch logging, and operational runbooks.
