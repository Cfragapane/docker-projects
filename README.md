■ Docker Projects - Secure 3-Tier Application &

AWS Automation

This repository contains a fully functional and containerized 3-tier application (Python backend, web frontend, and

PostgreSQL database) designed by me, including automated infrastructure scripts for Amazon Web Services (AWS). I built

this project specifically to independently implement and demonstrate modern industry standards in the areas of Security

and Maintainability.

■ My Architectural Decisions & Core Aspects

When designing the application, I consciously decided on two fundamental principles that define clean software engineering

in production environments:
1.	Rigorous Security (No Hardcoded Credentials): Storing API keys, database passwords, or AWS infrastructure IDs

inside the source code is a critical risk. Therefore, I extracted all sensitive data entirely from the codes and scripts.
2.	High Maintainability (Single Point of Truth): The entire configuration is managed centrally via environment

variables. As a result, values only need to be adjusted at one central location during the course of the project.

■■ Prerequisites

Ensure that the following tools are installed on your system:

• Docker & Docker Compose

• Git

• AWS CLI (configured with valid IAM permissions)

■■ My Credential Management & Infrastructure Security

Local Environment Variables (.env)

In the repository, I only provide structured templates without real secrets (.env.example or env.Beispiel). The actual,

productive .env files are strictly excluded from being uploaded via the .gitignore.

CI/CD & Cloud Security (OIDC & Secret Management)

To secure the automated deployment, I chose a modern token infrastructure:

• Secret Wallet: Secure storage of production keys directly within GitHub Secrets.

• AWS OIDC Provider (OpenID Connect): Instead of hardcoding long-lived AWS Access Keys, my pipeline authenticates

via an OIDC provider. Through the IAM roles I defined, the deployment script receives a temporary token that is only valid

for 2 minutes to interact with resources within a dedicated, isolated network environment (My_VPC).

■ Local Setup & Startup
3.	Configure Environment Variables

For the Backend:
4.	Navigate into the backend/ folder.
5.	Copy the template: cp .env.example .env.
6.	Open the new .env and enter your desired database password.

For the Frontend & AWS Infrastructure:
7.	Navigate into the frontend/ folder.
8.	Create a .env file (e.g., from env.Beispiel).
9.	Enter your specific AWS IDs (VPC ID, Region, Security Groups) required by the automation scripts.

Tip: Server Configuration via VIM

If the .env files need to be configured directly on a remote Linux server, I recommend the terminal editor VIM:
10.	Press 'i' for insert mode (INSERT)
11.	Enter/adjust values
12.	Press 'ESC' to exit the mode
13.	Type ':wq' and hit Enter to save and close
14.	Start the Application with Docker Compose

Switch back to the main directory of the project and execute the following command:

docker compose up --build

The application will then be accessible at http://localhost (Frontend) or http://localhost:8000 (Backend API).

■ Directory Structure & Scripts

• /backend: Contains the Python API (main.py), the relational database model (models.py), and the Docker

configuration.

• /frontend: Contains the user interface as well as the automation scripts I wrote for the cloud environment:
·	configure_all.sh: My Single Point of Truth. This script initializes and validates all environment variables centrally

before deployments start.
·	deploy_frontend.sh: Executes the secure, token-based deployment of the frontend instances onto AWS.
·	create_subnets.sh: Automatically creates isolated subnets within the VPC.
·	associate_private.sh: Securely links the created subnets to the Private Route Table.
·	configure_rules.sh: Configures restrictive ingress rules for the Security Groups.
·	backup_db.sh: Triggers automated AWS RDS database snapshots for data backup.

■■ Architecture & Pipeline Overview

[ GitHub Repository ] ■■( 1. Code Push & OIDC Auth )■■■ [ AWS OIDC Provider ]

■

■

■ (Provides Code & env.Example)

■ (Issues temporary 2-Min Token)

▼

▼

[ Deployment Server / VPC ] ■■■( 2. Execute AWS Scripts )■■■ [ Temporary IAM Rights ]

■

■■■ Protects DB & API in the isolated "My_VPC"

■■■ Uses local, server-side .env via configure_all.sh

■■■ Creates backups & manages network rules

■ Detailed Project Phases & AWS Cloud Migration Path (CALOSPRO 1–46)

To model the transition from the local environment described above into a production-ready AWS cloud infrastructure in a

structured way, this project is divided into 46 clearly defined work packages. Each package strictly follows the AWS

Well-Architected Pillars:

Phase 1: Application Assessment & Local Baseline (CALOSPRO 1–4)

• CALOSPRO-1: Assess the Existing Application Repository

Production Rationale: Code audit to identify technical debt, hardcoded credentials, and monolithic dependencies.

• CALOSPRO-2: Document the application runtime

Production Rationale: Exact tracking of OS dependencies and runtime versions to avoid 'works on my machine'

issues.

• CALOSPRO-3: Identify configuration and secrets

Production Rationale: Strict separation of code and configuration following the 12-Factor App methodology. No

secrets in source code.

• CALOSPRO-4: Create a local deployment baseline

Production Rationale: Establishing a local reference point (via Docker Compose) to validate baseline application

behavior before AWS modifications.

Phase 2: Containerization & Registry Management (CALOSPRO 5–12)

• CALOSPRO-5: Containerize and Validate the Application

Production Rationale: Migration of the runtime environment into an isolated software container to standardize the

execution environment.

• CALOSPRO-6: Create the Dockerfile

Production Rationale: Multi-stage builds to drastically minimize image size and reduce potential attack surfaces.

• CALOSPRO-7: Create the Docker Ignore File

Production Rationale: Targeted exclusion of .git, CI builds, and local secrets. Keeps images lightweight and prevents

data leaks.

• CALOSPRO-8: Run Local Container Tests

Production Rationale: Unit and integration tests directly within the container environment to ensure absolute

environmental parity.

• CALOSPRO-9: Scan and Tag the Image

Production Rationale: Vulnerability scanning (e.g., with Trivy) and semantic versioning instead of using the

unpredictable 'latest' tag.

• CALOSPRO-10: Publish the Image to Amazon ECR

Production Rationale: Central upstream push into the highly available private registry of AWS.

• CALOSPRO-11: Define the ECR Repository

Production Rationale: Configuration of Lifecycle Policies (automatically deleting old test images for cost control) and

scan-on-push.

• CALOSPRO-12: Push the Validated Image

Production Rationale: Controlled release process. Only verified, scanned, and signed images enter the deployment

pipeline.

Phase 3: Cloud Architecture Design & Standards (CALOSPRO 13–16)

• CALOSPRO-13: Design the Target Architecture

Production Rationale: System design to ensure High Availability and Fault Tolerance.

• CALOSPRO-14: Create the architecture diagram

Production Rationale: Visual Single-Source-of-Truth for developers and auditors to map data flow and security zones.

Target Cloud Architecture (AWS) Diagram:

+-----------------------------+

|

AWS Route 53 (DNS)

|

+--------------+--------------+

|

v

+-----------------------------+

|

AWS WAF (Web Firewall)

|

+--------------+--------------+

|

v

+-------------------------------------+

| Internet Gateway / ALB (Load Bal.) |

+--------+-------------------+--------+

|

|

+------------------------v----+

+--------v--------------------+

| Availability Zone A

|

| Availability Zone B

|

|

|

|

|

| [Public Subnet A]

|

| [Public Subnet B]

|

| +-----------------------+ |

| +-----------------------+ |

| | NAT Gateway A

| |

| | NAT Gateway B

| |

| +-----------+-----------+ |

| +-----------+-----------+ |

|

|

|

|

|

|

|==============|==============|

|==============|==============|

|

v

|

|

v

|

| [Private App Subnet A]

|

| [Private App Subnet B]

|

| +-----------------------+ |

| +-----------------------+ |

| | Auto Scaling Group

| |

| | Auto Scaling Group

| |

| | [ EC2 Instance A ]

|<-|-+

| | [ EC2 Instance B ]

| |

| +-----------+-----------+ | |

| +-----------+-----------+ |

|

|

| |

|

|

|

|==============|==============| |

|==============|==============|

|

v

| |

|

v

|

| [Private Data Subnet A]

| |

| [Private Data Subnet B]

|

| +-----------------------+ | |

| +-----------------------+ |

| | Amazon RDS Primary

|--|-+-->| | Amazon RDS Standby

| |

| | (Multi-AZ Master)

| |

| | (Replicating)

| |

| +-----------------------+ |

| +-----------------------+ |

+-----------------------------+

+-----------------------------+

■■ Security and Architectural Zones (Data Flow & Security):
1.	Edge Layer: Route 53 routes traffic through AWS WAF (protection against OWASP Top 10) to the Application Load

Balancer (ALB).
2.	Public Subnet: Houses only the NAT Gateways. No application servers are directly accessible from the internet.
3.	Private App Subnet: Application logic runs in an Auto Scaling Group distributed across two AZs. Completely isolated,

outbound internet access for updates is provided exclusively through NAT Gateways.
4.	Private Data Subnet: Amazon RDS runs as a Multi-AZ setup. The primary database synchronizes data to the

standby database in AZ B to guarantee immediate failover (Fault Tolerance).

• CALOSPRO-15: Document architecture decisions

Production Rationale: Documenting Architecture Decision Records (ADRs) to make architectural trade-offs and

designs transparent for future teams.

• CALOSPRO-16: Define naming and tagging standards

Production Rationale: Consistent tags (Environment, Project, Owner) for automated Cost Allocation Tracking and

dynamic IAM policies.

Phase 4: Networking & Security Infrastructure (CALOSPRO 17–25)

• CALOSPRO-17: Build the VPC Foundation

Production Rationale: Defining the appropriate CIDR block to prevent IP overlaps with corporate networks during

future VPN/Peering connections.

• CALOSPRO-18: Create the VPC and subnets

Production Rationale: Multi-AZ design. Strict segregation into Public (for the ALB) and Private Subnets (for compute)

across at least two Availability Zones.

• CALOSPRO-19: Configure internet routing

Production Rationale: Setting up the Internet Gateway exclusively for the public subnet, making direct attacks on

application servers impossible.

• CALOSPRO-20: Define the private egress strategy

Production Rationale: Implementing NAT Gateways or AWS VPC Endpoints (PrivateLink). Private instances can fetch

updates but remain completely unreachable from the outside.

• CALOSPRO-21: Implement Security Boundaries

Production Rationale: Layered defense using Network Access Control Lists (NACLs) at the subnet level as a second

line of defense (Defense in Depth).

• CALOSPRO-22: Create the load balancer security group

Production Rationale: Permits only dedicated web traffic (Port 80/443) from the public internet.

• CALOSPRO-23: Create the application security group

Production Rationale: Principle of Least Privilege: Allows incoming traffic exclusively from the Application Load

Balancer security group.

• CALOSPRO-24: Create the database security group

Production Rationale: Protects the data layer by strictly isolating incoming access to the application hosts and the

specific database port (e.g., 5432).

• CALOSPRO-25: Define administrative access

Production Rationale: No open Port 22 (SSH) to the outside. Utilizing AWS Systems Manager (SSM) Session

Manager for secure, role-based, and audited console access.

Phase 5: Compute, Load Balancing & High Availability (CALOSPRO 26–34)

• CALOSPRO-26: Create the Docker Host Launch Template

Production Rationale: Defining the baseline configuration (gold-standard AMI, instance type) for standardized,

replaceable Docker hosts.

• CALOSPRO-27: Create the instance IAM role

Production Rationale: Granting privileges via IAM Instance Profiles (e.g., ECR-Read, CloudWatch-Write). Static AWS

keys are never stored on servers.

• CALOSPRO-28: Create the bootstrap script

Production Rationale: User Data script for fully automated instantiation. Installs Docker and launches the container

infrastructure automatically upon booting without manual intervention.

• CALOSPRO-29: Create the launch template

Production Rationale: Versioning the host configuration for low-risk, rolling infrastructure updates and simple

rollbacks.

• CALOSPRO-30: Deploy Load Balancing and Auto Scaling

Production Rationale: Architectural decoupling of traffic distribution and scaling of the actual compute nodes.

• CALOSPRO-31: Create the target group

Production Rationale: Configuring precise HTTP health checks to instantly and automatically remove unhealthy or

crashed containers from the routing pool.

• CALOSPRO-32: Create the Application Load Balancer

Production Rationale: Layer-7 routing for advanced routing capabilities (e.g., path-based or host-based) and

centralized SSL/TLS termination.

• CALOSPRO-33: Create the Auto Scaling Group

Production Rationale: Dynamic horizontal scaling (Scale-Out/Scale-In) based on CPU utilization or request metrics for

cost and performance optimization.

• CALOSPRO-34: Test self-healing

Production Rationale: Chaos engineering approach. Manually terminating an instance proves in audits that the ASG

replaces the host within minutes automatically and with zero downtime.

Phase 6: Observability, Validation & Governance (CALOSPRO 35–46)

• CALOSPRO-35: Add Monitoring and Alerting

Production Rationale: Transforming from reactive IT ('firefighting') to proactive, data-driven system management.

• CALOSPRO-36: Create a CloudWatch dashboard

Production Rationale: Consolidated view of core metrics (CPU, RAM, ALB error rates, latency) for rapid triage during

incidents.

• CALOSPRO-37: Create actionable alarms

Production Rationale: Preventing alert fatigue. Alarms trigger only on true, operationally relevant anomalies and notify

the ops team via Amazon SNS.

• CALOSPRO-38: Centralize application logs

Production Rationale: Continuous streaming of all container logs (stdout/stderr) to CloudWatch Logs for forensic

analysis—critical, as container logs would otherwise be lost when an instance terminates.

• CALOSPRO-39: Validate Resilience and Security

Production Rationale: Final hardening and stability assessment of the overall system before production go-live.

• CALOSPRO-40: Run availability tests

Production Rationale: Load testing to simulate traffic spikes and validate Multi-AZ fault tolerance under simulated

datacenter failures.

• CALOSPRO-41: Run network access tests

Production Rationale: Automated security auditing. Verifying that all restricted paths (e.g., direct DB access from the

internet) are reliably blocked.

• CALOSPRO-42: Review the deployment against AWS Well-Architected pillars

Production Rationale: Formal review to ultimately validate all pillars of the framework for enterprise-level compliance.

• CALOSPRO-43: Create Runbooks and Final Deliverables

Production Rationale: Ensuring the long-term maintainability of the infrastructure by third parties (Day-2 Operations).

• CALOSPRO-44: Write deployment and update runbooks

Production Rationale: Standardized step-by-step documentation for future application releases and zero-downtime

rollbacks.

• CALOSPRO-45: Write the incident runbook

Production Rationale: Disaster recovery plan. Exact instructions and escalation matrixes for the on-call team during

critical outages.

• CALOSPRO-46: Complete the final demonstration

Production Rationale: Successful verification and sign-off of the operational, secure, and scaled system before

stakeholders.
