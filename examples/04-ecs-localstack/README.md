# ECS LocalStack Example

Test the ECS module locally using LocalStack without AWS costs.

> **⚠️ Note**: This example requires **LocalStack Pro** (paid license) as the free version doesn't support ECS API. The Terraform configuration is valid and can be used with real AWS or LocalStack Pro.

## What This Example Does

- Runs LocalStack to emulate AWS services locally
- Creates VPC, subnet, and security group
- Creates IAM roles for ECS
- Deploys an Nginx container using the ECS module
- Tests ECS cluster, task definition, and service creation

## Prerequisites

- Docker Desktop or Docker Engine
- Docker Compose
- Terraform >= 1.0
- **LocalStack Pro license** (for ECS support)
- AWS CLI (optional, for verification)

## Quick Start

### 1. Start LocalStack

```bash
cd ecs-localstack-example
docker-compose up -d
```

Wait 10-15 seconds for LocalStack to initialize.

### 2. Verify LocalStack is Running

```bash
curl http://localhost:4566/_localstack/health
```

Should return JSON with service statuses.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted. This creates:
- VPC and networking
- IAM roles
- CloudWatch log group
- ECS cluster
- ECS task definition
- ECS service

### 5. Verify Resources

```bash
# List ECS clusters
aws --endpoint-url=http://localhost:4566 ecs list-clusters

# Describe cluster
aws --endpoint-url=http://localhost:4566 ecs describe-clusters --clusters test-cluster

# List services
aws --endpoint-url=http://localhost:4566 ecs list-services --cluster test-cluster

# List task definitions
aws --endpoint-url=http://localhost:4566 ecs list-task-definitions

# Describe task definition
aws --endpoint-url=http://localhost:4566 ecs describe-task-definition --task-definition nginx-task
```

### 6. View Terraform Outputs

```bash
terraform output
```

### 7. Clean Up

```bash
# Destroy Terraform resources
terraform destroy

# Stop LocalStack
docker-compose down

# Remove LocalStack data (optional)
rm -rf localstack-data
```

## Testing Workflow

```bash
# Full test cycle
docker-compose up -d
sleep 15
terraform init
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
docker-compose down
```

## Verification Commands

### Check ECS Resources

```bash
# Set endpoint for convenience
export AWS_ENDPOINT=http://localhost:4566

# List all clusters
aws --endpoint-url=$AWS_ENDPOINT ecs list-clusters

# Get cluster details
aws --endpoint-url=$AWS_ENDPOINT ecs describe-clusters \
  --clusters test-cluster \
  --include STATISTICS

# List services in cluster
aws --endpoint-url=$AWS_ENDPOINT ecs list-services \
  --cluster test-cluster

# Describe service
aws --endpoint-url=$AWS_ENDPOINT ecs describe-services \
  --cluster test-cluster \
  --services nginx-service

# List tasks
aws --endpoint-url=$AWS_ENDPOINT ecs list-tasks \
  --cluster test-cluster

# Describe task definition
aws --endpoint-url=$AWS_ENDPOINT ecs describe-task-definition \
  --task-definition nginx-task
```

### Check Networking

```bash
# List VPCs
aws --endpoint-url=$AWS_ENDPOINT ec2 describe-vpcs

# List subnets
aws --endpoint-url=$AWS_ENDPOINT ec2 describe-subnets

# List security groups
aws --endpoint-url=$AWS_ENDPOINT ec2 describe-security-groups
```

### Check IAM

```bash
# List roles
aws --endpoint-url=$AWS_ENDPOINT iam list-roles

# Get role
aws --endpoint-url=$AWS_ENDPOINT iam get-role \
  --role-name ecs-execution-role
```

## LocalStack Configuration

The `docker-compose.yml` configures LocalStack with:

- **Services**: ECS, ECR, EC2, IAM, CloudWatch Logs, STS
- **Port**: 4566 (single endpoint for all services)
- **Debug**: Enabled for troubleshooting
- **Docker socket**: Mounted for container management
- **Data persistence**: `./localstack-data` directory

## Limitations

### LocalStack ECS Limitations:

- ❌ Fargate may not fully work (use EC2 launch type in production)
- ❌ Some advanced ECS features unavailable
- ❌ Container Insights not supported
- ❌ Service discovery limited
- ⚠️ Task execution may differ from real AWS

### What Works:

- ✅ Cluster creation
- ✅ Task definition registration
- ✅ Service creation
- ✅ Basic networking
- ✅ IAM role creation
- ✅ CloudWatch log groups

## Troubleshooting

**LocalStack not starting:**
```bash
docker-compose logs localstack
```

**Connection refused:**
- Wait 15-20 seconds after starting LocalStack
- Check: `curl http://localhost:4566/_localstack/health`

**Terraform errors:**
- Ensure LocalStack is running
- Check endpoint configuration in `main.tf`
- Verify Docker socket is accessible

**Resources not found:**
- LocalStack data is ephemeral by default
- Restart LocalStack to clear state
- Check `localstack-data/` directory

**Port 4566 already in use:**
```bash
# Find process
lsof -i :4566

# Stop LocalStack
docker-compose down
```

## CI/CD Integration

Use this example in CI pipelines:

```yaml
# GitHub Actions example
- name: Start LocalStack
  run: docker-compose up -d

- name: Wait for LocalStack
  run: sleep 15

- name: Test Terraform
  run: |
    terraform init
    terraform apply -auto-approve
    terraform destroy -auto-approve
```

## Next Steps

- Modify the module to add load balancers
- Test with multiple services
- Add auto-scaling configuration
- Deploy to real AWS after local testing
- Create integration tests

## Comparison: LocalStack vs Real AWS

| Feature | LocalStack | Real AWS |
|---------|-----------|----------|
| **Cost** | Free | Pay per use |
| **Speed** | Fast | Network latency |
| **Features** | Limited | Full |
| **Testing** | Perfect | Expensive |
| **CI/CD** | Easy | Complex |
| **Accuracy** | ~80% | 100% |

Use LocalStack for development and testing, then deploy to real AWS for production.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nginx_service"></a> [nginx\_service](#module\_nginx\_service) | ../../modules/ecs-fargate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the ECS cluster |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the ECS service |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Subnet ID |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the task definition |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
