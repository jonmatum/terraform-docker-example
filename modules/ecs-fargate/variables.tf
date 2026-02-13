variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "Family name for the task definition"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "container_ports" {
  description = "List of container ports to expose"
  type        = list(number)
  default     = []
}

variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory for the task in MB (512, 1024, 2048, etc.)"
  type        = string
  default     = "512"
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "create_service" {
  description = "Whether to create an ECS service"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs for the service"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
