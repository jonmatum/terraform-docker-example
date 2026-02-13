# Quick Reference Guide

## All Examples at a Glance

### 1️⃣ Basic Example
**Location**: `example/`
**Purpose**: Learn Terraform module basics
**Tech**: Node.js + Nginx (inline commands)
**Time**: 2 minutes

```bash
cd example
terraform init && terraform apply
# Visit: http://localhost:3000 (backend), http://localhost:8080 (frontend)
terraform destroy
```

---

### 2️⃣ Advanced Example
**Location**: `advanced-example/`
**Purpose**: Real full-stack application
**Tech**: FastAPI + React + Vite
**Time**: 5 minutes (first build)

```bash
cd advanced-example
terraform init && terraform apply
# Visit: http://localhost:8000 (API), http://localhost:5173 (frontend)
terraform destroy
```

---

### 3️⃣ Docker Compose Example
**Location**: `docker-compose-example/`
**Purpose**: Compare with Terraform approach
**Tech**: Same as Advanced (FastAPI + React)
**Time**: 5 minutes (first build)

```bash
cd docker-compose-example
docker-compose up --build
# Visit: http://localhost:8000 (API), http://localhost:5173 (frontend)
docker-compose down
```

---

### 4️⃣ ECS LocalStack Example
**Location**: `ecs-localstack-example/`
**Purpose**: Test AWS ECS locally
**Tech**: ECS + Fargate + LocalStack
**Time**: 30 seconds (automated test)

```bash
cd ecs-localstack-example
./test.sh  # Automated test
# Or manual: docker-compose up -d && terraform apply
```

---

## Module Reference

### Docker Container Module
**Location**: `modules/docker-container/`
**Use for**: Local Docker containers

```hcl
module "app" {
  source = "./modules/docker-container"

  container_name = "my-app"
  image_name     = "nginx:latest"
  network_name   = "my-network"

  ports = [{
    internal = 80
    external = 8080
  }]

  environment = {
    ENV = "production"
  }
}
```

---

### ECS Service Module
**Location**: `modules/ecs-service/`
**Use for**: AWS ECS deployments

```hcl
module "ecs" {
  source = "./modules/ecs-service"

  cluster_name    = "my-cluster"
  task_family     = "my-task"
  container_name  = "app"
  container_image = "nginx:latest"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs.arn
  log_group_name     = "/ecs/app"
  aws_region         = "us-east-1"

  subnet_ids         = ["subnet-xxx"]
  security_group_ids = ["sg-xxx"]
}
```

---

## Decision Tree

```
Need to run containers?
│
├─ Locally only?
│  │
│  ├─ Simple setup? → Docker Compose Example
│  └─ Need modules/IaC? → Basic or Advanced Example
│
└─ On AWS?
   │
   ├─ Testing locally first? → ECS LocalStack Example
   └─ Deploy to real AWS? → Use ECS Module (change provider)
```

---

## Common Tasks

### View Running Containers
```bash
# Terraform
docker ps

# Docker Compose
docker-compose ps
```

### View Logs
```bash
# Terraform
docker logs <container-name>

# Docker Compose
docker-compose logs -f
```

### Rebuild After Changes
```bash
# Terraform
terraform apply

# Docker Compose
docker-compose up --build
```

### Clean Everything
```bash
# Terraform
terraform destroy
docker system prune -a

# Docker Compose
docker-compose down --rmi all -v
```

---

## Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Port in use | Change `external` port in config |
| Container exits | Check logs: `docker logs <name>` |
| Build fails | Ensure Docker is running |
| Terraform errors | Run `terraform init` again |
| LocalStack not ready | Wait 15-20 seconds after start |

---

## File Structure Overview

```
terraform-docker-example/
├── README.md                          # Main documentation
├── QUICK_REFERENCE.md                 # This file
│
├── modules/
│   ├── docker-container/              # Docker module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── ecs-service/                   # ECS module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
│
├── example/                           # Basic example
│   ├── main.tf
│   ├── outputs.tf
│   └── README.md
│
├── advanced-example/                  # FastAPI + React
│   ├── backend/
│   │   ├── main.py
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   ├── frontend/
│   │   ├── src/
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── main.tf
│   ├── outputs.tf
│   └── README.md
│
├── docker-compose-example/            # Docker Compose version
│   ├── backend/
│   ├── frontend/
│   ├── docker-compose.yml
│   └── README.md
│
└── ecs-localstack-example/            # ECS testing
    ├── main.tf
    ├── outputs.tf
    ├── docker-compose.yml
    ├── test.sh
    └── README.md
```

---

## Next Steps

1. **Start with Basic Example** to understand the module
2. **Try Advanced Example** to see real applications
3. **Compare with Docker Compose** to understand trade-offs
4. **Test ECS with LocalStack** before deploying to AWS
5. **Customize modules** for your specific needs

---

## Getting Help

- Check example-specific READMEs for detailed instructions
- Review module READMEs for configuration options
- See main README for troubleshooting guide
- Check Docker/Terraform logs for errors
