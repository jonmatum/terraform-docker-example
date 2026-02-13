variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "image_name" {
  description = "Docker image name with tag"
  type        = string
}

variable "ports" {
  description = "Port mappings for the container"
  type = list(object({
    internal = number
    external = number
  }))
  default = []
}

variable "environment" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "keep_image_locally" {
  description = "Keep image locally after destroy"
  type        = bool
  default     = false
}

variable "command" {
  description = "Command to run in the container"
  type        = list(string)
  default     = []
}
