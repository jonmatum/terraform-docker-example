output "backend_container_id" {
  description = "Backend container ID"
  value       = module.backend.container_id
}

output "frontend_container_id" {
  description = "Frontend container ID"
  value       = module.frontend.container_id
}

output "backend_url" {
  description = "Backend URL"
  value       = "http://localhost:3000"
}

output "frontend_url" {
  description = "Frontend URL"
  value       = "http://localhost:8080"
}
