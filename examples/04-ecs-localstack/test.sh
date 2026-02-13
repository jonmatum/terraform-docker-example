#!/bin/bash

# ECS LocalStack Test Script
# Tests the ECS module with LocalStack

set -e

echo "🚀 Starting ECS LocalStack Test..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Start LocalStack
echo -e "${YELLOW}📦 Starting LocalStack...${NC}"
docker-compose up -d

# Wait for LocalStack
echo -e "${YELLOW}⏳ Waiting for LocalStack to be ready...${NC}"
sleep 15

# Check LocalStack health
echo -e "${YELLOW}🏥 Checking LocalStack health...${NC}"
curl -s http://localhost:4566/_localstack/health | grep -q "running" && \
  echo -e "${GREEN}✅ LocalStack is healthy${NC}" || \
  (echo -e "${RED}❌ LocalStack is not healthy${NC}" && exit 1)

# Initialize Terraform
echo -e "${YELLOW}🔧 Initializing Terraform...${NC}"
terraform init

# Apply Terraform
echo -e "${YELLOW}🏗️  Applying Terraform configuration...${NC}"
terraform apply -auto-approve

# Verify ECS resources
echo -e "${YELLOW}🔍 Verifying ECS resources...${NC}"

ENDPOINT="http://localhost:4566"

# Check cluster
echo -e "${YELLOW}Checking ECS cluster...${NC}"
aws --endpoint-url=$ENDPOINT ecs list-clusters | grep -q "test-cluster" && \
  echo -e "${GREEN}✅ Cluster created${NC}" || \
  echo -e "${RED}❌ Cluster not found${NC}"

# Check task definition
echo -e "${YELLOW}Checking task definition...${NC}"
aws --endpoint-url=$ENDPOINT ecs list-task-definitions | grep -q "nginx-task" && \
  echo -e "${GREEN}✅ Task definition created${NC}" || \
  echo -e "${RED}❌ Task definition not found${NC}"

# Check service
echo -e "${YELLOW}Checking ECS service...${NC}"
aws --endpoint-url=$ENDPOINT ecs list-services --cluster test-cluster | grep -q "nginx-service" && \
  echo -e "${GREEN}✅ Service created${NC}" || \
  echo -e "${RED}❌ Service not found${NC}"

# Show outputs
echo -e "${YELLOW}📊 Terraform outputs:${NC}"
terraform output

# Clean up
echo -e "${YELLOW}🧹 Cleaning up...${NC}"
terraform destroy -auto-approve
docker-compose down

echo -e "${GREEN}✅ Test completed successfully!${NC}"
