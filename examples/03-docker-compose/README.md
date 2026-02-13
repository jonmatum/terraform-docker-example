# Docker Compose Example: FastAPI + React

Same application as the advanced Terraform example, but using Docker Compose for comparison.

## What This Example Does

- Runs the same FastAPI + React application
- Uses Docker Compose instead of Terraform
- Demonstrates the simpler Docker Compose approach
- Perfect for local development

## Structure

```
docker-compose-example/
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
├── docker-compose.yml      # Docker Compose configuration
└── README.md               # This file
```

## Prerequisites

- Docker Desktop or Docker Engine installed and running
- Docker Compose (included with Docker Desktop)

## Usage

### 1. Start All Services

```bash
cd docker-compose-example
docker-compose up --build
```

This will:
- Build both Docker images
- Create a network
- Start backend and frontend containers
- Show logs in the terminal

**First build takes 2-5 minutes.**

### 2. Run in Background (Detached Mode)

```bash
docker-compose up -d --build
```

### 3. Access the Applications

- **Frontend**: http://localhost:5173
  - Displays "Hello World from FastAPI!" from the backend
- **Backend API**: http://localhost:8000
  - Returns JSON: `{"message": "Hello World from FastAPI!"}`
- **API Docs**: http://localhost:8000/docs

### 4. View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### 5. Stop Services

```bash
# Stop and remove containers
docker-compose down

# Stop, remove containers, and remove images
docker-compose down --rmi all

# Stop, remove everything including volumes
docker-compose down -v --rmi all
```

### 6. Restart After Changes

```bash
# Rebuild and restart
docker-compose up --build

# Restart specific service
docker-compose restart backend
```

## Docker Compose Commands

| Command | Description |
|---------|-------------|
| `docker-compose up` | Start services |
| `docker-compose up -d` | Start in background |
| `docker-compose up --build` | Rebuild and start |
| `docker-compose down` | Stop and remove containers |
| `docker-compose ps` | List running services |
| `docker-compose logs` | View logs |
| `docker-compose logs -f` | Follow logs |
| `docker-compose restart` | Restart services |
| `docker-compose exec backend bash` | Shell into backend |

## Configuration File Explained

```yaml
version: '3.8'

services:
  backend:
    build: ./backend          # Build from Dockerfile
    ports:
      - "8000:8000"          # Host:Container
    environment:
      - PYTHONUNBUFFERED=1   # Python env var
    networks:
      - app-network          # Connect to network

  frontend:
    build: ./frontend
    ports:
      - "5173:5173"
    depends_on:
      - backend              # Start after backend
    networks:
      - app-network

networks:
  app-network:               # Create network
    driver: bridge
```

## Key Differences: Docker Compose vs Terraform

### Docker Compose Advantages:
✅ Simpler syntax (YAML vs HCL)
✅ Single file configuration
✅ Faster to get started
✅ Built-in log aggregation
✅ Perfect for local development
✅ No state management needed

### Terraform Advantages:
✅ State tracking (knows what changed)
✅ Reusable modules
✅ Can manage cloud resources (AWS, Azure, etc.)
✅ Better for production infrastructure
✅ Plan before apply
✅ Remote state for team collaboration

### When to Use What:

**Use Docker Compose:**
- Local development
- Simple multi-container apps
- Quick prototyping
- Docker-only projects

**Use Terraform:**
- Production deployments
- Infrastructure as Code
- Multi-cloud environments
- Reusable infrastructure modules
- Team collaboration with state management

## Comparison Table

| Feature | Docker Compose | Terraform |
|---------|---------------|-----------|
| **Config** | `docker-compose.yml` (30 lines) | Multiple `.tf` files (60+ lines) |
| **Start** | `docker-compose up` | `terraform apply` |
| **Stop** | `docker-compose down` | `terraform destroy` |
| **Preview** | No preview | `terraform plan` |
| **State** | No state tracking | `.tfstate` file |
| **Modules** | No | Yes (reusable) |
| **Logs** | `docker-compose logs` | `docker logs <name>` |
| **Rebuild** | `--build` flag | Automatic detection |
| **Scope** | Docker only | Docker + Cloud |

## Troubleshooting

**Port already in use:**
```yaml
# Change in docker-compose.yml
ports:
  - "8001:8000"  # Use different host port
```

**Container exits immediately:**
```bash
docker-compose logs backend
docker-compose logs frontend
```

**Rebuild after code changes:**
```bash
docker-compose up --build
```

**Remove everything:**
```bash
docker-compose down -v --rmi all
```

**Check running containers:**
```bash
docker-compose ps
```

## Making Changes

### Modify Backend

Edit `backend/main.py`:
```python
@app.get("/")
def hello():
    return {"message": "Your custom message!"}
```

Restart:
```bash
docker-compose restart backend
```

### Modify Frontend

Edit `frontend/src/App.jsx`, then:
```bash
docker-compose restart frontend
```

## Next Steps

- Compare with `../advanced-example/` (Terraform version)
- Try modifying the API endpoints
- Add more services to `docker-compose.yml`
- Explore Docker Compose features like volumes and health checks
