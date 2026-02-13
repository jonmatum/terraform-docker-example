# ECS Fargate Module

A reusable Terraform module for deploying containerized applications on AWS ECS (Elastic Container Service) using Fargate launch type.

## 📚 Educational Overview

### What This Module Does

This module simplifies the deployment of containerized applications on AWS ECS Fargate by abstracting the complexity of:

1. **ECS Cluster Creation**: Logical grouping of services and tasks
2. **Task Definitions**: Blueprint for running containers (CPU, memory, image)
3. **ECS Services**: Ensures desired number of tasks are running
4. **CloudWatch Logs**: Centralized logging for container output
5. **IAM Roles**: Permissions for ECS tasks to access AWS services
6. **Networking**: VPC, subnets, and security groups configuration

### How It Works

```
┌──────────────────────────────────────────────────────────────────┐
│                      ECS Fargate Architecture                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Input Variables                                                  │
│  ├── cluster_name         → Name of ECS cluster                  │
│  ├── task_family          → Task definition family name          │
│  ├── container_definitions → Container specs (image, ports, etc) │
│  ├── cpu / memory         → Resource allocation                  │
│  ├── execution_role_arn   → IAM role for ECS agent               │
│  ├── subnets / security_groups → Network configuration           │
│  └── desired_count        → Number of tasks to run               │
│                                                                   │
│  ▼                                                                │
│                                                                   │
│  Resources Created                                                │
│  ├── aws_ecs_cluster      → Logical container for services       │
│  ├── aws_ecs_task_definition → Container blueprint               │
│  └── aws_ecs_service      → Maintains desired task count         │
│                                                                   │
│  ▼                                                                │
│                                                                   │
│  AWS Fargate (Serverless)                                         │
│  ├── Provisions compute resources automatically                  │
│  ├── Runs containers based on task definition                    │
│  ├── Handles scaling and availability                            │
│  └── Sends logs to CloudWatch                                    │
│                                                                   │
│  ▼                                                                │
│                                                                   │
│  Outputs                                                          │
│  ├── cluster_arn          → Reference to cluster                 │
│  ├── task_definition_arn  → Reference to task definition         │
│  └── service_id           → Reference to service                 │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Key Concepts

#### 1. ECS Cluster
```hcl
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}
```
- **Purpose**: Logical grouping of ECS services and tasks
- **Container Insights**: Optional monitoring and observability
- **Capacity**: Can run multiple services with different task definitions

#### 2. Task Definition
```hcl
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.container_definitions
  execution_role_arn       = var.execution_role_arn
}
```
- **Family**: Name and versioning for task definitions
- **Fargate**: Serverless compute engine (no EC2 management)
- **awsvpc**: Each task gets its own ENI and private IP
- **CPU/Memory**: Must use specific combinations (see AWS docs)
- **Container Definitions**: JSON describing containers to run

#### 3. ECS Service
```hcl
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }
}
```
- **Purpose**: Maintains desired number of running tasks
- **Auto-recovery**: Replaces failed tasks automatically
- **Deployment**: Handles rolling updates when task definition changes
- **Network**: Requires VPC subnets and security groups

#### 4. Container Definitions (JSON)
```json
[
  {
    "name": "app",
    "image": "nginx:alpine",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/my-app",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "app"
      }
    },
    "environment": [
      {
        "name": "ENV",
        "value": "production"
      }
    ]
  }
]
```
- **name**: Container identifier within task
- **image**: Docker image from ECR or Docker Hub
- **essential**: Task fails if this container stops
- **portMappings**: Ports to expose (no host port needed with awsvpc)
- **logConfiguration**: CloudWatch Logs integration
- **environment**: Static environment variables

#### 5. IAM Execution Role
```hcl
# Required for ECS to pull images and write logs
resource "aws_iam_role" "ecs_execution" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}
```
- **Purpose**: Allows ECS agent to pull images and write logs
- **Required Permissions**:
  - ECR image pull
  - CloudWatch Logs write
  - Secrets Manager (if using secrets)

## 🎯 Usage Examples

### Basic Example
```hcl
module "web_service" {
  source = "../../modules/ecs-fargate"

  cluster_name = "production-cluster"
  task_family  = "web-app"
  service_name = "web-service"

  cpu    = "256"
  memory = "512"

  container_definitions = jsonencode([{
    name      = "nginx"
    image     = "nginx:alpine"
    essential = true
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/web-app"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "nginx"
      }
    }
  }])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  subnets            = ["subnet-abc123", "subnet-def456"]
  security_groups    = ["sg-xyz789"]
  assign_public_ip   = true
  desired_count      = 2
}
```

### With Environment Variables
```hcl
module "api_service" {
  source = "../../modules/ecs-fargate"

  cluster_name = "production-cluster"
  task_family  = "api-app"
  service_name = "api-service"

  cpu    = "512"
  memory = "1024"

  container_definitions = jsonencode([{
    name      = "api"
    image     = "myapp/api:v1.0.0"
    essential = true
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    environment = [
      { name = "NODE_ENV", value = "production" },
      { name = "PORT", value = "3000" },
      { name = "DB_HOST", value = "database.example.com" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/api-app"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "api"
      }
    }
  }])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.api.id]
  assign_public_ip   = false
  desired_count      = 3
}
```

### Multi-Container Task
```hcl
module "app_with_sidecar" {
  source = "../../modules/ecs-fargate"

  cluster_name = "production-cluster"
  task_family  = "app-with-proxy"
  service_name = "app-service"

  cpu    = "1024"
  memory = "2048"

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "myapp:latest"
      essential = true
      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/app"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "app"
        }
      }
    },
    {
      name      = "envoy-proxy"
      image     = "envoyproxy/envoy:v1.24.0"
      essential = false
      portMappings = [{
        containerPort = 9901
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/app"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "envoy"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.app.id]
  desired_count      = 2
}
```

## 📖 Input Variables Explained

### Required Variables

#### `cluster_name` (string)
- **Purpose**: Name of the ECS cluster
- **Example**: `"production-cluster"`, `"staging-cluster"`
- **Best Practice**: Use environment-specific names
- **Note**: Cluster can host multiple services

#### `task_family` (string)
- **Purpose**: Name for the task definition family
- **Example**: `"web-app"`, `"api-service"`
- **Versioning**: AWS automatically versions task definitions
- **Best Practice**: Use descriptive names matching your application

#### `container_definitions` (string - JSON)
- **Purpose**: Defines containers to run in the task
- **Format**: JSON-encoded array of container definitions
- **Required Fields**: name, image, essential
- **Optional Fields**: environment, secrets, portMappings, logConfiguration
- **Tip**: Use `jsonencode()` for cleaner Terraform code

#### `cpu` (string)
- **Purpose**: CPU units for the task (1024 = 1 vCPU)
- **Valid Values**: "256", "512", "1024", "2048", "4096"
- **Note**: Must match valid CPU/memory combinations
- **Example**: "512" = 0.5 vCPU

#### `memory` (string)
- **Purpose**: Memory in MB for the task
- **Valid Values**: Depends on CPU (see AWS Fargate docs)
- **Example**: "1024" = 1 GB
- **Note**: Total for all containers in task

#### `execution_role_arn` (string)
- **Purpose**: IAM role for ECS agent
- **Required Permissions**:
  - `ecr:GetAuthorizationToken`
  - `ecr:BatchCheckLayerAvailability`
  - `ecr:GetDownloadUrlForLayer`
  - `ecr:BatchGetImage`
  - `logs:CreateLogStream`
  - `logs:PutLogEvents`

### Optional Variables

#### `service_name` (string)
- **Purpose**: Name of the ECS service
- **Default**: Uses `task_family` if not specified
- **Example**: `"web-service"`, `"api-service"`

#### `desired_count` (number)
- **Purpose**: Number of tasks to run
- **Default**: `1`
- **Use Cases**:
  - Development: 1
  - Production: 2+ for high availability
  - Auto-scaling: Adjust based on load

#### `subnets` (list of strings)
- **Purpose**: VPC subnets for task ENIs
- **Default**: `[]` (service not created if empty)
- **Best Practice**: Use private subnets for security
- **High Availability**: Use subnets in multiple AZs

#### `security_groups` (list of strings)
- **Purpose**: Security groups for task network interfaces
- **Default**: `[]`
- **Required Rules**:
  - Ingress: Allow traffic to container ports
  - Egress: Allow outbound traffic (internet, databases, etc.)

#### `assign_public_ip` (bool)
- **Purpose**: Assign public IP to tasks
- **Default**: `false`
- **When true**: Tasks can access internet directly
- **When false**: Requires NAT Gateway for internet access

#### `enable_container_insights` (bool)
- **Purpose**: Enable CloudWatch Container Insights
- **Default**: `false`
- **Benefits**: Enhanced monitoring and metrics
- **Cost**: Additional CloudWatch charges

#### `tags` (map of strings)
- **Purpose**: AWS tags for resources
- **Default**: `{}`
- **Best Practice**: Tag with environment, team, cost center
- **Example**:
  ```hcl
  tags = {
    Environment = "production"
    Team        = "platform"
    ManagedBy   = "terraform"
  }
  ```

## 📤 Outputs Explained

### `cluster_arn`
- **Type**: string
- **Purpose**: ARN of the ECS cluster
- **Use Cases**:
  - Reference in other services
  - IAM policies
  - Monitoring and alerting

### `cluster_name`
- **Type**: string
- **Purpose**: Name of the ECS cluster
- **Use Cases**:
  - AWS CLI commands
  - Documentation
  - Service discovery

### `task_definition_arn`
- **Type**: string
- **Purpose**: ARN of the task definition (includes revision)
- **Use Cases**:
  - Manual task runs
  - Debugging specific versions
  - Rollback procedures

### `service_id`
- **Type**: string
- **Purpose**: ID of the ECS service
- **Use Cases**:
  - Service updates
  - Monitoring
  - Auto-scaling configuration

## 🔍 How ECS Fargate Works

### Task Lifecycle

1. **Task Definition Created**
   - Terraform registers task definition with ECS
   - AWS assigns revision number (e.g., `my-app:1`)

2. **Service Created**
   - ECS service references task definition
   - Desired count specified (e.g., 2 tasks)

3. **Fargate Provisions Resources**
   - AWS allocates compute resources
   - No EC2 instances to manage

4. **Containers Start**
   - ECS agent pulls Docker images
   - Containers start based on task definition
   - Health checks begin

5. **Service Maintains State**
   - Monitors task health
   - Replaces failed tasks automatically
   - Handles rolling deployments

### Networking (awsvpc Mode)

```
┌─────────────────────────────────────────────┐
│              VPC (10.0.0.0/16)              │
│                                             │
│  ┌────────────────┐  ┌────────────────┐   │
│  │ Subnet A       │  │ Subnet B       │   │
│  │ (10.0.1.0/24)  │  │ (10.0.2.0/24)  │   │
│  │                │  │                │   │
│  │  ┌──────────┐  │  │  ┌──────────┐  │   │
│  │  │ Task 1   │  │  │  │ Task 2   │  │   │
│  │  │ ENI      │  │  │  │ ENI      │  │   │
│  │  │ 10.0.1.5 │  │  │  │ 10.0.2.8 │  │   │
│  │  └──────────┘  │  │  └──────────┘  │   │
│  └────────────────┘  └────────────────┘   │
│                                             │
│  Security Group: Controls traffic          │
│  ├─ Ingress: Port 80 from ALB              │
│  └─ Egress: All traffic                    │
│                                             │
└─────────────────────────────────────────────┘
```

- Each task gets its own ENI (Elastic Network Interface)
- Private IP address from subnet
- Security groups control traffic
- No port conflicts (each task isolated)

### CPU and Memory Combinations

Valid Fargate CPU/Memory combinations:

| CPU (vCPU) | Memory (GB) |
|------------|-------------|
| 0.25       | 0.5, 1, 2   |
| 0.5        | 1, 2, 3, 4  |
| 1          | 2, 3, 4, 5, 6, 7, 8 |
| 2          | 4-16 (1 GB increments) |
| 4          | 8-30 (1 GB increments) |

## 🎓 Learning Examples

### Example 1: Simple Web Service
```hcl
# Create cluster
module "web_cluster" {
  source = "../../modules/ecs-fargate"

  cluster_name = "web-cluster"
  task_family  = "nginx-task"
  service_name = "nginx-service"

  cpu    = "256"
  memory = "512"

  container_definitions = jsonencode([{
    name      = "nginx"
    image     = "nginx:alpine"
    essential = true
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.web.id]
  assign_public_ip   = true
  desired_count      = 2
}
```

**What happens:**
1. ECS cluster "web-cluster" created
2. Task definition registered with Nginx container
3. Service ensures 2 tasks are always running
4. Tasks get public IPs (can be accessed directly)
5. If a task fails, ECS starts a replacement

### Example 2: Private API Service
```hcl
module "api_service" {
  source = "../../modules/ecs-fargate"

  cluster_name = "api-cluster"
  task_family  = "api-task"
  service_name = "api-service"

  cpu    = "512"
  memory = "1024"

  container_definitions = jsonencode([{
    name      = "api"
    image     = "mycompany/api:v2.1.0"
    essential = true
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    environment = [
      { name = "NODE_ENV", value = "production" },
      { name = "DB_HOST", value = "rds.example.com" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/api"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "api"
      }
    }
  }])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  subnets            = aws_subnet.private[*].id
  security_groups    = [aws_security_group.api.id]
  assign_public_ip   = false  # Private subnet with NAT
  desired_count      = 3
}
```

**What happens:**
1. Tasks run in private subnets (more secure)
2. No public IPs assigned
3. Access internet via NAT Gateway
4. Logs sent to CloudWatch
5. 3 tasks for high availability

## 🔧 Troubleshooting

### Tasks Won't Start
```bash
# Check service events
aws ecs describe-services \
  --cluster <cluster-name> \
  --services <service-name>

# Check task stopped reason
aws ecs describe-tasks \
  --cluster <cluster-name> \
  --tasks <task-id>

# Common issues:
# - Image pull errors (check ECR permissions)
# - Insufficient CPU/memory
# - Security group blocking traffic
# - Subnet has no available IPs
```

### Container Logs
```bash
# View logs in CloudWatch
aws logs tail /ecs/<app-name> --follow

# Or use AWS Console:
# CloudWatch → Log Groups → /ecs/<app-name>
```

### Network Issues
```bash
# Verify security group rules
aws ec2 describe-security-groups \
  --group-ids <sg-id>

# Check subnet routing
aws ec2 describe-route-tables \
  --filters "Name=association.subnet-id,Values=<subnet-id>"

# Common issues:
# - Security group not allowing ingress
# - No route to internet (missing NAT/IGW)
# - Subnet in wrong AZ
```

## 🎯 Best Practices

1. **Use Private Subnets**: More secure, use NAT Gateway for internet
2. **Multiple AZs**: Distribute tasks across availability zones
3. **Right-size Resources**: Start small, monitor, adjust CPU/memory
4. **Enable Logging**: Always configure CloudWatch Logs
5. **Use Specific Image Tags**: Avoid `:latest` for reproducibility
6. **Health Checks**: Configure health checks for auto-recovery
7. **Secrets Management**: Use AWS Secrets Manager for sensitive data
8. **Monitoring**: Enable Container Insights for production
9. **Cost Optimization**: Use Fargate Spot for non-critical workloads
10. **Tagging**: Tag all resources for cost tracking and organization

## 📚 Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Fargate Task Definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/intro.html)
- [Fargate Pricing](https://aws.amazon.com/fargate/pricing/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign public IP to tasks | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions JSON | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task | `string` | n/a | yes |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of tasks | `number` | `1` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable Container Insights | `bool` | `false` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | IAM role ARN for task execution | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task in MB | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security groups for tasks | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets for tasks | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | `{}` | no |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | Task definition family name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the ECS cluster |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ID of the ECS service |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the task definition |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
