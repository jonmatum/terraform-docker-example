terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "advanced-app-network"
}

resource "docker_image" "backend" {
  name = "fastapi-backend"
  build {
    context    = "${path.module}/backend"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "frontend" {
  name = "react-frontend"
  build {
    context    = "${path.module}/frontend"
    dockerfile = "Dockerfile"
  }
}

module "backend" {
  source = "../../modules/docker-container"

  container_name = "fastapi-backend"
  image_name     = docker_image.backend.name
  network_name   = docker_network.app_network.name

  ports = [{
    internal = 8000
    external = 8000
  }]

  environment = {
    PYTHONUNBUFFERED = "1"
  }
}

module "frontend" {
  source = "../../modules/docker-container"

  container_name = "react-frontend"
  image_name     = docker_image.frontend.name
  network_name   = docker_network.app_network.name

  ports = [{
    internal = 5173
    external = 5173
  }]

  environment = {
    VITE_API_URL = "http://localhost:8000"
  }
}
