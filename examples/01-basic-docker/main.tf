terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app-network"
}

module "backend" {
  source = "../modules/docker-container"

  container_name = "backend"
  image_name     = "node:18-alpine"
  network_name   = docker_network.app_network.name
  command        = ["node", "-e", "require('http').createServer((req,res)=>res.end('Backend running')).listen(3000)"]

  ports = [{
    internal = 3000
    external = 3000
  }]

  environment = {
    NODE_ENV = "production"
    PORT     = "3000"
  }
}

module "frontend" {
  source = "../modules/docker-container"

  container_name = "frontend"
  image_name     = "nginx:alpine"
  network_name   = docker_network.app_network.name

  ports = [{
    internal = 80
    external = 8080
  }]

  environment = {
    BACKEND_URL = "http://backend:3000"
  }
}
