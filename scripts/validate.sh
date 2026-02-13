#!/bin/bash

# Validate all Terraform configurations in the repository

set -e

echo "🔍 Validating Terraform configurations..."

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Find all directories with .tf files
DIRS=$(find . -name "*.tf" -not -path "*/.terraform/*" -exec dirname {} \; | sort -u)

FAILED=0
PASSED=0

for dir in $DIRS; do
  echo ""
  echo -e "${YELLOW}Checking: $dir${NC}"

  cd "$dir"

  # Format check
  if terraform fmt -check -recursive > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Format OK${NC}"
  else
    echo -e "${RED}✗ Format issues found${NC}"
    terraform fmt -recursive
    FAILED=$((FAILED + 1))
  fi

  # Initialize if needed
  if [ ! -d ".terraform" ]; then
    echo "  Initializing..."
    terraform init -backend=false > /dev/null 2>&1 || true
  fi

  # Validate
  if terraform validate > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Validation passed${NC}"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗ Validation failed${NC}"
    terraform validate
    FAILED=$((FAILED + 1))
  fi

  cd - > /dev/null
done

echo ""
echo "================================"
if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✅ All checks passed! ($PASSED directories)${NC}"
  exit 0
else
  echo -e "${RED}❌ Some checks failed! ($FAILED failures, $PASSED passed)${NC}"
  exit 1
fi
