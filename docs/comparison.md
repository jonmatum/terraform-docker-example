# Terraform vs Docker Compose: Complete Comparison

## Overview

Both Terraform and Docker Compose are declarative tools for managing containers, but they serve different purposes and excel in different scenarios.

---

## Quick Comparison

| Feature | Terraform | Docker Compose |
|---------|-----------|----------------|
| **Primary Purpose** | Infrastructure as Code (IaC) | Container orchestration |
| **Scope** | Multi-cloud + local | Docker only |
| **State Management** | Yes (`.tfstate` file) | No |
| **Change Preview** | `terraform plan` | No preview |
| **Modularity** | Reusable modules | Project-specific |
| **Learning Curve** | Steeper | Gentler |
| **Configuration** | HCL (HashiCorp Config Language) | YAML |
| **Best For** | Production, teams, IaC | Local dev, prototyping |

---

## Detailed Comparison

### 1. State Management

**Terraform:**
- Tracks infrastructure state in `.tfstate` file
- Knows what exists and what changed
- Can detect drift (manual changes)
- Supports remote state for team collaboration
- Only applies necessary changes

```bash
terraform plan   # Shows what will change
terraform apply  # Applies only changes
```

**Docker Compose:**
- No state tracking
- Recreates containers on each run
- No drift detection
- State is implicit (running containers)

```bash
docker-compose up  # Always recreates
```

**Winner:** Terraform for production, Compose for simplicity

---

### 2. Modularity & Reusability

**Terraform:**
```hcl
# Reusable module
module "app" {
  source = "./modules/docker-container"
  container_name = "my-app"
  # ... configuration
}

# Use same module multiple times
module "backend" { source = "./modules/docker-container" }
module "frontend" { source = "./modules/docker-container" }
```

**Docker Compose:**
```yaml
# Project-specific, not reusable
services:
  backend:
    build: ./backend
  frontend:
    build: ./frontend
```

**Winner:** Terraform for reusability

---

### 3. Multi-Cloud & Hybrid Infrastructure

**Terraform:**
```hcl
# Manage Docker + AWS in one config
resource "docker_container" "local_app" { }
resource "aws_s3_bucket" "storage" { }
resource "aws_rds_instance" "database" { }
```

**Docker Compose:**
```yaml
# Docker only, no cloud resources
services:
  app:
    image: myapp
```

**Winner:** Terraform (Compose can't manage cloud)

---

### 4. Syntax & Readability

**Terraform:**
```hcl
resource "docker_container" "app" {
  name  = "my-app"
  image = docker_image.app.image_id

  ports {
    internal = 80
    external = 8080
  }

  env = ["KEY=value"]
}
```

**Docker Compose:**
```yaml
services:
  app:
    image: myapp
    ports:
      - "8080:80"
    environment:
      - KEY=value
```

**Winner:** Docker Compose (simpler YAML)

---

### 5. Development Workflow

**Terraform:**
```bash
terraform init      # Initialize
terraform plan      # Preview changes
terraform apply     # Apply changes
terraform destroy   # Clean up
```

**Docker Compose:**
```bash
docker-compose up        # Start everything
docker-compose down      # Stop everything
docker-compose logs -f   # View logs
```

**Winner:** Docker Compose (fewer steps)

---

### 6. Team Collaboration

**Terraform:**
- Remote state (S3, Terraform Cloud)
- State locking prevents conflicts
- Version control friendly
- Plan output for code reviews

**Docker Compose:**
- No state to share
- Just commit YAML file
- No locking mechanism
- No preview for reviews

**Winner:** Terraform for teams

---

### 7. Testing & CI/CD

**Terraform:**
```yaml
# GitHub Actions
- terraform plan
- terraform apply -auto-approve
- terraform destroy
```
- Can test with LocalStack (AWS emulation)
- State management in CI
- Preview changes in PRs

**Docker Compose:**
```yaml
# GitHub Actions
- docker-compose up -d
- docker-compose run tests
- docker-compose down
```
- Simpler CI setup
- No state to manage
- Faster for simple tests

**Winner:** Tie (depends on use case)

---

## Use Case Recommendations

### Use Terraform When:

✅ Building production infrastructure
✅ Managing cloud resources (AWS, Azure, GCP)
✅ Need reusable modules across projects
✅ Working in teams with shared state
✅ Want infrastructure as code (IaC)
✅ Need to preview changes before applying
✅ Managing hybrid cloud + local environments
✅ Require drift detection

**Example scenarios:**
- Production web application with AWS RDS + S3
- Multi-environment deployments (dev, staging, prod)
- Infrastructure shared across multiple teams
- Compliance requirements for change tracking

---

### Use Docker Compose When:

✅ Local development only
✅ Simple multi-container applications
✅ Quick prototyping
✅ No cloud resources needed
✅ Small team or solo developer
✅ Learning Docker
✅ Temporary test environments

**Example scenarios:**
- Local development environment
- Running tests in CI
- Quick demos or POCs
- Learning containerization

---

## Migration Path

### From Docker Compose to Terraform

1. **Start with Compose** for local development
2. **Add Terraform** when you need:
   - Cloud resources
   - Multiple environments
   - Team collaboration
3. **Keep both**:
   - Compose for local dev
   - Terraform for production

### Example:
```
project/
├── docker-compose.yml        # Local development
└── terraform/
    ├── dev/                  # Dev environment
    ├── staging/              # Staging environment
    └── prod/                 # Production environment
```

---

## Real-World Example Comparison

### Scenario: FastAPI + React + PostgreSQL

**Docker Compose** (30 lines):
```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports: ["8000:8000"]
    environment:
      DATABASE_URL: postgres://db:5432
    depends_on: [db]

  frontend:
    build: ./frontend
    ports: ["5173:5173"]

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
```

**Terraform** (100+ lines):
```hcl
# Local containers
module "backend" { source = "./modules/docker-container" }
module "frontend" { source = "./modules/docker-container" }

# Production AWS
resource "aws_ecs_cluster" "prod" { }
resource "aws_rds_instance" "prod" { }
resource "aws_s3_bucket" "assets" { }
```

**Analysis:**
- Compose: Simpler for local dev
- Terraform: Can deploy to AWS with same modules

---

## Cost Comparison

### Terraform
- **Tool**: Free (open source)
- **Terraform Cloud**: Free tier available, paid for teams
- **Learning time**: 1-2 weeks
- **Maintenance**: Higher (state management)

### Docker Compose
- **Tool**: Free (open source)
- **Learning time**: 1-2 days
- **Maintenance**: Lower (no state)

---

## Performance

### Build Time
- **Compose**: Faster (simpler)
- **Terraform**: Slower (state checks, planning)

### Runtime
- **Both**: Same (both use Docker)

### Resource Usage
- **Both**: Same (containers are identical)

---

## Ecosystem & Community

### Terraform
- Larger ecosystem (AWS, Azure, GCP, etc.)
- 40k+ providers
- Strong enterprise adoption
- HashiCorp support

### Docker Compose
- Docker-focused community
- Simpler, more tutorials
- Better for beginners
- Docker Inc. support

---

## Decision Matrix

| Your Situation | Recommendation |
|----------------|----------------|
| Solo developer, local only | **Docker Compose** |
| Team of 2-5, local only | **Docker Compose** |
| Team of 5+, local only | **Terraform** (for consistency) |
| Any size, deploying to cloud | **Terraform** |
| Learning containers | **Docker Compose** |
| Learning IaC | **Terraform** |
| Startup MVP | **Docker Compose** |
| Enterprise production | **Terraform** |
| Multi-cloud strategy | **Terraform** |
| Simple microservices | **Docker Compose** |

---

## Hybrid Approach (Recommended)

Use both tools for their strengths:

```
Development:
  └─ Docker Compose (fast iteration)

Production:
  └─ Terraform (IaC, cloud resources)
```

**Benefits:**
- Fast local development with Compose
- Robust production with Terraform
- Developers use familiar Compose
- Ops team manages Terraform

---

## Conclusion

**There's no universal winner** - choose based on your needs:

- **Docker Compose**: Simple, fast, local development
- **Terraform**: Powerful, scalable, production infrastructure

**Best practice**: Start with Compose, graduate to Terraform when you need cloud resources or team collaboration.

---

## See Also

- [Quick Reference](quick-reference.md)
- [Example 02: FastAPI + React (Terraform)](../examples/02-fastapi-react/)
- [Example 03: Docker Compose Alternative](../examples/03-docker-compose/)
