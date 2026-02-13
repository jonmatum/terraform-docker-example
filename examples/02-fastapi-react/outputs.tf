output "backend_url" {
  description = "Backend API URL"
  value       = "http://localhost:8000"
}

output "frontend_url" {
  description = "Frontend URL"
  value       = "http://localhost:5173"
}

output "backend_container_id" {
  description = "Backend container ID"
  value       = module.backend.container_id
}

output "frontend_container_id" {
  description = "Frontend container ID"
  value       = module.frontend.container_id
}
