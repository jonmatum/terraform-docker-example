# Development Guide

## Setup Development Environment

### Quick Setup

```bash
make setup
```

This installs:
- pre-commit
- terraform-docs
- tflint
- shellcheck

### Manual Setup

Run the setup script:
```bash
./scripts/setup-dev.sh
```

Or install tools individually:

1. **Install pre-commit**
   ```bash
   pip install pre-commit
   pre-commit install
   ```

2. **Install terraform-docs**
   ```bash
   # macOS
   brew install terraform-docs

   # Linux
   curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.17.0/terraform-docs-v0.17.0-$(uname)-amd64.tar.gz
   tar -xzf terraform-docs.tar.gz
   sudo mv terraform-docs /usr/local/bin/
   ```

3. **Install tflint**
   ```bash
   # macOS
   brew install tflint

   # Linux
   curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
   ```

4. **Initialize tflint**
   ```bash
   tflint --init
   ```

## Pre-commit Hooks

Pre-commit hooks run automatically before each commit:

- **trailing-whitespace** - Remove trailing whitespace
- **end-of-file-fixer** - Ensure files end with newline
- **check-yaml** - Validate YAML syntax
- **check-merge-conflict** - Detect merge conflicts
- **detect-private-key** - Prevent committing private keys
- **terraform_fmt** - Format Terraform files
- **terraform_validate** - Validate Terraform syntax
- **terraform_docs** - Generate module documentation
- **terraform_tflint** - Lint Terraform files
- **shellcheck** - Lint shell scripts

### Run Manually

```bash
# Run all hooks
make run-hooks
# or
pre-commit run --all-files

# Run specific hook
pre-commit run terraform_fmt --all-files
pre-commit run terraform_validate --all-files
```

## Validation Scripts

### Validate All Terraform

```bash
make validate
# or
./scripts/validate.sh
```

Checks:
- Terraform formatting
- Terraform validation
- All examples and modules

### Generate Documentation

```bash
make docs
# or
./scripts/generate-docs.sh
```

Generates:
- Module README.md files
- Example README.md files
- Terraform inputs/outputs tables

## Development Workflow

### Using Make (Recommended)

1. **Setup environment** (first time only)
   ```bash
   make setup
   ```

2. **Make changes**
   ```bash
   # Edit Terraform files
   vim modules/docker-container/main.tf
   ```

3. **Format and validate**
   ```bash
   make check
   ```

4. **Generate docs**
   ```bash
   make docs
   ```

5. **Run all checks**
   ```bash
   make ci
   ```

6. **Commit** (pre-commit runs automatically)
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

### Manual Workflow

1. **Make changes**
   ```bash
   # Edit Terraform files
   vim modules/docker-container/main.tf
   ```

2. **Format code**
   ```bash
   terraform fmt -recursive
   ```

3. **Validate**
   ```bash
   ./scripts/validate.sh
   ```

4. **Generate docs**
   ```bash
   ./scripts/generate-docs.sh
   ```

5. **Commit** (pre-commit runs automatically)
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

## CI/CD

GitHub Actions runs on every push and PR:

- Terraform format check
- Terraform validation
- TFLint checks
- Pre-commit hooks

See `.github/workflows/terraform.yml`

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new module
fix: correct variable type
docs: update README
chore: update dependencies
test: add validation tests
```

## Testing

### Quick Test All

```bash
make test-all
```

### Test Individual Examples

```bash
make test-basic      # Test 01-basic-docker
make test-fastapi    # Test 02-fastapi-react
make test-ecs        # Test 04-ecs-localstack
```

### Test Examples Manually

```bash
# Basic Docker
cd examples/01-basic-docker
terraform init
terraform plan
terraform apply
terraform destroy

# FastAPI + React
cd examples/02-fastapi-react
terraform init
terraform apply
terraform destroy

# ECS LocalStack
cd examples/04-ecs-localstack
./test.sh
```

## Troubleshooting

### Pre-commit fails

```bash
# Update hooks
pre-commit autoupdate

# Clear cache
pre-commit clean

# Reinstall
pre-commit uninstall
pre-commit install
```

### Terraform validation fails

```bash
# Clean and reinit
rm -rf .terraform
terraform init
```

### TFLint issues

```bash
# Reinitialize plugins
tflint --init

# Run with debug
tflint --loglevel=debug
```

## Resources

- [GNU Make](https://www.gnu.org/software/make/manual/make.html)
- [Pre-commit](https://pre-commit.com/)
- [Terraform Docs](https://terraform-docs.io/)
- [TFLint](https://github.com/terraform-linters/tflint)
- [Conventional Commits](https://www.conventionalcommits.org/)
