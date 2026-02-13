# Docker Container Module

A reusable Terraform module for managing Docker containers with support for port mapping, environment variables, networking, and custom commands.

## 📚 Educational Overview

### What This Module Does

This module abstracts the complexity of creating Docker containers with Terraform by providing a simple interface for common Docker operations. It handles:

1. **Image Management**: Pulls or references Docker images
2. **Container Creation**: Creates and starts containers with specified configuration
3. **Network Configuration**: Connects containers to Docker networks
4. **Port Mapping**: Exposes container ports to the host
5. **Environment Variables**: Injects configuration into containers
6. **Lifecycle Management**: Manages container state through Terraform

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                     Module Architecture                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Input Variables                                             │
│  ├── container_name    → Identifies the container           │
│  ├── image_name        → Specifies Docker image             │
│  ├── network_name      → Network for communication          │
│  ├── ports             → Host-to-container port mapping     │
│  ├── environment       → Configuration via env vars         │
│  └── command           → Override container command         │
│                                                              │
│  ▼                                                           │
│                                                              │
│  Resources Created                                           │
│  ├── docker_image      → Pulls/references the image         │
│  └── docker_container  → Creates and runs container         │
│                                                              │
│  ▼                                                           │
│                                                              │
│  Outputs                                                     │
│  ├── container_id      → For reference/debugging            │
│  ├── container_name    → For service discovery              │
│  └── image_id          → For image tracking                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Key Concepts

#### 1. Docker Image Resource
```hcl
resource "docker_image" "this" {
  name         = var.image_name
  keep_locally = var.keep_image_locally
}
```
- **Purpose**: Ensures the Docker image exists locally
- **Behavior**: Pulls image if not present, references if exists
- **keep_locally**: Controls whether image is deleted on `terraform destroy`

#### 2. Docker Container Resource
```hcl
resource "docker_container" "this" {
  name  = var.container_name
  image = docker_image.this.image_id
  # ... configuration
}
```
- **Purpose**: Creates and manages the container lifecycle
- **Dependencies**: Automatically waits for image to be available
- **State Management**: Terraform tracks container state

#### 3. Port Mapping
```hcl
dynamic "ports" {
  for_each = var.ports
  content {
    internal = ports.value.internal  # Container port
    external = ports.value.external  # Host port
    protocol = ports.value.protocol  # tcp/udp
  }
}
```
- **Dynamic Block**: Creates port mappings from list input
- **Flexibility**: Supports multiple ports with different protocols
- **Example**: `internal = 80, external = 8080` maps host:8080 → container:80

#### 4. Environment Variables
```hcl
env = [for key, value in var.environment : "${key}=${value}"]
```
- **List Comprehension**: Converts map to list of "KEY=VALUE" strings
- **Docker Format**: Matches Docker's environment variable format
- **Use Case**: Configuration, secrets, feature flags

#### 5. Network Configuration
```hcl
networks_advanced {
  name = var.network_name
}
```
- **Purpose**: Connects container to specified Docker network
- **Benefit**: Enables container-to-container communication
- **DNS**: Containers can reference each other by name

## 🎯 Usage Examples

### Basic Example
```hcl
module "web_server" {
  source = "../../modules/docker-container"

  container_name = "nginx-web"
  image_name     = "nginx:alpine"
  network_name   = "app-network"

  ports = [{
    internal = 80
    external = 8080
    protocol = "tcp"
  }]
}
```

### With Environment Variables
```hcl
module "api_server" {
  source = "../../modules/docker-container"

  container_name = "api"
  image_name     = "node:18-alpine"
  network_name   = "app-network"

  ports = [{
    internal = 3000
    external = 3000
    protocol = "tcp"
  }]

  environment = {
    NODE_ENV = "production"
    PORT     = "3000"
    DB_HOST  = "database"
  }

  command = ["node", "server.js"]
}
```

### Multiple Ports
```hcl
module "multi_port_app" {
  source = "../../modules/docker-container"

  container_name = "app"
  image_name     = "myapp:latest"
  network_name   = "app-network"

  ports = [
    {
      internal = 80
      external = 8080
      protocol = "tcp"
    },
    {
      internal = 443
      external = 8443
      protocol = "tcp"
    }
  ]
}
```

## 📖 Input Variables Explained

### Required Variables

#### `container_name` (string)
- **Purpose**: Unique identifier for the container
- **Example**: `"my-app"`, `"backend-api"`, `"frontend-web"`
- **Best Practice**: Use descriptive names that indicate the service purpose
- **Note**: Must be unique across all running containers

#### `image_name` (string)
- **Purpose**: Specifies which Docker image to use
- **Format**: `image:tag` or `registry/image:tag`
- **Examples**:
  - `"nginx:alpine"` - Official Nginx with Alpine Linux
  - `"node:18-alpine"` - Node.js version 18 on Alpine
  - `"myregistry.io/myapp:v1.0.0"` - Custom registry image
- **Best Practice**: Always specify a tag (avoid `:latest` in production)

#### `network_name` (string)
- **Purpose**: Docker network for container communication
- **Example**: `"app-network"`, `"backend-network"`
- **Why Important**: Enables containers to communicate using container names as DNS
- **Note**: Network must exist before creating containers

### Optional Variables

#### `ports` (list of objects)
- **Purpose**: Maps container ports to host ports
- **Default**: `[]` (no ports exposed)
- **Structure**:
  ```hcl
  ports = [{
    internal = 80      # Port inside container
    external = 8080    # Port on host machine
    protocol = "tcp"   # tcp or udp
  }]
  ```
- **Use Cases**:
  - Web servers: Map 80 → 8080
  - APIs: Map 3000 → 3000
  - Databases: Map 5432 → 5432

#### `environment` (map of strings)
- **Purpose**: Inject configuration into container
- **Default**: `{}` (no environment variables)
- **Format**: `{ KEY = "value" }`
- **Examples**:
  ```hcl
  environment = {
    NODE_ENV = "production"
    API_KEY  = "secret-key"
    DEBUG    = "false"
  }
  ```
- **Best Practice**: Use for non-sensitive config; use secrets management for sensitive data

#### `command` (list of strings)
- **Purpose**: Override the default container command
- **Default**: `[]` (uses image's default CMD)
- **Format**: `["executable", "arg1", "arg2"]`
- **Examples**:
  ```hcl
  command = ["node", "server.js"]
  command = ["python", "-m", "http.server", "8000"]
  command = ["sh", "-c", "while true; do echo hello; sleep 10; done"]
  ```

#### `keep_image_locally` (bool)
- **Purpose**: Control image deletion on destroy
- **Default**: `false` (image deleted on destroy)
- **When to use `true`**: Shared images used by multiple containers
- **When to use `false`**: Temporary or test environments

## 📤 Outputs Explained

### `container_id`
- **Type**: string
- **Purpose**: Unique identifier for the running container
- **Use Cases**:
  - Debugging: `docker logs <container_id>`
  - Inspection: `docker inspect <container_id>`
  - Reference in other resources

### `container_name`
- **Type**: string
- **Purpose**: Human-readable container name
- **Use Cases**:
  - Service discovery within Docker network
  - Logging and monitoring
  - Documentation

### `image_id`
- **Type**: string
- **Purpose**: SHA256 hash of the Docker image
- **Use Cases**:
  - Verify exact image version deployed
  - Track image changes over time
  - Debugging image-related issues

## 🔍 How Terraform Manages Docker Containers

### State Management
Terraform tracks container state in `terraform.tfstate`:
- Container ID
- Configuration (ports, env vars, etc.)
- Image reference

### Lifecycle Operations

#### `terraform plan`
- Checks if container exists
- Compares current state with desired state
- Shows what will change

#### `terraform apply`
- Pulls image if needed
- Creates container with specified config
- Starts container
- Updates state file

#### `terraform destroy`
- Stops container
- Removes container
- Optionally removes image (based on `keep_image_locally`)

### Change Detection
Terraform recreates container when these change:
- Image name/tag
- Port mappings
- Environment variables
- Command
- Network configuration

## 🎓 Learning Examples

### Example 1: Simple Web Server
```hcl
module "nginx" {
  source = "../../modules/docker-container"

  container_name = "web-server"
  image_name     = "nginx:alpine"
  network_name   = "web-network"

  ports = [{
    internal = 80
    external = 8080
    protocol = "tcp"
  }]
}
```
**What happens:**
1. Terraform pulls `nginx:alpine` image
2. Creates container named "web-server"
3. Maps host port 8080 to container port 80
4. Connects to "web-network"
5. Access via `http://localhost:8080`

### Example 2: Backend API with Config
```hcl
module "api" {
  source = "../../modules/docker-container"

  container_name = "backend-api"
  image_name     = "node:18-alpine"
  network_name   = "app-network"

  ports = [{
    internal = 3000
    external = 3000
    protocol = "tcp"
  }]

  environment = {
    NODE_ENV = "production"
    PORT     = "3000"
    DB_HOST  = "postgres"  # References another container
  }

  command = ["node", "index.js"]
}
```
**What happens:**
1. Pulls Node.js 18 Alpine image
2. Sets environment variables for configuration
3. Runs custom command `node index.js`
4. Can communicate with "postgres" container via network

### Example 3: Development Container
```hcl
module "dev_app" {
  source = "../../modules/docker-container"

  container_name = "dev-environment"
  image_name     = "python:3.11-slim"
  network_name   = "dev-network"

  ports = [{
    internal = 8000
    external = 8000
    protocol = "tcp"
  }]

  environment = {
    PYTHONUNBUFFERED = "1"
    DEBUG            = "true"
  }

  command = ["python", "-m", "http.server", "8000"]

  keep_image_locally = true  # Keep image for faster rebuilds
}
```

## 🔧 Troubleshooting

### Container Won't Start
```bash
# Check container logs
docker logs <container_name>

# Inspect container
docker inspect <container_name>

# Check Terraform state
terraform show
```

### Port Already in Use
```bash
# Find process using port
lsof -i :8080

# Kill process or change port in configuration
```

### Network Issues
```bash
# List networks
docker network ls

# Inspect network
docker network inspect <network_name>

# Verify container is connected
docker inspect <container_name> | grep NetworkMode
```

## 🎯 Best Practices

1. **Always specify image tags**: Avoid `:latest` for reproducibility
2. **Use descriptive names**: Makes debugging easier
3. **Group related containers**: Use same network for services that communicate
4. **Externalize configuration**: Use environment variables instead of hardcoding
5. **Document port mappings**: Comment why each port is exposed
6. **Test locally first**: Validate containers work before deploying

## 📚 Additional Resources

- [Terraform Docker Provider Docs](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [Docker Networking Guide](https://docs.docker.com/network/)
- [Docker Environment Variables](https://docs.docker.com/compose/environment-variables/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | ~> 3.0 |

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
