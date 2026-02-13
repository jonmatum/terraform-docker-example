.PHONY: help setup validate fmt docs test clean install-hooks run-hooks

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Development setup
setup: ## Setup development environment (install tools and hooks)
	@./scripts/setup-dev.sh

install-hooks: ## Install pre-commit hooks only
	@pre-commit install
	@pre-commit install --hook-type commit-msg
	@echo "✅ Pre-commit hooks installed"

# Validation and formatting
validate: ## Validate all Terraform configurations
	@./scripts/validate.sh

fmt: ## Format all Terraform files
	@echo "🎨 Formatting Terraform files..."
	@terraform fmt -recursive
	@echo "✅ Formatting complete"

lint: ## Run TFLint on all files
	@echo "🔍 Running TFLint..."
	@for dir in modules/*/ examples/*/; do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "  → $$dir"; \
			cd "$$dir" && tflint --config=../../.tflint.hcl && cd - > /dev/null; \
		fi \
	done
	@echo "✅ Linting complete"

# Documentation
docs: ## Generate Terraform documentation
	@./scripts/generate-docs.sh

# Pre-commit
run-hooks: ## Run all pre-commit hooks
	@pre-commit run --all-files

update-hooks: ## Update pre-commit hook versions
	@pre-commit autoupdate
	@echo "✅ Hooks updated"

# Testing
test-basic: ## Test basic Docker example
	@echo "🧪 Testing 01-basic-docker..."
	@cd examples/01-basic-docker && terraform init -upgrade && terraform validate
	@echo "✅ Basic example validated"

test-fastapi: ## Test FastAPI + React example
	@echo "🧪 Testing 02-fastapi-react..."
	@cd examples/02-fastapi-react && terraform init -upgrade && terraform validate
	@echo "✅ FastAPI example validated"

test-ecs: ## Test ECS LocalStack example
	@echo "🧪 Testing 04-ecs-localstack..."
	@cd examples/04-ecs-localstack && terraform init -upgrade && terraform validate
	@echo "✅ ECS example validated"

test-all: test-basic test-fastapi test-ecs ## Run all tests
	@echo "✅ All tests passed"

# Cleanup
clean: ## Clean Terraform files and caches
	@echo "🧹 Cleaning..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@echo "✅ Cleanup complete"

clean-all: clean ## Clean everything including pre-commit cache
	@pre-commit clean
	@echo "✅ Full cleanup complete"

# CI/CD simulation
ci: fmt validate lint run-hooks test-all ## Run full CI pipeline locally
	@echo "✅ CI pipeline complete"

# Quick commands
init: ## Initialize all examples
	@echo "🔧 Initializing all examples..."
	@for dir in examples/*/; do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "  → $$dir"; \
			cd "$$dir" && terraform init -upgrade && cd -; \
		fi \
	done
	@echo "✅ All examples initialized"

check: fmt validate ## Quick check (format + validate)
	@echo "✅ Quick check complete"
