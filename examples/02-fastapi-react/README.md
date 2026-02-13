# Advanced Example: FastAPI + React

Full-stack application with FastAPI backend and React+Vite frontend, demonstrating custom Dockerfiles and real application code.

## What This Example Does

- Builds a FastAPI backend from a custom Dockerfile
- Builds a React+Vite frontend from a custom Dockerfile
- Creates a Docker network for container communication
- Frontend fetches and displays data from the backend API
- Uses the reusable docker-container module

## Structure

```
advanced-example/
├── backend/
│   ├── main.py              # FastAPI application
│   ├── requirements.txt     # Python dependencies
│   └── Dockerfile           # Backend container image
├── frontend/
│   ├── src/
│   │   ├── App.jsx         # React component
│   │   ├── main.jsx        # React entry point
│   │   ├── App.css         # Component styles
│   │   └── index.css       # Global styles
│   ├── index.html          # HTML template
│   ├── package.json        # Node dependencies
│   ├── vite.config.js      # Vite configuration
│   └── Dockerfile          # Frontend container image
├── main.tf                 # Terraform configuration
├── outputs.tf              # Output definitions
└── README.md               # This file
```

## Prerequisites

- Docker Desktop or Docker Engine installed and running
- Terraform >= 1.0 installed
- At least 2GB free disk space (for Docker images)

## Usage

### 1. Initialize Terraform

```bash
cd advanced-example
terraform init
```

### 2. Build and Deploy

```bash
terraform apply
```

This will:
- Build the FastAPI Docker image (Python 3.11)
- Build the React+Vite Docker image (Node 20)
- Create a Docker network
- Start both containers

**Note**: First build takes 2-5 minutes to download base images and install dependencies.

### 3. Access the Applications

- **Frontend**: http://localhost:5173
  - Displays "Hello World from FastAPI!" fetched from the backend
- **Backend API**: http://localhost:8000
  - Returns JSON: `{"message": "Hello World from FastAPI!"}`

### 4. View Outputs

```bash
terraform output
```

Shows container IDs and access URLs.

### 5. Make Changes

Edit the backend message:
```python
# backend/main.py
@app.get("/")
def hello():
    return {"message": "Your custom message!"}
```

Apply changes:
```bash
terraform apply
```

Terraform will rebuild only the changed image.

### 6. Clean Up

```bash
terraform destroy
```

Removes all containers, images, and networks.

## What You'll Learn

- Building custom Docker images with Terraform
- Using the `docker_image` resource with `build` block
- Creating full-stack applications with Terraform
- Container networking and service communication
- Managing environment variables
- CORS configuration for API access

## API Endpoints

### Backend (FastAPI)

- `GET /` - Returns hello world message
- `GET /docs` - Swagger UI documentation (http://localhost:8000/docs)

## Troubleshooting

**Build fails:**
- Ensure Docker daemon is running
- Check Docker has internet access to pull base images
- Verify sufficient disk space

**Frontend can't reach backend:**
- Check both containers are running: `docker ps`
- Verify network: `docker network inspect advanced-app-network`
- Check CORS is enabled in `backend/main.py`

**Port already in use:**
- Change ports in `main.tf`:
  ```hcl
  ports = [{
    internal = 8000
    external = 8001  # Change this
  }]
  ```

**Container exits immediately:**
- Check logs: `docker logs fastapi-backend` or `docker logs react-frontend`
- Verify Dockerfile CMD is correct

## Customization

### Change Backend Port

Edit `main.tf`:
```hcl
module "backend" {
  ports = [{
    internal = 8000
    external = 9000  # New port
  }]
}
```

Update frontend to use new port in `frontend/src/App.jsx`:
```javascript
fetch('http://localhost:9000')
```

### Add Backend Endpoints

Edit `backend/main.py`:
```python
@app.get("/api/users")
def get_users():
    return {"users": ["Alice", "Bob"]}
```

### Modify Frontend UI

Edit `frontend/src/App.jsx` to customize the React component.

## Comparison with Docker Compose

See `../docker-compose-example/` for the same application using Docker Compose instead of Terraform.
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
| <a name="module_backend"></a> [backend](#module\_backend) | ../modules/docker-container | n/a |
| <a name="module_frontend"></a> [frontend](#module\_frontend) | ../modules/docker-container | n/a |

## Resources

| Name | Type |
|------|------|
| [docker_image.backend](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |
| [docker_image.frontend](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |
| [docker_network.app_network](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/network) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_container_id"></a> [backend\_container\_id](#output\_backend\_container\_id) | Backend container ID |
| <a name="output_backend_url"></a> [backend\_url](#output\_backend\_url) | Backend API URL |
| <a name="output_frontend_container_id"></a> [frontend\_container\_id](#output\_frontend\_container\_id) | Frontend container ID |
| <a name="output_frontend_url"></a> [frontend\_url](#output\_frontend\_url) | Frontend URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
