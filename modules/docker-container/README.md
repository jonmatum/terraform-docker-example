# Docker Container Module

Terraform module for creating Docker containers.

## Usage

```hcl
module "container" {
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| container_name | Name of the Docker container | string | - | yes |
| image_name | Docker image name with tag | string | - | yes |
| network_name | Docker network name | string | - | yes |
| ports | Port mappings | list(object) | [] | no |
| environment | Environment variables | map(string) | {} | no |
| keep_image_locally | Keep image after destroy | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| container_id | ID of the Docker container |
| container_name | Name of the Docker container |
| image_id | ID of the Docker image |
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

No modules.

## Resources

| Name | Type |
|------|------|
| [docker_container.this](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container) | resource |
| [docker_image.this](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_command"></a> [command](#input\_command) | Command to run in the container | `list(string)` | `[]` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the Docker container | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables for the container | `map(string)` | `{}` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Docker image name with tag | `string` | n/a | yes |
| <a name="input_keep_image_locally"></a> [keep\_image\_locally](#input\_keep\_image\_locally) | Keep image locally after destroy | `bool` | `false` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Docker network name | `string` | n/a | yes |
| <a name="input_ports"></a> [ports](#input\_ports) | Port mappings for the container | <pre>list(object({<br/>    internal = number<br/>    external = number<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_id"></a> [container\_id](#output\_container\_id) | ID of the Docker container |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | Name of the Docker container |
| <a name="output_image_id"></a> [image\_id](#output\_image\_id) | ID of the Docker image |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
