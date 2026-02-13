# Contributing to Terraform Docker Modules

Thank you for your interest in contributing! This document provides guidelines and instructions.

## Code of Conduct

Be respectful, inclusive, and professional in all interactions.

## How to Contribute

### Reporting Issues

- Use GitHub Issues
- Provide clear description and reproduction steps
- Include Terraform and Docker versions
- Add relevant logs or error messages

### Suggesting Features

- Open a GitHub Issue with the `enhancement` label
- Describe the use case and expected behavior
- Explain why this would be useful

### Submitting Changes

1. **Fork the repository**

2. **Create a feature branch**
   ```bash
   git checkout -b feat/your-feature
   ```

3. **Setup development environment**
   ```bash
   make setup
   ```

4. **Make your changes**
   - Follow existing code style
   - Add/update tests if applicable
   - Update documentation

5. **Run checks**
   ```bash
   make ci
   ```

6. **Commit with conventional commits**
   ```bash
   git commit -m "feat: add new feature"
   ```

7. **Push and create PR**
   ```bash
   git push origin feat/your-feature
   ```

## Commit Message Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Examples

```bash
feat: add ECS Fargate module
fix: correct port mapping in docker module
docs: update README with new examples
chore: update dependencies
```

## Development Workflow

1. **Setup**
   ```bash
   make setup
   ```

2. **Make changes**
   ```bash
   # Edit files
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

5. **Test**
   ```bash
   make test-all
   ```

6. **Run full CI**
   ```bash
   make ci
   ```

7. **Commit** (pre-commit hooks run automatically)
   ```bash
   git add .
   git commit -m "feat: your changes"
   ```

## Pull Request Guidelines

- Keep PRs focused on a single change
- Update documentation for new features
- Add tests if applicable
- Ensure all CI checks pass
- Link related issues
- Provide clear description

## Release Process

Releases are automated using [release-please](https://github.com/googleapis/release-please):

1. Merge PRs to `main` with conventional commits
2. Release-please creates a release PR
3. Merge the release PR to create a new release
4. GitHub automatically creates a tag and release notes

## Module Guidelines

### Structure

```
modules/your-module/
├── main.tf          # Main resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
└── README.md        # Documentation (auto-generated)
```

### Best Practices

- Use descriptive variable names
- Add descriptions to all variables and outputs
- Use sensible defaults where possible
- Document required vs optional variables
- Follow Terraform naming conventions
- Keep modules focused and reusable

### Documentation

Documentation is auto-generated using terraform-docs:

```bash
make docs
```

Add descriptions to variables and outputs:

```hcl
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}
```

## Example Guidelines

### Structure

```
examples/XX-example-name/
├── main.tf          # Main configuration
├── outputs.tf       # Outputs
├── README.md        # Documentation
└── (app files)      # Application code if needed
```

### Best Practices

- Keep examples simple and focused
- Include clear README with usage instructions
- Test examples before submitting
- Use realistic but minimal configurations

## Testing

### Manual Testing

```bash
# Test specific example
cd examples/01-basic-docker
terraform init
terraform plan
terraform apply
terraform destroy

# Test all examples
make test-all
```

### Automated Testing

CI runs on every PR:
- Terraform format check
- Terraform validation
- TFLint checks
- Pre-commit hooks

## Questions?

- Open a GitHub Issue
- Check existing documentation
- Review closed issues and PRs

Thank you for contributing! 🎉
