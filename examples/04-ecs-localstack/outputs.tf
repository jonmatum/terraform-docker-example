output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.nginx_service.cluster_name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.nginx_service.cluster_arn
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = module.nginx_service.task_definition_arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.nginx_service.service_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.public.id
}
