#!/bin/bash

# Generate Terraform documentation for all modules

set -e

echo "📚 Generating Terraform documentation..."

# Check if terraform-docs is installed
if ! command -v terraform-docs &> /dev/null; then
  echo "❌ terraform-docs not found. Please install it first."
  echo "   macOS: brew install terraform-docs"
  echo "   Linux: https://terraform-docs.io/user-guide/installation/"
  exit 1
fi

# Generate docs for modules
echo ""
echo "Generating module documentation..."

for module in modules/*/; do
  if [ -f "$module/main.tf" ]; then
    echo "  → $module"
    terraform-docs markdown table --output-file README.md --output-mode inject "$module"
  fi
done

# Generate docs for examples
echo ""
echo "Generating example documentation..."

for example in examples/*/; do
  if [ -f "$example/main.tf" ]; then
    echo "  → $example"
    terraform-docs markdown table --output-file README.md --output-mode inject "$example"
  fi
done

echo ""
echo "✅ Documentation generation complete!"
