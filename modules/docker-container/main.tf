terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "this" {
  name         = var.image_name
  keep_locally = var.keep_image_locally
}

resource "docker_container" "this" {
  name    = var.container_name
  image   = docker_image.this.image_id
  command = var.command

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  env = [for k, v in var.environment : "${k}=${v}"]

  networks_advanced {
    name = var.network_name
  }
}
