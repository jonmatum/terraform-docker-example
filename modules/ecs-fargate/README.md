# ECS Fargate Module

Terraform module for creating AWS ECS clusters, task definitions, and services using Fargate.

## Features

- ECS Cluster creation
- Fargate task definitions
- ECS Service with networking
- CloudWatch Logs integration
- Configurable CPU/Memory
- Environment variables support

## Usage

```hcl
module "ecs_service" {
  source = "./modules/ecs-fargate"

  cluster_name    = "my-cluster"
  task_family     = "my-app"
  container_name  = "app"
  container_image = "nginx:latest"
  container_ports = [80]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  log_group_name     = "/ecs/my-app"
  aws_region         = "us-east-1"

  create_service      = true
  service_name        = "my-service"
  desired_count       = 2
  subnet_ids          = ["subnet-xxx", "subnet-yyy"]
  security_group_ids  = ["sg-xxx"]
  assign_public_ip    = true

  environment = {
    ENV = "production"
  }

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the ECS cluster | string | - | yes |
| task_family | Family name for task definition | string | - | yes |
| container_name | Name of the container | string | - | yes |
| container_image | Docker image | string | - | yes |
| container_ports | Container ports to expose | list(number) | [] | no |
| cpu | CPU units | string | "256" | no |
| memory | Memory in MB | string | "512" | no |
| execution_role_arn | Task execution role ARN | string | - | yes |
| task_role_arn | Task role ARN | string | "" | no |
| environment | Environment variables | map(string) | {} | no |
| log_group_name | CloudWatch log group | string | - | yes |
| aws_region | AWS region | string | - | yes |
| create_service | Create ECS service | bool | true | no |
| service_name | ECS service name | string | "" | no |
| desired_count | Desired task count | number | 1 | no |
| subnet_ids | Subnet IDs | list(string) | [] | no |
| security_group_ids | Security group IDs | list(string) | [] | no |
| assign_public_ip | Assign public IP | bool | false | no |
| enable_container_insights | Enable Container Insights | bool | false | no |
| tags | Resource tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ECS cluster ID |
| cluster_arn | ECS cluster ARN |
| cluster_name | ECS cluster name |
| task_definition_arn | Task definition ARN |
| task_definition_family | Task definition family |
| service_id | ECS service ID |
| service_name | ECS service name |

## Testing with LocalStack

See the `examples/04-ecs-localstack` for testing this module locally with LocalStack.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

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
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Docker image for the container | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| <a name="input_container_ports"></a> [container\_ports](#input\_container\_ports) | List of container ports to expose | `list(number)` | `[]` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task (256, 512, 1024, 2048, 4096) | `string` | `"256"` | no |
| <a name="input_create_service"></a> [create\_service](#input\_create\_service) | Whether to create an ECS service | `bool` | `true` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of tasks | `number` | `1` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable CloudWatch Container Insights | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables for the container | `map(string)` | `{}` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | ARN of the task execution role | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | CloudWatch log group name | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task in MB (512, 1024, 2048, etc.) | `string` | `"512"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the service | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | Family name for the task definition | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ARN of the task role | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the ECS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the ECS cluster |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ID of the ECS service |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the ECS service |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the task definition |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Family of the task definition |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

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
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Docker image for the container | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| <a name="input_container_ports"></a> [container\_ports](#input\_container\_ports) | List of container ports to expose | `list(number)` | `[]` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task (256, 512, 1024, 2048, 4096) | `string` | `"256"` | no |
| <a name="input_create_service"></a> [create\_service](#input\_create\_service) | Whether to create an ECS service | `bool` | `true` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of tasks | `number` | `1` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable CloudWatch Container Insights | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables for the container | `map(string)` | `{}` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | ARN of the task execution role | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | CloudWatch log group name | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task in MB (512, 1024, 2048, etc.) | `string` | `"512"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the service | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | Family name for the task definition | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ARN of the task role | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the ECS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the ECS cluster |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ID of the ECS service |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the ECS service |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the task definition |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Family of the task definition |
<!-- END_TF_DOCS -->
