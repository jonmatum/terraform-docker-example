#!/bin/bash

# Setup script for pre-commit hooks and development tools

set -e

echo "🚀 Setting up development environment..."

# Check if Homebrew is installed (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install: https://brew.sh"
    exit 1
  fi
fi

# Install pre-commit
echo "📦 Installing pre-commit..."
if command -v pip3 &> /dev/null; then
  pip3 install pre-commit
elif command -v pip &> /dev/null; then
  pip install pre-commit
else
  echo "❌ pip not found. Please install Python and pip first."
  exit 1
fi

# Install terraform-docs
echo "📦 Installing terraform-docs..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install terraform-docs
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  curl -sSLo ./terraform-docs.tar.gz "https://terraform-docs.io/dl/v0.17.0/terraform-docs-v0.17.0-$(uname)-amd64.tar.gz"
  tar -xzf terraform-docs.tar.gz
  chmod +x terraform-docs
  sudo mv terraform-docs /usr/local/bin/
  rm terraform-docs.tar.gz
fi

# Install tflint
echo "📦 Installing tflint..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install tflint
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
fi

# Install shellcheck
echo "📦 Installing shellcheck..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install shellcheck
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt-get update && sudo apt-get install -y shellcheck
fi

# Initialize tflint plugins
echo "🔧 Initializing tflint plugins..."
tflint --init

# Install pre-commit hooks
echo "🔧 Installing pre-commit hooks..."
pre-commit install
pre-commit install --hook-type commit-msg

# Run pre-commit on all files
echo "✅ Running pre-commit on all files..."
pre-commit run --all-files || true

echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "📝 Available commands:"
echo "  pre-commit run --all-files    # Run all hooks"
echo "  terraform fmt -recursive       # Format Terraform files"
echo "  terraform validate            # Validate Terraform"
echo "  tflint                        # Lint Terraform files"
echo "  terraform-docs .              # Generate docs"
echo ""
echo "🎉 You're ready to contribute!"
