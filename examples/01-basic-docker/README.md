# Basic Example: Simple Backend + Frontend

This example demonstrates the basic usage of the docker-container module with inline commands.

## What This Example Does

- Creates a Docker network for container communication
- Runs a Node.js backend with a simple HTTP server (port 3000)
- Runs an Nginx frontend (port 8080)
- Both containers communicate via the shared network

## Prerequisites

- Docker Desktop or Docker Engine installed and running
- Terraform >= 1.0 installed

## Usage

### 1. Initialize Terraform

```bash
cd example
terraform init
```

This downloads the Docker provider and initializes the working directory.

### 2. Review the Plan

```bash
terraform plan
```

This shows what resources Terraform will create:
- 1 Docker network
- 2 Docker images (Node.js and Nginx)
- 2 Docker containers (backend and frontend)

### 3. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted. Terraform will:
- Pull the Docker images
- Create the network
- Start both containers

### 4. Access the Applications

- **Frontend**: http://localhost:8080
- **Backend**: http://localhost:3000

### 5. View Outputs

```bash
terraform output
```

Shows the container IDs and URLs.

### 6. Clean Up

```bash
terraform destroy
```

Type `yes` to remove all resources.

## What You'll Learn

- How to use the reusable docker-container module
- How to create Docker networks with Terraform
- How to pass environment variables to containers
- How to map container ports
- How to use inline commands for simple containers

## Files

- `main.tf` - Main configuration with network and module usage
- `outputs.tf` - Output definitions for container info

## Troubleshooting

**Container exits immediately:**
- Ensure Docker is running
- Check container logs: `docker logs backend` or `docker logs frontend`

**Port already in use:**
- Change the `external` port in `main.tf`
- Or stop the conflicting service

**Terraform state issues:**
- Delete `.terraform.lock.hcl` and `.terraform/` directory
- Run `terraform init` again
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | 3.6.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | ../../modules/docker-container | n/a |
| <a name="module_frontend"></a> [frontend](#module\_frontend) | ../../modules/docker-container | n/a |

## Resources

| Name | Type |
|------|------|
| [docker_network.app_network](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/network) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_container_id"></a> [backend\_container\_id](#output\_backend\_container\_id) | Backend container ID |
| <a name="output_backend_url"></a> [backend\_url](#output\_backend\_url) | Backend URL |
| <a name="output_frontend_container_id"></a> [frontend\_container\_id](#output\_frontend\_container\_id) | Frontend container ID |
| <a name="output_frontend_url"></a> [frontend\_url](#output\_frontend\_url) | Frontend URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
