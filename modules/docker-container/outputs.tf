output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.this.id
}

output "container_name" {
  description = "Name of the Docker container"
  value       = docker_container.this.name
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.this.image_id
}
