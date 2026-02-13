terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key_id               = "test"
  secret_access_key           = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ecs  = "http://localhost:4566"
    ecr  = "http://localhost:4566"
    ec2  = "http://localhost:4566"
    iam  = "http://localhost:4566"
    logs = "http://localhost:4566"
    sts  = "http://localhost:4566"
  }
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ecs-test-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ecs-test-subnet"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-tasks-sg"
  }
}

# IAM Roles
resource "aws_iam_role" "ecs_execution" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/nginx-app"
  retention_in_days = 1
}

# ECS Service using the module
module "nginx_service" {
  source = "../../modules/ecs-fargate"

  cluster_name    = "test-cluster"
  task_family     = "nginx-task"
  container_name  = "nginx"
  container_image = "nginx:alpine"
  container_ports = [80]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  log_group_name     = aws_cloudwatch_log_group.app.name
  aws_region         = "us-east-1"

  create_service     = true
  service_name       = "nginx-service"
  desired_count      = 1
  subnet_ids         = [aws_subnet.public.id]
  security_group_ids = [aws_security_group.ecs_tasks.id]
  assign_public_ip   = true

  environment = {
    ENVIRONMENT = "localstack"
    APP_NAME    = "nginx-test"
  }

  tags = {
    Environment = "localstack"
    ManagedBy   = "terraform"
  }
}
