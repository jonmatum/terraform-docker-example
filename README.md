# Terraform Docker Modules

Reusable Terraform modules for managing Docker containers and AWS ECS with comprehensive examples.

## Project Structure

```
terraform-docker-modules/
├── modules/
│   ├── docker-container/         # Docker container module
│   └── ecs-fargate/              # AWS ECS Fargate module
├── examples/
│   ├── 01-basic-docker/          # Basic Docker example
│   ├── 02-fastapi-react/         # FastAPI + React application
│   ├── 03-docker-compose/        # Docker Compose comparison
│   └── 04-ecs-localstack/        # ECS with LocalStack testing
├── docs/
│   ├── QUICK_REFERENCE.md        # Quick reference guide
│   └── COMPARISON.md             # Terraform vs Docker Compose
├── README.md
└── .gitignore
```

## Examples

### 1️⃣ Basic Docker Example
Simple backend and frontend using inline commands.

**What you'll learn**: Module basics, Docker networking, port mapping

```bash
cd examples/01-basic-docker
terraform init
terraform apply
```

**Access**:
- Frontend: http://localhost:8080
- Backend: http://localhost:3000

**Clean up**:
```bash
terraform destroy
```

[📖 Full Documentation](examples/01-basic-docker/README.md)

---

### 2️⃣ FastAPI + React Example
Full-stack application with custom Dockerfiles.

**What you'll learn**: Building custom images, full-stack apps, CORS configuration

```bash
cd examples/02-fastapi-react
terraform init
terraform apply
```

**Access**:
- Backend API: http://localhost:8000
- Frontend: http://localhost:5173

**Clean up**:
```bash
terraform destroy
```

[📖 Full Documentation](examples/02-fastapi-react/README.md)

---

### 3️⃣ Docker Compose Example
Same FastAPI + React app using Docker Compose for comparison.

**What you'll learn**: Docker Compose vs Terraform, when to use each

```bash
cd examples/03-docker-compose
docker-compose up --build
```

**Access**:
- Backend API: http://localhost:8000
- Frontend: http://localhost:5173

**Clean up**:
```bash
docker-compose down
```

[📖 Full Documentation](examples/03-docker-compose/README.md)

---

### 4️⃣ ECS LocalStack Example
Test AWS ECS locally without costs using LocalStack.

**What you'll learn**: ECS clusters, task definitions, services, LocalStack testing

```bash
cd examples/04-ecs-localstack

# Automated test
./test.sh

# Or manual
docker-compose up -d
terraform init
terraform apply
```

**Verify**:
```bash
aws --endpoint-url=http://localhost:4566 ecs list-clusters
```

**Clean up**:
```bash
terraform destroy
docker-compose down
```

[📖 Full Documentation](examples/04-ecs-localstack/README.md)

---

## Modules

### Docker Container Module
Reusable module for managing Docker containers locally.

**Features**:
- Dynamic port mapping
- Environment variables
- Network configuration
- Custom commands

[📖 Module Documentation](modules/docker-container/README.md)

### ECS Fargate Module
Reusable module for AWS ECS clusters, task definitions, and services.

**Features**:
- Fargate task definitions
- ECS service creation
- CloudWatch Logs integration
- Configurable CPU/Memory
- Container Insights support

[📖 Module Documentation](modules/ecs-fargate/README.md)

---

## Documentation

- [Quick Reference Guide](docs/quick-reference.md) - One-page cheat sheet
- [Terraform vs Docker Compose](docs/comparison.md) - Detailed comparison
- [Development Guide](docs/development.md) - Contributing and development setup

---

## Comparison: Terraform vs Docker Compose

| Feature | Terraform | Docker Compose |
|---------|-----------|----------------|
| **Use Case** | Infrastructure as Code, multi-cloud | Local development, Docker-only |
| **State Management** | Yes (`.tfstate`) | No |
| **Modularity** | Reusable modules | Project-specific |
| **Scope** | Docker + Cloud resources | Docker only |
| **Preview Changes** | `terraform plan` | No preview |
| **Complexity** | Higher learning curve | Simpler syntax |
| **Best For** | Production, teams, cloud | Local dev, prototyping |

[📖 Full Comparison](docs/comparison.md)

---

## Prerequisites

### For Docker Examples (1-3):
- Docker Desktop or Docker Engine
- Terraform >= 1.0 (for Terraform examples)
- Docker Compose (for Compose example)

### For ECS LocalStack Example (4):
- Docker Desktop or Docker Engine
- Docker Compose
- Terraform >= 1.0
- AWS CLI (optional, for verification)

---

## Quick Start

### First Time Setup

1. **Install Docker**
   - macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - Linux: `sudo apt-get install docker.io`

2. **Install Terraform**
   ```bash
   # macOS
   brew install terraform

   # Linux
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

3. **Setup Development Environment** (optional, for contributors)
   ```bash
   make setup
   ```

4. **Verify Installation**
   ```bash
   docker --version
   terraform --version
   ```

### Choose Your Path

**New to Terraform?** → Start with [01-basic-docker](examples/01-basic-docker/README.md)

**Want a real app?** → Try [02-fastapi-react](examples/02-fastapi-react/README.md)

**Prefer Docker Compose?** → See [03-docker-compose](examples/03-docker-compose/README.md)

**Testing AWS ECS?** → Use [04-ecs-localstack](examples/04-ecs-localstack/README.md)

---

## Common Commands

### Make Commands (Recommended)
```bash
make help           # Show all available commands
make setup          # Setup development environment
make validate       # Validate all Terraform
make fmt            # Format Terraform files
make docs           # Generate documentation
make test-all       # Test all examples
make clean          # Clean Terraform files
make ci             # Run full CI pipeline locally
```

### Terraform
```bash
terraform init          # Initialize working directory
terraform plan          # Preview changes
terraform apply         # Create resources
terraform destroy       # Remove resources
terraform output        # Show outputs
terraform fmt           # Format code
terraform validate      # Validate configuration
```

### Docker Compose
```bash
docker-compose up           # Start services
docker-compose up -d        # Start in background
docker-compose down         # Stop and remove
docker-compose logs -f      # View logs
docker-compose ps           # List services
docker-compose restart      # Restart services
```

### Docker
```bash
docker ps                   # List running containers
docker logs <container>     # View container logs
docker exec -it <container> sh  # Shell into container
docker images               # List images
docker network ls           # List networks
```

---

## Troubleshooting

### Port Already in Use
```bash
# Find process using port
lsof -i :8080

# Kill process
kill -9 <PID>

# Or change port in configuration
```

### Docker Not Running
```bash
# Start Docker Desktop (macOS)
open -a Docker

# Start Docker daemon (Linux)
sudo systemctl start docker
```

### Terraform State Issues
```bash
# Remove state and start fresh
rm -rf .terraform terraform.tfstate*
terraform init
```

### Container Exits Immediately
```bash
# Check logs
docker logs <container-name>

# Check if command is specified
# Ensure Dockerfile has CMD or ENTRYPOINT
```

---

## Learning Path

1. **Start Here**: [01-basic-docker](examples/01-basic-docker/README.md)
   - Learn module usage
   - Understand Terraform basics
   - Simple Docker containers

2. **Build Real Apps**: [02-fastapi-react](examples/02-fastapi-react/README.md)
   - Custom Dockerfiles
   - Full-stack application
   - API + Frontend integration

3. **Compare Approaches**: [03-docker-compose](examples/03-docker-compose/README.md)
   - See the differences
   - Understand trade-offs
   - Choose the right tool

4. **Test AWS Locally**: [04-ecs-localstack](examples/04-ecs-localstack/README.md)
   - AWS ECS without costs
   - Production-like testing
   - CI/CD integration

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors

```bash
# Setup development environment
make setup

# Make changes and validate
make ci

# Commit with conventional commits
git commit -m "feat: your feature"
```

See [Development Guide](docs/development.md) for detailed instructions.

---

## Releases

Releases are automated using [release-please](https://github.com/googleapis/release-please). See [CHANGELOG.md](CHANGELOG.md) for release history.

---

## Resources

- [Terraform Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [LocalStack Documentation](https://docs.localstack.cloud/)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)

---

## License

MIT License - Feel free to use this for learning and production projects.
